unit class CLDR::Language;
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

# These two attributes are required for the lazy loading
has Distribution::Resource  $!data-file is built;
has str                     @!strings   is built;

# The attributes must be in the same order that their offsets are set at.
# See comments at the lazy trait and in the encoding phase
has CLDR::Characters        $!characters           is lazy;
has CLDR::ContextTransforms $!context-transforms   is lazy;
has CLDR::Dates             $!dates                is lazy;
has CLDR::Delimiters        $!delimiters           is lazy;
has CLDR::Grammar           $!grammar              is lazy;
has CLDR::Layout            $!layout               is lazy;
has CLDR::ListPatterns      $!list-patterns        is lazy;
has CLDR::LocaleDisplayNames$!locale-display-names is lazy;
has CLDR::Numbers           $!numbers              is lazy;
has CLDR::Posix             $!posix                is lazy;
has CLDR::Units             $!units                is lazy;

#| Creates a new CLDR::Language object
method new(Distribution::Resource :$str-file, Distribution::Resource :$data-file) {
    my str @strings = $str-file.split(31.chr);
    self.bless: :@strings, :$data-file;
}

multi method gist (CLDR::Language:D:) {
    '[CLDR::Language: characters,context-transforms,dates,delimiters,grammar,layout,list-patterns,locale-display-names,numbers,posix,units]';
}

##`<<<<< # GENERATOR: This method should only be uncommented out by the parsing script
method encode(%*language) {
    my @types = <
        CLDR::Characters         characters
        CLDR::ContextTransforms  contextTransforms
        CLDR::Dates              dates
        CLDR::Delimiters         delimiters
        CLDR::Grammar            grammar
        CLDR::Layout             layout
        CLDR::ListPatterns       listPatterns
        CLDR::LocaleDisplayNames localeDisplayNames
        CLDR::Numbers            numbers
        CLDR::Posix              posix
        CLDR::Units              units
    >;

    # Put in the initial header with offset locations
    my buf8 $result = buf8.new:
         67,  76,  68,  82,  # header₁ 'CLDR'
        100,  97, 116,  97,  # header₂ 'data'
          0   xx  @types*2,  # 4 x 0 for each type
          0,   0,   0,   0;  # eof location

    # Encode each attribute, and indicate its position
    my $position = 8;
    for @types -> $class, $key {
        $result.write-uint32: $position, $result.elems, LittleEndian;
        $result ~= ::("$class").encode(%*language{$key} // Hash.new);
        $position += 4;
    }
    # Insert the EOF location as the final attribute offset "slot"
    $result.write-uint32: $position, $result.elems, LittleEndian;

    $result
}

method parse(\base, \xml) {
    use Intl::CLDR::Util::XML-Helper;
    CLDR::Characters.parse:         (base<characters>         //= Hash.new), $_ with xml.&elem('characters');
    CLDR::ContextTransforms.parse:  (base<contextTransforms>  //= Hash.new), $_ with xml.&elem('contextTransforms');
    CLDR::Dates.parse:              (base<dates>              //= Hash.new), $_ with xml.&elem('dates');
    CLDR::Delimiters.parse:         (base<delimiters>         //= Hash.new), $_ with xml.&elem('delimiters');
    CLDR::Grammar.parse:            (base<grammar>            //= Hash.new), $; # Uses supplemental data
    CLDR::Layout.parse:             (base<layout>             //= Hash.new), $_ with xml.&elem('layout');
    CLDR::ListPatterns.parse:       (base<listPatterns>       //= Hash.new), $_ with xml.&elem('listPatterns');
    CLDR::LocaleDisplayNames.parse: (base<localeDisplayNames> //= Hash.new), $_ with xml.&elem('localeDisplayNames');
    CLDR::Numbers.parse:            (base<numbers>            //= Hash.new), $_ with xml.&elem('numbers');
    CLDR::Posix.parse:              (base<posix>              //= Hash.new), $_ with xml.&elem('posix');
    CLDR::Units.parse:              (base<units>              //= Hash.new), $_ with xml.&elem('units');
}
#>>>>> # GENERATOR
