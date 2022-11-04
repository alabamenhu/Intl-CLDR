unit class CLDR::DayPeriodContext;
    use Intl::CLDR::Core;
    also does CLDR::Item;

use Intl::CLDR::Types::DayPeriodWidth;

has CLDR::DayPeriodWidth $.narrow;
has CLDR::DayPeriodWidth $.abbreviated;
has CLDR::DayPeriodWidth $.wide;

#| Creates a new CLDR-DayPeriodContext object
method new(\blob, uint64 $offset is rw) {
    self.bless:
        narrow      => CLDR::DayPeriodWidth.new(blob, $offset),
        abbreviated => CLDR::DayPeriodWidth.new(blob, $offset),
        wide        => CLDR::DayPeriodWidth.new(blob, $offset),

}

#`<<<<<# GENERATOR: Use toggle-generators.raku to [dis|en]able this code.
method encode(%*day-period-context --> blob8) {
    my $*day-period-width;
    my $result = buf8.new;

    $*day-period-width = 'narrow';
    $result ~= CLDR::DayPeriodWidth.encode: %*day-period-context<narrow> // Hash;
    $*day-period-width = 'abbreviated';
    $result ~= CLDR::DayPeriodWidth.encode: %*day-period-context<abbreviated> // Hash;
    $*day-period-width = 'wide';
    $result ~= CLDR::DayPeriodWidth.encode: %*day-period-context<wide> // Hash;

    $result;
}
method parse(\base, \xml) {
    use Intl::CLDR::Util::XML-Helper;
    CLDR::DayPeriodWidth.parse: (base{.<type>} //= Hash.new), $_ for xml.&elems('dayPeriodWidth');
}
>>>>># GENERATOR