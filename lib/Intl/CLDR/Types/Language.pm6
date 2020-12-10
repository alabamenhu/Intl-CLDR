use Intl::CLDR::Immutability;

unit class CLDR-Language is CLDR-ItemNew;

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
has CLDR-ContextTransforms  $.context-transforms;
has CLDR-Dates              $.dates;
has CLDR-Delimiters         $.delimiters;
has CLDR-Layout             $.layout;
has CLDR-ListPatterns       $.list-patterns;
has CLDR-LocaleDisplayNames $.locale-display-names;
has CLDR-Numbers            $.numbers;
has CLDR-Posix              $.posix;
has CLDR-Units              $.units;
#  has $.typographic-names;
#  has $.units;

#| Creates a new CLDR-DayPeriodContext object
method new(|c) {
    self.bless!bind-init: |c;
}

submethod !bind-init(\blob, uint64 $offset is rw) {

    $!context-transforms = CLDR-ContextTransforms.new: blob, $offset;
    $!dates              = CLDR-Dates.new:             blob, $offset;
    $!delimiters         = CLDR-Delimiters.new:        blob, $offset;
    $!layout             = CLDR-Layout.new:            blob, $offset;
    $!list-patterns      = CLDR-ListPatterns.new:      blob, $offset;
    $!locale-display-names = CLDR-LocaleDisplayNames.new: blob, $offset, self;
    $!numbers            = CLDR-Numbers.new:           blob, $offset;
    $!posix              = CLDR-Posix.new:             blob, $offset;
    $!units              = CLDR-Units.new:             blob, $offset;

    self
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
    my $result = buf8.new;

    $result ~= CLDR-ContextTransforms.encode( %*language<dates>              // Hash.new);
    $result ~= CLDR-Dates.encode(             %*language<dates>              // Hash.new);
    $result ~= CLDR-Delimiters.encode(        %*language<delimiters>         // Hash.new);
    $result ~= CLDR-Layout.encode(            %*language<layout>             // Hash.new);
    $result ~= CLDR-ListPatterns.encode(      %*language<listPatterns>       // Hash.new);
    $result ~= CLDR-LocaleDisplayNames.encode(%*language<localeDisplayNames> // Hash.new);
    $result ~= CLDR-Numbers.encode(           %*language<numbers>            // Hash.new);
    $result ~= CLDR-Posix.encode(             %*language<posix>              // Hash.new);
    $result ~= CLDR-Units.encode(             %*language<units>              // Hash.new);

    $result
}
method parse(\base, \xml) {
    use Intl::CLDR::Util::XML-Helper;
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
