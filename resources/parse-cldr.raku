use lib BEGIN $?FILE.IO.parent.parent.add('lib').resolve;
use XML;
use MONKEY-SEE-NO-EVAL;
use Data::Dump::Tree;
use JSON::Tiny;
use Intl::CLDR::Util::StrEncode;
use Intl::CLDR::Util::StrDecode;
use Intl::CLDR::Types::Language;
use Intl::LanguageTag;
use Intl::CLDR::Util::XML-Helper;


=begin pod
To use this script, simply execute it.  By default, it will process the whole of the CLDR.
Because it must load files in a particular order, it is not easily parallelizable.  Thus,
it is recommended to run the command on just a few letters at a time.  To run on languages
whose codes begin with C<a>, C<i>, and C<x>, use

    raku parse-cldr.raku a i x

You must ensure that a copy of the CLDR data is included in the resources folder, and renamed to
exclude the version information, that is, under C<cldr-common> (such that the path to English's
data is C<resources/cldr-common/common/main/en.xml>.  This is excluded from distribution to
reduce file size, although technically Unicode's license would permit it.

The basic process for generating the data files is as follows:

  1. Read the base XML files (en, es, etc)
  2. For each sub file, deep copy using C<from-json to-json %hash.raku>, and apply the new data (en-US, es-ES, etc)
     on top of it using C<parse>
  3. Then, using C<encode>, generate the two data files -- a binary tree file and a strings file.
  4. The strings file is interpreted as a giant array, so that the binary file may easily reference
     the strings (many strings are repeated, so this saves space).

The <alias> tag only exists for root, and not for any other language.  They are ignored by parse, and the fallback
interpretations are generally handled in the C<encode> methods.  This means data may be duplicated (but duplicate
strings are practically free).  The slight increase in memory is well worth the speed improvements.

There are a number of subs available to C<parse> via C<Intl::CLDR::Util::XML-Helper>  to keep things simple:
  - elem $xml, $tag   OR   $xml.&elem($tag)
      Returns a single child element matching the tag when we know there will be only one element. Dies if more than one.
  - elems $xml, $tags  OR  $xml.&elems($tag)
      Returns a child elements matching the tag
  - contents $xml
      Returns the text content of the tag
=end pod

my $total-load-time = 0;

sub MAIN (*@letters, Bool :$supplement, Int :$threads = 4) {
    @letters ||= <a b c d e f g h i j k l m n o p q r s t u v w x y z>;

    say "\x001b[31mThis process may take a very long time if handling all files at once\n"
       ~ "You may want to provide only a single letter or two as an argument\n"
       ~ "to limit the scope of the parse process.\x001b[0m"
      if @letters == 26;

    my %*results;

    # These supplemental files contain multiple languages in one,
    # using dynamic variables keep things fairly clean.
    my $*day-period-xml       = from-xml "cldr-common/common/supplemental/dayPeriods.xml".IO.slurp;
    my $*plurals-cardinal-xml = from-xml "cldr-common/common/supplemental/plurals.xml".IO.slurp;
    my $*plurals-ordinal-xml  = from-xml "cldr-common/common/supplemental/ordinals.xml".IO.slurp;
    my $*plurals-ranges-xml   = from-xml "cldr-common/common/supplemental/pluralRanges.xml".IO.slurp;
    my $*grammar-xml          = from-xml "cldr-common/common/supplemental/grammaticalFeatures.xml".IO.slurp;
    my $*subdivisions-xml     = from-xml "cldr-common/common/supplemental/subdivisions.xml".IO.slurp;

    # Unless language files are being skipped,
    # generate a list of languages to be processed
    #
    # These need to be sorted by
    #   (1) Language code length (ensures core data goes first)
    #   (2) Alphabetical (reduces likelihood core isn't finished for regional variant)
    #
    # Then root is processed immediately must go first, so it's added back in.
    my @language-files;
    unless @letters eq '...' {
        @language-files = "cldr-common/common/main".IO.dir
            .sort({ .basename.chars, .basename })
            .grep(*.basename.starts-with: any @letters)
            .grep(none *.basename eq 'root');

        handle-language "cldr-common/common/main/root.xml".IO;
    }

    # Loop through each language in the list of languages as determined above.
    # for @language-files.hyper(:1batch, :4degree) -> $language-file {
    my \CURRENT = Lock.new;
    my @current;

    hyper for @language-files.hyper(:1batch, :degree($threads)) -> $file {
        #handle-language $language-file;
        my $lang = $file.basename.subst('_','-', :g).substr(0,*-4);
        CURRENT.protect: { @current.push: $lang; print "\rEncoding ", @current.join(", "), "..." }
        handle-language $file;
        CURRENT.protect: { @current = @current.grep(* ne $lang).eager }
    }


    # Now do the supplemental
    if $supplement {
        handle-supplemental
    }

    say "Compilation complete.  Load time for {%*results.keys.elems} files was ", $total-load-time, " ({$total-load-time / %*results.keys.elems} avg)";

}


my \LOCK        = Lock.new;
my \TIMELOCK    = Lock.new;
my \DECODE-LOCK = Lock.new;
sub handle-language($language-file) {

    # The languages need a BCP47-style form (and the file names use Unicode-style)
    # Though it shouldn't be the case, if there are any non-canonical forms, we convert them
    # while ignoring 'root' since it's a psuedotag.
    my $*lang = $language-file.basename.subst('_','-', :g).substr(0, *-4);
    $*lang = LanguageTag.new($*lang).canonical
        unless $*lang eq 'root';

    my $prefix =
        "\r\x001b[37m" ~ DateTime.now.Str.substr(11..18) ~ " - \x001b[0m\x001b[34m{$*lang}\x001b[0m - ";
    # Open file unless there's a combining diacritic on a delimiter, and make sure it's got elements
    my $file;
    try {
        CATCH { say "$prefix\x001b[31mFailure\x001b[0m (could not open {$language-file})"; return }
        # We can't pass the handler directly because the XML library doesn't autoclose.
        $file = from-xml $language-file.slurp;
        if $file.elements.elems == 1 {
            say $prefix ~ "No data                    ";
            return
        }
    }

    # Data is designed to be cascading.
    # Sort order means we always will load 'en' before 'en-US' or else a fresh hash
    # The goal in this section is to load the most narrowly matching combination first
    # Deep copying of hashes is done via 'from-json to-json' because of an odd parse bug
    LOCK.protect({
        try {
            CATCH { say "{$prefix}Could not load base data for $*lang (probably the base XML file was unreadable)"; return }
            given $*lang.comb('-').elems {
                when 0 {
                    if $*lang eq 'root' {
                        %*results<root> = Hash.new
                    } else {
                        %*results{$*lang} = from-json to-json %*results<root>;
                    }
                    %*results{$*lang} := ($*lang eq 'root' ?? Hash.new !! from-json to-json %*results<root>)
                }
                default {
                    %*results{$*lang} := %*results{$*lang.split('-')[0..*-2].join('-')}:exists # in a handful of instances, removing a single tag does not result in a valid match, but removing two ALWAYS does (for now);
                        ?? (from-json to-json %*results{$*lang.split('-')[0..*-2].join('-')} )
                        !! (from-json to-json %*results{$*lang.split('-')[0..*-3].join('-')} )
                }
            }
        }
    });

    try {
        CATCH { say "$prefix\x001b[31mFailure\x001b[0m (there was a problem during loading)"; .say; return; }

        # Process and encode
        my $start = now;

        my $base;
        LOCK.protect: { $base := %*results{$*lang} };
        # ^ Probably excessive protection

        my $*STR-ENCODE = StrEncode::reset(); # clears encoder
        CLDR::Language.parse($base, $file);
        my $blob = CLDR::Language.encode: $base;

        TIMELOCK.protect: { $total-load-time += (now - $start) };

        # Ensure that we can actually read our data;
        #my str @langs = StrEncode::output().split(31.chr);

        # Write the data out
        "languages-binary/{$*lang}.data".IO.spurt:    $blob, :bin,         :close;  # binary tree data
        "languages-binary/{$*lang}.strings".IO.spurt: StrEncode::output(), :close;  # StrEncode is a bad global for now

        say "$prefix\x001b[32mSuccess\x001b[0m (strs ~", StrEncode::output().chars, " bytes, data ", $blob.elems, " bytes)";
    }
}

sub handle-supplemental {
    use Intl::CLDR::Types::Subdivisions;
    my $*subdivisions-xml = from-xml "cldr-common/common/supplemental/subdivisions.xml".IO.slurp;

    my %supplement;

    my $*STR-ENCODE = StrEncode::reset(); # clears encoder

    CLDR::Subdivisions.parse(%supplement, $);
    my $blob = CLDR::Subdivisions.encode(%supplement);

    my uint64 $offset = 0;
    StrDecode::prepare(StrEncode::output());
    my $foo = CLDR::Subdivisions.new: $blob, $offset;

    # Write the data out
    "supplemental.data".IO.spurt:    $blob, :bin,         :close;  # binary tree data
    "supplemental.strings".IO.spurt: StrEncode::output(), :close;  # StrEncode is a bad global for now

}

sub format-message(:$file, :$success, :$message) {
    ~ "\r" ~
    ~ DateTime.now.Str.substr(11..18) # Time of day
    ~ 4
}