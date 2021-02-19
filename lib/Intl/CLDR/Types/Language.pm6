unit class CLDR-Language;
    use Intl::CLDR::Core;
    also does CLDR::Item;

use Intl::CLDR::Types::Characters;
use Intl::CLDR::Types::ContextTransforms;
use Intl::CLDR::Types::Dates;
use Intl::CLDR::Types::Delimiters;
use Intl::CLDR::Types::Grammar;
use Intl::CLDR::Types::Layout;
use Intl::CLDR::Types::ListPatterns;
use Intl::CLDR::Types::LocaleDisplayNames;
use Intl::CLDR::Types::Numbers;
use Intl::CLDR::Types::Posix;
use Intl::CLDR::Types::Units;

#    with $file.&elem('characterLabels'   ) { parse-dates (base<dates> //= Hash.new), $_ }
#    with $file.&elem('typographicNames'  ) { parse-dates (base<dates> //= Hash.new), $_ }

# Because of lazy loading, we can't alias here.
#  has $.character-labels;
has CLDR-Characters         $!characters;            my constant OFFSET-CHARACTERS           =  8;
has CLDR-ContextTransforms  $!context-transforms;    my constant OFFSET-CONTEXT-TRANSFORM    = 12;
has CLDR-Dates              $!dates;                 my constant OFFSET-DATES                = 16;
has CLDR-Delimiters         $!delimiters;            my constant OFFSET-DELIMITERS           = 20;
has CLDR-Grammar            $!grammar;               my constant OFFSET-GRAMMAR              = 24;
has CLDR-Layout             $!layout;                my constant OFFSET-LAYOUT               = 28;
has CLDR-ListPatterns       $!list-patterns;         my constant OFFSET-LIST-PATTERNS        = 32;
has CLDR-LocaleDisplayNames $!locale-display-names;  my constant OFFSET-LOCALE-DISPLAY-NAMES = 36;
has CLDR-Numbers            $!numbers;               my constant OFFSET-NUMBERS              = 40;
has CLDR::Posix             $!posix;                 my constant OFFSET-POSIX                = 44;
has CLDR::Units             $!units;                 my constant OFFSET-UNITS                = 48;
#  has $.typographic-names;


has blob8 $!data    is built;
has str   @!strings is built;


#| Creates a new CLDR-Language object
method new(blob8 $data, str @strings) {
    self.bless: :$data, :@strings;
}

method characters {
    .return with $!characters;
    use Intl::CLDR::Util::StrDecode; StrDecode::set(@!strings);
    my uint64 $offset = $!data.read-uint32(OFFSET-CHARACTERS, LittleEndian);
    $!characters = CLDR-Characters.new: $!data, $offset
}

method context-transforms is aliased-by<contextTransforms> {
    .return with $!context-transforms;
    use Intl::CLDR::Util::StrDecode; StrDecode::set(@!strings);
    my uint64 $offset = $!data.read-uint32(OFFSET-CONTEXT-TRANSFORM, LittleEndian);
    $!context-transforms = CLDR-ContextTransforms.new: $!data, $offset
}

method dates {
    .return with $!dates;
    use Intl::CLDR::Util::StrDecode; StrDecode::set(@!strings);
    my uint64 $offset = $!data.read-uint32(OFFSET-DATES, LittleEndian);
    $!dates = CLDR-Dates.new: $!data, $offset
}
method delimiters {
    .return with $!delimiters;
    use Intl::CLDR::Util::StrDecode; StrDecode::set(@!strings);
    my uint64 $offset = $!data.read-uint32(OFFSET-DELIMITERS, LittleEndian);
    $!delimiters = CLDR-Delimiters.new: $!data, $offset
}
method grammar {
    .return with $!grammar;
    use Intl::CLDR::Util::StrDecode; StrDecode::set(@!strings);
    my uint64 $offset = $!data.read-uint32(OFFSET-GRAMMAR, LittleEndian);
    $!grammar = CLDR-Grammar.new: $!data, $offset
}
method layout {
    .return with $!layout;
    use Intl::CLDR::Util::StrDecode; StrDecode::set(@!strings);
    my uint64 $offset = $!data.read-uint32(OFFSET-LAYOUT, LittleEndian);
    $!layout = CLDR-Layout.new: $!data, $offset
}
method list-patterns is aliased-by<listPatterns> {
    .return with $!list-patterns;
    use Intl::CLDR::Util::StrDecode; StrDecode::set(@!strings);
    my uint64 $offset = $!data.read-uint32(OFFSET-LIST-PATTERNS, LittleEndian);
    $!list-patterns = CLDR-ListPatterns.new: $!data, $offset
}
method locale-display-names is aliased-by<localeDisplayNames> {
    .return with $!locale-display-names;
    use Intl::CLDR::Util::StrDecode; StrDecode::set(@!strings);
    my uint64 $offset = $!data.read-uint32(OFFSET-LOCALE-DISPLAY-NAMES, LittleEndian);
    $!locale-display-names = CLDR-LocaleDisplayNames.new: $!data, $offset
}
method numbers (--> CLDR-Numbers) {
    .return with $!numbers;
    use Intl::CLDR::Util::StrDecode; StrDecode::set(@!strings);
    my uint64 $offset = $!data.read-uint32(OFFSET-NUMBERS, LittleEndian);
    $!numbers = CLDR-Numbers.new: $!data, $offset
}
method posix {
    .return with $!posix;
    use Intl::CLDR::Util::StrDecode; StrDecode::set(@!strings);
    my uint64 $offset = $!data.read-uint32(OFFSET-POSIX, LittleEndian);
    $!posix = CLDR::Posix.new: $!data, $offset
}
method units {
    .return with $!units;
    use Intl::CLDR::Util::StrDecode; StrDecode::set(@!strings);
    my uint64 $offset = $!data.read-uint32(OFFSET-UNITS, LittleEndian);
    $!units = CLDR::Units.new: $!data, $offset
}

multi method gist (CLDR-Language:D:) {
    '[CLDR-Language: characters,context-transforms,dates,delimiters,grammar,layout,list-patterns,locale-display-names,numbers,posix,units]';
}


##`<<<<< # GENERATOR: This method should only be uncommented out by the parsing script
method encode(%*language) {
    #my $result = buf8.new;
    my $result = buf8.new:
            67, 76, 68, 82,
            100, 97, 116, 97,  # header 'CLDRdata'
            0, 0, 0, 0, # characters offset
            0, 0, 0, 0, # context transform offset
            0, 0, 0, 0, # dates offset
            0, 0, 0, 0, # delimiters offset
            0, 0, 0, 0, # grammar offset
            0, 0, 0, 0, # layout offset
            0, 0, 0, 0, # list patterns offset
            0, 0, 0, 0, # localedisplaynames offset
            0, 0, 0, 0, # numbers offset
            0, 0, 0, 0, # posix offset
            0, 0, 0, 0, # units offset
    ;
    $result.write-uint32: OFFSET-CHARACTERS, $result.elems, LittleEndian;
    $result ~= CLDR-Characters.encode(        %*language<characters>         // Hash.new);

    $result.write-uint32: OFFSET-CONTEXT-TRANSFORM, $result.elems, LittleEndian;
    $result ~= CLDR-ContextTransforms.encode( %*language<contextTransforms>  // Hash.new);

    $result.write-uint32: OFFSET-DATES, $result.elems, LittleEndian;
    $result ~= CLDR-Dates.encode(             %*language<dates>              // Hash.new);

    $result.write-uint32: OFFSET-DELIMITERS, $result.elems, LittleEndian;
    $result ~= CLDR-Delimiters.encode(        %*language<delimiters>         // Hash.new);

    $result.write-uint32: OFFSET-GRAMMAR, $result.elems, LittleEndian;
    $result ~= CLDR-Grammar.encode(           %*language<grammar>            // Hash.new);

    $result.write-uint32: OFFSET-LAYOUT, $result.elems, LittleEndian;
    $result ~= CLDR-Layout.encode(            %*language<layout>             // Hash.new);

    $result.write-uint32: OFFSET-LIST-PATTERNS, $result.elems, LittleEndian;
    $result ~= CLDR-ListPatterns.encode(      %*language<listPatterns>       // Hash.new);

    $result.write-uint32: OFFSET-LOCALE-DISPLAY-NAMES, $result.elems, LittleEndian;
    $result ~= CLDR-LocaleDisplayNames.encode(%*language<localeDisplayNames> // Hash.new);

    $result.write-uint32: OFFSET-NUMBERS, $result.elems, LittleEndian;
    $result ~= CLDR-Numbers.encode(           %*language<numbers>            // Hash.new);

    $result.write-uint32: OFFSET-POSIX, $result.elems, LittleEndian;
    $result ~= CLDR::Posix.encode(             %*language<posix>              // Hash.new);

    $result.write-uint32: OFFSET-UNITS, $result.elems, LittleEndian;
    $result ~= CLDR::Units.encode(             %*language<units>              // Hash.new);

    #$result.write-uint32: 36, $result.elems, LittleEndian;

    $result
}

method parse(\base, \xml) {
    use Intl::CLDR::Util::XML-Helper;
    CLDR-Characters.parse:         (base<characters>         //= Hash.new), $_ with xml.&elem('characters');
    CLDR-ContextTransforms.parse:  (base<contextTransforms>  //= Hash.new), $_ with xml.&elem('contextTransforms');
    CLDR-Dates.parse:              (base<dates>              //= Hash.new), $_ with xml.&elem('dates');
    CLDR-Delimiters.parse:         (base<delimiters>         //= Hash.new), $_ with xml.&elem('delimiters');
    CLDR-Grammar.parse:            (base<grammar>            //= Hash.new), $; # Uses supplemental data
    CLDR-Layout.parse:             (base<layout>             //= Hash.new), $_ with xml.&elem('layout');
    CLDR-ListPatterns.parse:       (base<listPatterns>       //= Hash.new), $_ with xml.&elem('listPatterns');
    CLDR-LocaleDisplayNames.parse: (base<localeDisplayNames> //= Hash.new), $_ with xml.&elem('localeDisplayNames');
    CLDR-Numbers.parse:            (base<numbers>            //= Hash.new), $_ with xml.&elem('numbers');
    CLDR::Posix.parse:             (base<posix>              //= Hash.new), $_ with xml.&elem('posix');
    CLDR::Units.parse:             (base<units>              //= Hash.new), $_ with xml.&elem('units');
}
#>>>>> # GENERATOR
