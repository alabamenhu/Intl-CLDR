unit class CLDR::DayPeriods;
    use Intl::CLDR::Core;
    also does CLDR::Item;

use Intl::CLDR::Types::DayPeriodContext;

has CLDR::DayPeriodContext  $.stand-alone is aliased-by<standAlone>;
has CLDR::DayPeriodContext  $.format;

#| Creates a new CLDR-Dates object
method new(\blob, uint64 $offset is rw) {
    self.bless:
        stand-alone => CLDR::DayPeriodContext.new(blob, $offset),
        format      => CLDR::DayPeriodContext.new(blob, $offset),
}

##`<<<<< # GENERATOR: This method should only be uncommented out by the parsing script
method encode(%*day-periods) {
    my $*day-period-context;
    my $result = buf8.new;

    $*day-period-context = 'stand-alone';
    $result ~= CLDR::DayPeriodContext.encode:  (%*day-periods<stand-alone> // Hash);
    $*day-period-context = 'format';
    $result ~= CLDR::DayPeriodContext.encode:  (%*day-periods<format> // Hash);

    $result;
}
method parse(\base, \xml) {
    use Intl::CLDR::Util::XML-Helper;
    CLDR::DayPeriodContext.parse:  (base{.<type>} //= Hash.new), $_ for xml.&elems('dayPeriodContext');
}
#>>>>> # GENERATOR
