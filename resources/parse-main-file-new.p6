use lib BEGIN $?FILE.IO.parent.parent.add('lib').resolve;
use XML;
use MONKEY-SEE-NO-EVAL;
use Data::Dump::Tree;
use JSON::Tiny;
use Intl::CLDR::Classes::StrEncode;
use Intl::CLDR::Classes::StrDecode;
use Intl::CLDR::Types::Language;
use Intl::LanguageTag;



=begin pod
With apologies to anyone who has to read this.


The basic process for generating the data files is as follows:

  1. Read the base XML files (en, es, etc)
  2. For each sub file, deep copy using C<EVAL %hash.raku>, and apply the new data (en-US, es-ES, etc) on top of it
     using C<parse>
  3. Then, using C<encode>, generate the two data files -- a binary tree file and a strings file.
  4. The strings file is interpreted as a giant array, so that the binary file may easily reference
     the strings (many strings are repeated, so this saves space).

The <alias> tag only exists for root, and not for any other language.  They are ignored by parse, and the fallback
interpretations are generally handled in the C<encode> methods.  This means data may be duplicated (but duplicate
strings are practically free).  The slight increase in memory is probably worth the speed improvements.

There are a number of subs available to C<parse> via C<Intl::CLDR::Util::XML-Helper>  to keep things simple:
  - elem $xml, $tag   OR   $xml.&elem($tag)
      Returns a single child element matching the tag when we know there will be only one element. Dies if more than one.
  - elems $xml, $tags  OR  $xml.&elems($tag)
      Returns a child elements matching the tag
  - contents $xml
      Returns the text content of the tag

=end pod

my %results;

my @language-files = "main".IO.dir;

@language-files = @language-files.sort( *.basename.chars ).grep(none *.basename.contains('root'));
@language-files.unshift("main/root.xml".IO); # root must come first
my $total-load-time = 0;


# Loop through each language in the list of languages as determined above.
for @language-files -> $language-file {

    # The languages need a BCP47-style form (and the file names use Unicode-style)
    # Though it shouldn't be the case, if there are any non-canonical forms, we convert them
    # while ignoring 'root' since it's a psuedotag.
    my $lang = $language-file.basename.subst('_','-', :g).substr(0, *-4);
    $lang = LanguageTag.new($lang).canonical
        unless $lang eq 'root';

    say "Encoding language '$lang'";

    # Open file unless there's a combining diacritic on a delimiter, and make sure it's got elements
    my $file;
    try {
        CATCH { say "Warning: could not open {$language-file}"; next; }
        $file = open-xml($language-file);
        next if $file.elements.elems == 1;
    }

    # Data is designed to be cascading.
    # Sort order means we always will load 'en' before 'en-US' or else a fresh hash
    # The goal in this section is to load the most narrowly matching combination first
    # Deep copying of hashes is done via 'from-json to-json' because of an odd parse bug
    try {
        CATCH { say "Could not load base data for $lang (probably the base XML file was unreadable)"; say $!; next; }
        given $lang.comb('-').elems {
            when 0 {
                if $lang eq 'root' {
                    %results<root> = Hash.new
                } else {
                    %results{$lang} = from-json to-json %results<root>;
                }
                %results{$lang} := ($lang eq 'root' ?? Hash.new !! from-json to-json %results<root>) }
            default {
                %results{$lang} := %results{$lang.split('-')[0..*-2].join('-')}:exists # in a handful of instances, removing a single tag does not result in a valid match, but removing two ALWAYS does (for now);
                    ?? (EVAL %results{$lang.split('-')[0..*-2].join('-')}.raku )
                    !! (EVAL %results{$lang.split('-')[0..*-3].join('-')}.raku )
            }
        }
    }


    # Process and encode
    my $base := %results{$lang};
    StrEncode::reset(); # clears encoder
    CLDR-Language.parse($base, $file);
    my $blob = CLDR-Language.encode: $base;

    # Write the data out
    "languages-binary/{$lang}.data".IO.spurt: $blob, :bin;             # binary tree data
    "languages-binary/{$lang}.strings".IO.spurt: StrEncode::output();  # StrEncode is a bad global for now

    say "  Stringy  encoded length is ~", StrEncode::output().chars, " bytes";
    say "  DataTree encoded length is  ", $blob.elems, " bytes";

    # To load data, 'prepare' the StrDecode with the string data (again, bad global)
    # Then call .new with a uint64 (currently in Rakudo this can't be anonymous) and a mock parent
    use Intl::CLDR::Classes::StrDecode;
    StrDecode::prepare(StrEncode::output);

    # Check we can reread it
    my uint64 $foo = 0;
    my $start = now;
    sink CLDR-Language.new: $blob, $foo, 2;
    $total-load-time += (now - $start);
}

say "Compilation complete.  Load time for {%results.keys.elems} files was ", $total-load-time, " ({$total-load-time / %results.keys.elems} avg)";