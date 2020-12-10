use Intl::CLDR::Immutability;

unit class CLDR-DayPeriods is CLDR-ItemNew;

use Intl::CLDR::Types::DayPeriodContext;

has $!parent;
has CLDR-DayPeriodContext $.stand-alone;
has CLDR-DayPeriodContext $.format;

#| Creates a new CLDR-Dates object
method new(|c) {
    self.bless!bind-init: |c;
}

submethod !bind-init(\blob, uint64 $offset is rw, \parent) {
    $!parent := parent;

    $!stand-alone = CLDR-DayPeriodContext.new: blob, $offset, self;
    $!format      = CLDR-DayPeriodContext.new: blob, $offset, self;

    self
}
constant detour = Map.new: (
    standAlone => 'stand-alone'
);
method DETOUR (--> detour) {;}

##`<<<<< # GENERATOR: This method should only be uncommented out by the parsing script
method encode(%*day-periods) {
    my $day-period-context;
    my $result = buf8.new;

    $day-period-context = 'stand-alone';
    $result ~= CLDR-DayPeriodContext.encode: (%*day-periods<stand-alone> // Hash);
    $day-period-context = 'format';
    $result ~= CLDR-DayPeriodContext.encode: (%*day-periods<format> // Hash);

    $result;
}
method parse(\base, \xml) {
    use Intl::CLDR::Util::XML-Helper;
    CLDR-DayPeriodContext.parse: (base{.<type>} //= Hash.new), $_ for xml.&elems('dayPeriodContext');
}

#>>>>> # GENERATOR
