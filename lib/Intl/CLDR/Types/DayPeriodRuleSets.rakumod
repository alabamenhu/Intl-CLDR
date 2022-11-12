unit class CLDR::DayPeriodRuleSets;
    use Intl::CLDR::Core;
    also does CLDR::Item;

use Intl::CLDR::Types::DayPeriodRules;

has CLDR::DayPeriodRules $.standard;   #= Used for formatting times
has CLDR::DayPeriodRules $.selection;  #= Used for generating messages

#| Creates a new CLDR-Dates object
method new(\blob, uint64 $offset is rw) {
    self.bless:
        standard  => CLDR::DayPeriodRules.new(blob, $offset),
        selection => CLDR::DayPeriodRules.new(blob, $offset),
}

#`<<<<<# GENERATOR: Use toggle-generators.raku to [dis|en]able this code.
method encode(\hash) {

    my $result = buf8.new;

    for <standard selection> -> $*set-type {
        $result ~= CLDR::DayPeriodRules.encode: hash{$*set-type};
    }

    $result;
}
method parse(\base, \xml) {
    use Intl::CLDR::Util::XML-Helper;
    CLDR::DayPeriodRules.parse: (base{.<type> // 'standard'} //= Hash.new), $_ for xml.&elems('dayPeriodRuleSet')
    # TODO ^^ these fallbacks aren't fully accurate for regional variants of base languages
#    base{.<type>} = %( at => .<at>, from => .<from>, before => .<before>) for xml.&elems('dayPeriodRule')
}

>>>>># GENERATOR