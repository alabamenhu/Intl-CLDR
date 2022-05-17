#| A class implementing CLDR's <grammar> element
unit class CLDR::Grammar;
    use Intl::CLDR::Core;
    also does CLDR::Item;

use Intl::CLDR::Types::Plurals;
#use Intl::CLDR::Types::Features;
use Intl::CLDR::Types::Derivations;

has CLDR::Plurals      $.plurals;
#has CLDR-Features     $.features;
has CLDR::Derivations  $.derivations;

#| Creates a new CLDR-Dates object
method new(\blob, uint64 $offset is rw --> ::?CLASS) {
    use Intl::CLDR::Util::StrDecode;

    self.bless:
        plurals     => CLDR::Plurals.new(blob, $offset),
      # features    => CLDR::Features.new(blob, $offset)
        derivations => CLDR::Derivations.new(blob, $offset),

}

##`<<<<< # GENERATOR: This method should only be uncommented out by the parsing script
method encode(%*grammar) {
    my $result = buf8.new;

    $result ~= CLDR::Plurals.encode(    %*grammar<plurals>);
    #$result ~= CLDR-Features.encode(   %*grammar<features>);
    $result ~= CLDR::Derivations.encode(%*grammar<derivations>);

    $result
}
method parse(\base, \xml) {
    use Intl::CLDR::Util::XML-Helper;
    CLDR::Plurals.parse:     (base<plurals>     //= Hash.new), $;
    CLDR::Derivations.parse: (base<derivations> //= Hash.new), $*grammar-xml;

}
#>>>>> # GENERATOR
