use XML;
use MONKEY-SEE-NO-EVAL;
use Data::Dump::Tree;
use JSON::Tiny;

use lib BEGIN $?FILE.IO.parent.parent.add('lib').resolve;

use Intl::CLDR::Types::Dates;
use Intl::CLDR::Types::Delimiters;
use Intl::CLDR::Types::Layout;
use Intl::CLDR::Types::ListPatterns;
use Intl::CLDR::Types::Posix;
use Intl::CLDR::Types::ContextTransforms;
use Intl::CLDR::Types::Numbers;
use Intl::CLDR::Types::LocaleDisplayNames;

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

my @languages = <en>;
@languages = @languages.sort( *.chars );
@languages.unshift: 'root';

# Loop through each language in the list of languages as determined above.
for @languages -> $l {

    # The languages need a BCP47-style form (and the file names use Unicode-style)
    # Though it shouldn't be the case, if there are any non-canonical forms, we convert them
    # while ignoring 'root' since it's a psuedotag.
    my $lang = $l.subst('_','-', :g);
    $lang = LanguageTag.new($lang).canonical
        unless $lang eq 'root';

    say "Beginning encoding for $lang";

    # Open file unless there's a combining diacritic on a delimiter, and make sure it's got elements
    my $file;
    try {
        CATCH { say "Warning: could not open {$l}'s XML"; next; }
        $file = open-xml("main/{$lang}.xml");
        next if $file.elements.elems == 1;
    }

    # Data is designed to be cascading.
    # Sort order means we always will load 'en' before 'en-US' or else a fresh hash
    #try {
    #    CATCH { say "Could not load base data for $l (probably the base XML file was unreadable)"; say $!; next; }
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
    #}

    # Makes things a littttttle bit cleaner.
    my \base := %results{$lang};

#    with $file.&elem('dates'             ) { parse-dates (base<dates> //= Hash.new), $_ }
    with $file.&elem('localeDisplayNames') { CLDR-LocaleDisplayNames.parse: (base<localeDisplayNames> //= Hash.new), $_ }
#    with $file.&elem('layout'            ) { CLDR-Layout.parse: (base<layout> //= Hash.new), $_ }
#    with $file.&elem('characters'        ) { parse-dates (base<dates> //= Hash.new), $_ }
#    with $file.&elem('delimiters'        ) { CLDR-Delimiters.parse: (base<delimiters> //= Hash.new), $_ }
#    with $file.&elem('numbers'           ) { CLDR-Numbers.parse: (base<numbers> //= Hash.new), $_ }
#    with $file.&elem('units'             ) { parse-dates (base<dates> //= Hash.new), $_ }
#    with $file.&elem('listPatterns'      ) { CLDR-ListPatterns.parse: (base<listPatterns> //= Hash.new), $_ }
    #    with $file.&elem('posix'             ) { CLDR-Posix.parse: (base<posix> //= Hash.new), $_ }
#    with $file.&elem('contextTransforms'  ) { CLDR-ContextTransforms.parse: (base<contextTransforms> //= Hash.new), $_ }
#    with $file.&elem('characterLabels'   ) { parse-dates (base<dates> //= Hash.new), $_ }
#    with $file.&elem('typographicNames'  ) { parse-dates (base<dates> //= Hash.new), $_ }

    my $blob = CLDR-LocaleDisplayNames.encode: base<localeDisplayNames>;
    use Intl::CLDR::Classes::StrEncode;
    "languages-binary/{$lang}.data".IO.spurt: $blob, :bin;              #binary tree data
    "languages-binary/{$lang}.strings".IO.spurt: StrEncode::output();  # StrEncode is a bad global for now

    say "String encoded length is ~", StrEncode::output().chars, " bytes";
    say "Data   encoded length is ",  $blob.elems,                " bytes";

    # To load data, 'prepare' the StrDecode with the string data (again, bad global)
    # Then call .new with a uint64 (currently in Rakudo this can't be anonymous) and a mock parent
    use Intl::CLDR::Classes::StrDecode;
    StrDecode::prepare(StrEncode::output);

    my uint64 $foo = 0;
    my $numbers-object = CLDR-LocaleDisplayNames.new: $blob, $foo, 2;

    try {

        say $numbers-object.languages; # can play with this object
        say $numbers-object.languages<az>;
        say $numbers-object.languages<az>.short;
    }
    StrEncode::reset(); # clears encoder for next round

}









# utility functions
proto sub elems (|c){*}
multi sub elems ($xml            ) { my @a = $xml.elements;             @a == 0 ?? Empty !! @a }
multi sub elems ($xml, Str() $tag) { my @a = $xml.elements(:TAG($tag)); @a == 0 ?? Empty !! @a }

#| Ensures there is one and only one element with this tag
sub elem ($xml, Str() $tag, :$ignore-alt) {
  my $line = Backtrace.new[3].line;
  my @elements = $xml.elements(:TAG($tag));
  die "Fix elem for tag $tag, expected only one, came from line $line" if @elements > 1 && !$ignore-alt;
  @elements.head  // Nil
}


sub contents($xml) {
    with $xml.contents {
        return .join
    } else {
        return ''
    }
}
sub resolve-alias ($xml            ) {
  with elem $xml, 'alias' {
    # There is an alias
    if $_<source> eq 'locale' {
      my @alias-path      = $_<path>.split('/');
      my $parent-count = @alias-path.grep(* eq '..').elems;
      # Return the tag if it's a tag, otherwise just the string.
      my %selectors;
      for @alias-path[$parent-count..*] {
        if $_ ~~ /^(.+) '[@' (.+) "='" (.+) "']"$/ {
          %selectors{[~] $0, '-', $1} = $2.Str; # combining with the tag name isn't pretty, but if two
                                                # attributes are the same on different tags, they
                                                # can't be distinguished
        }else{
          %selectors{$_} = True;
        }
      }
      return %selectors;
    }else{
      die "Found a source that wasn't locale.  Figure out how to deal with it";
    }
  }
}
sub alias-die($xml, %a) {
  my $line = Backtrace.new[3].line;
  die "There shouldn't be aliases for this element (line $line).  \n  Element: {$_.Str}\n  Alias Table: {%a.Str}";
}

sub tag-contents($parent, $name) {
  if my $children = $parent.getElementsByTagName($name) {
    return $children.first.contents.join;
  } else {
    #say "Could not find $name";
    return Nil;
  }
}

sub pp-hash(%h, $level = 0) {
	for %h.kv -> $key, $value {
		if $value ~~ Hash {
			say ( ' ' x ($level*4)), $key, " => ";
			samewith $value, $level + 1;
		}else{
			say ( ' ' x ($level*4)), $key, " => ", $value;
		}
	}
}

sub array-clone (@array) {
  my @result;
  for @array {
    @result.push: $_.clone
  }
}
sub hash-clone (%hash) {
  my %result;
  for %hash.kv -> $key, $value {
    if $value ~~ Positional {
      %result{$key} = array-clone($value);
    }elsif $value ~~ Associative {
      %result{$key} = hash-clone($value);
    }else {
      %result{$key} = $value.clone;
    }
  }
  %result;
}

role Aliased[$redirect] {
    method alias { $redirect }
}

role ChildOf[$parent] {
    method parent { $parent }
}


#--------------------------------------------#
# FUNCTIONS FOR HANDLING INDIVIDUAL ELEMENTS #
#--------------------------------------------#

sub parse-base(\base, \xml) {
    with xml.&elems('dates') { parse-dates (base<dates> //= Hash.new), $_ }
    parse-dates  (base<dates>  //= Hash.new), $_ with xml.&elem('dates' );
    #parse-layout (base<layout> //= Hash.new), $_ with xml.&elem('layout');
    CLDR-Delimiters.parse: (base<delimiters> //= Hash.new), $_ with xml.&elem('delimiters');
}


sub parse-dates(\base, \xml) {
    with xml.&elem('calendars'     ) { parse-calendars      (base<calendars>     //= Hash.new), $_ }
    with xml.&elem('fields'        ) { parse-fields         (base<fields>        //= Hash.new), $_ }
    with xml.&elem('timeZoneNames' ) { parse-timezone-names (base<timeZoneNames> //= Hash.new), $_ }
}

#| Handles the CLDR Fields tag.
#  These are annoying because they are done in triplicate at a single level.  We parse them into one.
sub parse-fields(\base, \xml) {
    my \fields = Hash.new;
    fields{$_<type>} = $_ for xml.&elems('field');

    for <era quarter month week weekOfMonth day dayOfYear weekday weekdayOfMonth
         sun mon tue wed thu fri sat dayperiod hour minute second zone> -> \type {
        with fields{type} {
            parse-field (base{type} //= Hash.new), fields{type, "{type}-short", "{type}-narrow"}
        }
    }
}

#| Handles the CLDR Field tag
#  This technically handles three at once, but are merged here.
#  Standard is guaranteed -- short falls back to standard, and narrow to short
sub parse-field(\base, @ (\standard,\short,\narrow) ) {
    with standard { parse-field-width (base<standard> //= Hash.new), standard }
    with short    { parse-field-width (base<short>    //= Hash.new), short    }
    with narrow   { parse-field-width (base<narrow>   //= Hash.new), narrow   }
}

sub parse-field-width(\base, \xml) {
    for xml.&elems('relative') -> \elem {
        base{elem<type>} = elem.&contents;
    }
    with xml.&elem('displayName', :ignore-alt) {
        base<displayName> = contents $_;
    }
    for xml.&elems('relativeTimePattern') -> \elem {
        parse-relative-time (base{elem<type>} //= Hash.new), elem
    }
}

sub parse-relative-time(\base, \xml) {
    for xml.&elems('relativeTimePattern') -> \pattern {
        base{pattern<count>} = pattern.&contents;
    }
}

sub parse-timezone-names(\base, \xml) {
    with xml.&elem('hourFormat'    ) { base<hourFormat>    = contents $_ }
    with xml.&elem('gmtFormat'     ) { base<gmtFormat>     = contents $_ }
    with xml.&elem('gmtZeroFormat' ) { base<gmtZeroFormat> = contents $_ }
    with xml.&elem('fallbackFormat') { base<gmtZeroFormat> = contents $_ }

    base<regionFormat>{.<type> || 'generic'} = contents $_
        for xml.&elems('regionFormat');

    parse-timezones (base<zones>     //= Hash), xml, 'zones'; # the zones are at this same level for some weird reason
    parse-timezones (base<metazones> //= Hash), xml, 'metazone';
}

sub parse-timezones(\base, \xml, \zone-type) {
    parse-timezone (base{$_<type>} //= Hash.new), $_ for xml.&elems(zone-type);
}

sub parse-timezone(\base, \xml) {
    with xml.&elem('exemplarCity') { base<exemplarCity> = contents $_ }
    with xml.&elem('short') { parse-timezone-width (base<short> //= Hash.new), $_ }
    with xml.&elem('long' ) { parse-timezone-width (base<long>  //= Hash.new), $_ }
}

sub parse-timezone-width(\base, \xml) {
    with xml.&elem('generic' ) { base<generic>  = contents $_ }
    with xml.&elem('standard') { base<standard> = contents $_ }
    with xml.&elem('daylight') { base<daylight> = contents $_ }
}

sub parse-calendars(\base, \xml) {
    my $*calendars := xml;
    parse-calendar (base{.<type>} //= Hash.new ), $_ for xml.&elems('calendar')
}

sub parse-calendar(\base, \xml) {
    parse-months            (base<months>           //= Hash.new), $_ with xml.&elem('months');
    parse-month-patterns    (base<monthPatterns>    //= Hash.new), $_ with xml.&elem('monthPatterns');
    parse-quarters          (base<quarters>         //= Hash.new), $_ with xml.&elem('quarters');
    parse-days              (base<days>             //= Hash.new), $_ with xml.&elem('days');
    parse-dayperiods        (base<dayperiods>       //= Hash.new), $_ with xml.&elem('dayPeriods');
    parse-eras              (base<eras>             //= Hash.new), $_ with xml.&elem('eras');
    parse-cyclic-name-sets  (base<cyclicNameSets>   //= Hash.new), $_ with xml.&elem('cyclicNameSets');
    parse-date-formats      (base<dateFormats>      //= Hash.new), $_ with xml.&elem('dateFormats');
    parse-time-formats      (base<timeFormats>      //= Hash.new), $_ with xml.&elem('timeFormats');
    parse-datetime-formats  (base<dateTimeFormats>  //= Hash.new), $_ with xml.&elem('dateTimeFormats');
}

sub parse-months(\base, \xml) {
    parse-month-context (base{.<type>} //= Hash.new), $_ for xml.&elems('monthContext');
}

sub parse-month-context(\base, \xml) {
    parse-month-width (base{.<type>} //= Hash.new), $_ for xml.&elems('monthWidth');
}

# The leap year adds the text "leap" to the number.  Only affects the Hebrew calendar
sub parse-month-width(\base, \xml) {
    base{.<type> ~ (.<yeartype>||'') } = contents $_ for xml.&elems('month')
}

sub parse-month-patterns(\base, \xml) {
    parse-month-pattern-context (base{.<type>} //= Hash.new), $_ for xml.&elems('monthContext');
}

sub parse-month-pattern-context(\base, \xml) {
    parse-month-pattern-width (base{.<type>} //= Hash.new), $_ for xml.&elems('monthWidth');
}

# The leap year adds the text "leap" to the number.  Only affects the Hebrew calendar
sub parse-month-pattern-width(\base, \xml) {
    base{.<type>} = contents $_ for xml.&elems('month')
}


sub parse-quarters(\base, \xml) {
    parse-quarter-context (base{.<type>} //= Hash.new), $_ for xml.&elems('quarterContext');
}

sub parse-quarter-context(\base, \xml) {
    parse-quarter-width (base{.<type>} //= Hash.new), $_ for xml.&elems('quarterWidth');
}

sub parse-quarter-width(\base, \xml) {
    base{.<type>} = contents $_ for xml.&elems('quarter')
}

sub parse-days(\base, \xml) {
    parse-day-context (base{.<type>} //= Hash.new), $_ for xml.&elems('dayContext');
}

sub parse-day-context(\base, \xml) {
    parse-day-width (base{.<type>} //= Hash.new), $_ for xml.&elems('dayWidth');
}

sub parse-day-width(\base, \xml) {
    base{.<type>} = contents $_ for xml.&elems('day')
}

sub parse-dayperiods(\base, \xml) {
    parse-dayperiod-context (base{.<type>} //= Hash.new), $_ for xml.&elems('dayPeriodContext');
}

sub parse-dayperiod-context(\base, \xml) {
    parse-dayperiod-width (base{.<type>} //= Hash.new), $_ for xml.&elems('dayPeriodWidth');
}

sub parse-dayperiod-width(\base, \xml) {
    base{.<type>} = contents $_ for xml.&elems('dayPeriod')
}

sub parse-eras(\base, \xml) {
    parse-era-width (base<eraNames>  //= Hash.new), $_ with xml.&elem('eraNames');
    parse-era-width (base<eraAbbr>   //= Hash.new), $_ with xml.&elem('eraAbbr');
    parse-era-width (base<eraNarrow> //= Hash.new), $_ with xml.&elem('eraNarrow');
}

sub parse-era-width(\base, \xml) {
    base{.<type>} = contents $_ for xml.&elems('era')
}

sub parse-cyclic-name-sets(\base, \xml) {
    parse-cyclic-name-set (base{.<type>} //= Hash.new), $_ for xml.&elems('cyclicNameSet');
}

sub parse-cyclic-name-set(\base, \xml) {
    parse-cyclic-name-context (base{.<type>} //= Hash.new), $_ for xml.&elems('cyclicNameContext');
}

sub parse-cyclic-name-context(\base, \xml) {
    parse-cyclic-name-width (base{.<type>} //= Hash.new), $_ for xml.&elems('cyclicNameWidth');
}

sub parse-cyclic-name-width(\base, \xml) {
    base{.<type>} = contents $_ for xml.&elems('cyclicName');
}


sub parse-date-formats(\base, \xml) {
    for xml.&elems('dateFormatLength') {
        # There should really only be one pattern.
        # There isn't always (read: rarely if ever) a display name.
        my $length = .<type>;
        my $format = .&elem('dateFormat');

        base{$length}<pattern>     = $format.&elem('pattern').&contents;
        base{$length}<displayName> = $format.&elem('displayName').&contents;
    }
}

sub parse-time-formats(\base, \xml) {
    for xml.&elems('timeFormatLength') {
        # There should really only be one pattern.
        # There isn't always (read: rarely if ever) a display name.
        my $length = .<type>;
        my $format = .&elem('timeFormat');

        base{$length}<pattern>     = $format.&elem('pattern').&contents;
        base{$length}<displayName> = $format.&elem('displayName').&contents;
    }
}

sub parse-datetime-formats(\base, \xml) {
    for xml.&elems('dateTimeFormatLength') {
        # There should really only be one pattern.
        # There isn't always (read: rarely if ever) a display name.
        my $length = .<type>;
        my $format = .&elem('dateTimeFormat');

        base{$length}<pattern>     = $format.&elem('pattern').&contents;
        base{$length}<displayName> = $format.&elem('displayName').&contents;
    }

    parse-available-formats (base<availableFormats> //= Hash.new), $_ with xml.&elem('availableFormats');
    parse-append-items      (base<appendItems>      //= Hash.new), $_ with xml.&elem('appendItems');
    parse-interval-formats  (base<intervalFormats>  //= Hash.new), $_ with xml.&elem('intervalFormats');
    base<intervalFormatFallback> = contents $_ with xml.&elem('intervalFormats').&elem('intervalFormatFallback');
}

sub parse-available-formats(\base, \xml) {
    base{.<id>} = contents $_ for xml.&elems('dateFormatItem')
}

sub parse-append-items(\base, \xml) {
    base{.<request>} = contents $_ for xml.&elems('appendItem');
}

sub parse-interval-formats(\base, \xml) {
    base<fallback> = contents $_ with xml.&elem('intervalFormatFallback');
    parse-interval-format (base<formats>{.<id>} //= Hash.new), $_ for xml.&elems('intervalFormatItem')
}

sub parse-interval-format(\base, \xml) {
    base{.<id>} = contents $_ for xml.&elems('greatestDifference')
}

