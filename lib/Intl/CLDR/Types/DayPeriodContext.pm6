use Intl::CLDR::Immutability;

unit class CLDR-DayPeriodContext is CLDR-Item;

use Intl::CLDR::Types::DayPeriodWidth;

has                     $!parent;
has CLDR-DayPeriodWidth $.narrow;
has CLDR-DayPeriodWidth $.abbreviated;
has CLDR-DayPeriodWidth $.wide;

#| Creates a new CLDR-DayPeriodContext object
method new(|c) {
    self.bless!bind-init: |c;
}

submethod !bind-init(\blob, uint64 $offset is rw, \parent) {
    $!parent := parent;

    self.Hash::BIND-KEY: 'narrow',      $!narrow;
    self.Hash::BIND-KEY: 'abbreviated', $!abbreviated;
    self.Hash::BIND-KEY: 'wide',        $!wide;

    $!narrow      = CLDR-DayPeriodWidth.new: blob, $offset, self;
    $!abbreviated = CLDR-DayPeriodWidth.new: blob, $offset, self;
    $!wide        = CLDR-DayPeriodWidth.new: blob, $offset, self;

    self
}

##`<<<<< # GENERATOR: This method should only be uncommented out by the parsing script
method encode(%*day-period-context --> blob8) {
    my $*day-period-width;
    my $result = buf8.new;

    $*day-period-width = 'narrow';
    $result ~= CLDR-DayPeriodWidth.encode: %*day-period-context<narrow> // Hash;
    $*day-period-width = 'abbreviated';
    $result ~= CLDR-DayPeriodWidth.encode: %*day-period-context<abbreviated> // Hash;
    $*day-period-width = 'wide';
    $result ~= CLDR-DayPeriodWidth.encode: %*day-period-context<wide> // Hash;

    $result;
}
method parse(\base, \xml) {
    use Intl::CLDR::Util::XML-Helper;
    CLDR-DayPeriodWidth.parse: (base{.<type>} //= Hash.new), $_ for xml.&elems('dayPeriodWidth');
}
#>>>>> # GENERATOR
