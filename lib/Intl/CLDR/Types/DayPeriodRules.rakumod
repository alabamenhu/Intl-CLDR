unit class CLDR::DayPeriodRules;
    use Intl::CLDR::Core;
    also does CLDR::Item;

use Intl::CLDR::Types::DayPeriodRule;

has CLDR::DayPeriodRule $.noon;       #= The special name of 12:00 noon
has CLDR::DayPeriodRule $.midnight;   #= The special name of 0:00/24:00 midnight
has CLDR::DayPeriodRule $.morning1;   #= The name for an (early) morning period
has CLDR::DayPeriodRule $.morning2;   #= The name for a (late) morning period
has CLDR::DayPeriodRule $.afternoon1; #= The name for an (early) afternoon period
has CLDR::DayPeriodRule $.afternoon2; #= The name for a (late) afternoon period
has CLDR::DayPeriodRule $.evening1;   #= The name for an (early) evening period
has CLDR::DayPeriodRule $.evening2;   #= The name for a (late) evening period
has CLDR::DayPeriodRule $.night1;     #= The name for an (early) night period
has CLDR::DayPeriodRule $.night2;     #= The name for a (late) night period

#| Creates a new CLDR-Dates object
method new(\blob, uint64 $offset is rw) {
    self.bless:
        noon       => CLDR::DayPeriodRule.new(blob, $offset),
        midnight   => CLDR::DayPeriodRule.new(blob, $offset),
        morning1   => CLDR::DayPeriodRule.new(blob, $offset),
        morning2   => CLDR::DayPeriodRule.new(blob, $offset),
        afternoon1 => CLDR::DayPeriodRule.new(blob, $offset),
        afternoon2 => CLDR::DayPeriodRule.new(blob, $offset),
        evening1   => CLDR::DayPeriodRule.new(blob, $offset),
        evening2   => CLDR::DayPeriodRule.new(blob, $offset),
        night1     => CLDR::DayPeriodRule.new(blob, $offset),
        night2     => CLDR::DayPeriodRule.new(blob, $offset),
}

#`<<<<<# GENERATOR: Use toggle-generators.raku to [dis|en]able this code.
method encode(\hash) {
    my $result = buf8.new;

    for <noon midnight morning1 morning2 afternoon1 afternoon2 evening1 evening2 night1 night2> -> $period {
        $result ~= CLDR::DayPeriodRule.encode: hash{$period}
    }

    $result;
}
method parse(\base, \xml) {
    use Intl::CLDR::Util::XML-Helper;

    my $rule-xml = (
        xml.&elems('dayPeriodRules').grep($*lang (elem) *.<locales>.words) ||
        xml.&elems('dayPeriodRules').grep('root' (elem) *.<locales>.words)
    ).head;

    base{.<type>} = %( at => .<at>, from => .<from>, before => .<before>) for $rule-xml.&elems('dayPeriodRule')
}

>>>>># GENERATOR