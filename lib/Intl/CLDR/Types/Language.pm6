use Intl::CLDR::Immutability;

unit class CLDR-Language is CLDR-ItemNew;

use Intl::CLDR::Types::Characters;
use Intl::CLDR::Types::ContextTransforms;
use Intl::CLDR::Types::Dates;
use Intl::CLDR::Types::Delimiters;
use Intl::CLDR::Types::Layout;
use Intl::CLDR::Types::ListPatterns;
use Intl::CLDR::Types::LocaleDisplayNames;
use Intl::CLDR::Types::Numbers;
use Intl::CLDR::Types::Posix;
use Intl::CLDR::Types::Units;

#    with $file.&elem('characters'        ) { parse-dates (base<dates> //= Hash.new), $_ }
#    with $file.&elem('numbers'           ) { CLDR-Numbers.parse: (base<numbers> //= Hash.new), $_ }
#    with $file.&elem('units'             ) { parse-dates (base<dates> //= Hash.new), $_ }
#    with $file.&elem('characterLabels'   ) { parse-dates (base<dates> //= Hash.new), $_ }
#    with $file.&elem('typographicNames'  ) { parse-dates (base<dates> //= Hash.new), $_ }

has $!parent;
#  has $.character-labels;
has CLDR-Characters         $!characters;            my constant OFFSET-CHARACTERS           =  8;
has CLDR-ContextTransforms  $!context-transforms;    my constant OFFSET-CONTEXT-TRANSFORM    = 12;
has CLDR-Dates              $!dates;                 my constant OFFSET-DATES                = 16;
has CLDR-Delimiters         $!delimiters;            my constant OFFSET-DELIMITERS           = 20;
has CLDR-Layout             $!layout;                my constant OFFSET-LAYOUT               = 24;
has CLDR-ListPatterns       $!list-patterns;         my constant OFFSET-LIST-PATTERNS        = 28;
has CLDR-LocaleDisplayNames $!locale-display-names;  my constant OFFSET-LOCALE-DISPLAY-NAMES = 32;
has CLDR-Numbers            $!numbers;               my constant OFFSET-NUMBERS              = 36;
has CLDR-Posix              $!posix;                 my constant OFFSET-POSIX                = 40;
has CLDR-Units              $!units;                 my constant OFFSET-UNITS                = 44;
#  has $.typographic-names;


has blob8 $!data;
has str   @!strings;


#| Creates a new CLDR-Language object
method new(|c) {
    self.bless!bind-init: |c;
}

submethod !bind-init(\blob, \strs) {

    $!data    := blob;
    @!strings := strs;

    #$!context-transforms = CLDR-ContextTransforms.new: blob, $offset;
    #$!dates              = CLDR-Dates.new:             blob, $offset;
    #$!delimiters         = CLDR-Delimiters.new:        blob, $offset;
    #$!layout             = CLDR-Layout.new:            blob, $offset;
    #$!list-patterns      = CLDR-ListPatterns.new:      blob, $offset;
    #$!locale-display-names = CLDR-LocaleDisplayNames.new: blob, $offset;
    #$!numbers            = CLDR-Numbers.new:           blob, $offset;
    #$!posix              = CLDR-Posix.new:             blob, $offset;
    #$!units              = CLDR-Units.new:             blob, $offset;

    self
}

method characters {
    .return with $!characters;
    use Intl::CLDR::Util::StrDecode; StrDecode::set(@!strings);
    my uint64 $offset = $!data.read-uint32(OFFSET-CHARACTERS, LittleEndian);
    $!characters = CLDR-Characters.new: $!data, $offset
}

method context-transforms {
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
method layout {
    .return with $!layout;
    use Intl::CLDR::Util::StrDecode; StrDecode::set(@!strings);
    my uint64 $offset = $!data.read-uint32(OFFSET-LAYOUT, LittleEndian);
    $!layout = CLDR-Delimiters.new: $!data, $offset
}
method list-patterns {
    .return with $!list-patterns;
    use Intl::CLDR::Util::StrDecode; StrDecode::set(@!strings);
    my uint64 $offset = $!data.read-uint32(OFFSET-LIST-PATTERNS, LittleEndian);
    $!list-patterns = CLDR-ListPatterns.new: $!data, $offset
}
method locale-display-names {
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
    $!posix = CLDR-Posix.new: $!data, $offset
}
method units {
    .return with $!units;
    use Intl::CLDR::Util::StrDecode; StrDecode::set(@!strings);
    my uint64 $offset = $!data.read-uint32(OFFSET-UNITS, LittleEndian);
    $!units = CLDR-Units.new: $!data, $offset
}

# These normalize CLDR case mappings into Raku's
constant \detour = Map.new: (
    contextTransforms  => 'context-transforms',
    listPatterns       => 'list-patterns',
    localeDisplayNames => 'locale-display-names'
);
method DETOUR(--> detour) {;}

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
    $result.write-uint32: 24, $result.elems, LittleEndian;
    $result ~= CLDR-Layout.encode(            %*language<layout>             // Hash.new);
    $result.write-uint32: 28, $result.elems, LittleEndian;
    $result ~= CLDR-ListPatterns.encode(      %*language<listPatterns>       // Hash.new);
    $result.write-uint32: 32, $result.elems, LittleEndian;
    $result ~= CLDR-LocaleDisplayNames.encode(%*language<localeDisplayNames> // Hash.new);
    $result.write-uint32: 36, $result.elems, LittleEndian;
    $result ~= CLDR-Numbers.encode(           %*language<numbers>            // Hash.new);
    $result.write-uint32: 40, $result.elems, LittleEndian;
    $result ~= CLDR-Posix.encode(             %*language<posix>              // Hash.new);
    $result.write-uint32: 44, $result.elems, LittleEndian;
    $result ~= CLDR-Units.encode(             %*language<units>              // Hash.new);
    #$result.write-uint32: 36, $result.elems, LittleEndian;

    $result
}
method parse(\base, \xml) {
    use Intl::CLDR::Util::XML-Helper;
    CLDR-Characters.parse:         (base<characters>         //= Hash.new), $_ with xml.&elem('characters');
    CLDR-ContextTransforms.parse:  (base<contextTransforms>  //= Hash.new), $_ with xml.&elem('contextTransforms');
    CLDR-Dates.parse:              (base<dates>              //= Hash.new), $_ with xml.&elem('dates');
    CLDR-Delimiters.parse:         (base<delimiters>         //= Hash.new), $_ with xml.&elem('delimiters');
    CLDR-Layout.parse:             (base<layout>             //= Hash.new), $_ with xml.&elem('layout');
    CLDR-ListPatterns.parse:       (base<listPatterns>       //= Hash.new), $_ with xml.&elem('listPatterns');
    CLDR-LocaleDisplayNames.parse: (base<localeDisplayNames> //= Hash.new), $_ with xml.&elem('localeDisplayNames');
    CLDR-Numbers.parse:            (base<numbers>            //= Hash.new), $_ with xml.&elem('numbers');
    CLDR-Posix.parse:              (base<posix>              //= Hash.new), $_ with xml.&elem('posix');
    CLDR-Units.parse:              (base<units>              //= Hash.new), $_ with xml.&elem('units');
}
#>>>>> # GENERATOR
