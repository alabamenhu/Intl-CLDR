use Intl::CLDR::Immutability;

#| A class implementing CLDR's <plurals> element
unit class CLDR-Plurals is CLDR-ItemNew;

use Intl::CLDR::Types::PluralRuleSet;
use Intl::CLDR::Types::PluralRangeRuleSet;

has CLDR-PluralRuleSet      $.cardinal;  #= The rules for cardinal numbers (one, two, three and a half, etc).
has CLDR-PluralRuleSet      $.ordinal;   #= The rules for ordinal numbers (first, second, third, etc).
has CLDR-PluralRangeRuleSet $.ranges;    #= The rule cardinal ranges (1 to 3, 4.5 to 9, etc).

#| Creates a new CLDR-Plurals object
method new(|c) {
    self.bless!bind-init: |c;
}

submethod !bind-init(\blob, uint64 $offset is rw) {
    use Intl::CLDR::Util::StrDecode;

    $!cardinal = CLDR-PluralRuleSet.new:      blob, $offset;
    $!ordinal  = CLDR-PluralRuleSet.new:      blob, $offset;
    $!ranges   = CLDR-PluralRangeRuleSet.new: blob, $offset;

    self
}

##`<<<<< # GENERATOR: This method should only be uncommented out by the parsing script
method encode(%plurals) {
    my $result = buf8.new;

    use Intl::CLDR::Util::StrEncode;

    $result ~= CLDR-PluralRuleSet.encode:      %plurals<cardinal>;
    $result ~= CLDR-PluralRuleSet.encode:      %plurals<ordinal>;
    $result ~= CLDR-PluralRangeRuleSet.encode: %plurals<ranges>;

    $result
}
method parse(\base, \xml) {
    use Intl::CLDR::Util::XML-Helper;

    CLDR-PluralRuleSet.parse:       (base<cardinal> //= Hash.new), $*plurals-cardinal-xml;
    CLDR-PluralRuleSet.parse:       (base<ordinal>  //= Hash.new), $*plurals-ordinal-xml;
    CLDR-PluralRangeRuleSet.parse:  (base<ranges>   //= Hash.new), $*plurals-ranges-xml;

}
#>>>>> # GENERATOR
