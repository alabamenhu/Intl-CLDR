use Intl::CLDR::Immutability;

use Intl::CLDR::Types::Calendars;
use Intl::CLDR::Types::Fields;
use Intl::CLDR::Types::TimezoneNames;
use Intl::CLDR::Types::DayPeriodRuleSets;

#| A class implementing CLDR's <dates> element, containing information about formatting dates.
unit class CLDR-Dates is CLDR-ItemNew;

has CLDR-Calendars         $.calendars;        #= The calendar data for the date collection
has CLDR-Fields            $.fields;           #= The fields (naming) data for the date collection
has CLDR-TimezoneNames     $.timezone-names;   #= The timezone data for the date collection
has CLDR-DayPeriodRuleSets $.day-period-rules; #= The day period rules for the date collection
#| Creates a new CLDR-Dates object
method new(|c) {
    self.bless!bind-init: |c;
}

submethod !bind-init(\blob, uint64 $offset is rw) {

    $!calendars        = CLDR-Calendars.new:         blob, $offset;
    $!fields           = CLDR-Fields.new:            blob, $offset;
    $!timezone-names   = CLDR-TimezoneNames.new:     blob, $offset;
    $!day-period-rules = CLDR-DayPeriodRuleSets.new: blob, $offset;

    self
}
constant \detour = Map.new(
    timeZoneNames => 'timezone-names'
);
method DETOUR(--> detour) {;}
##`<<<<< # GENERATOR: This method should only be uncommented out by the parsing script
method encode(%*dates) {
    my $result = buf8.new;

    $result ~= CLDR-Calendars.encode:         %*dates<calendars>;
    $result ~= CLDR-Fields.encode:            %*dates<fields>;
    $result ~= CLDR-TimezoneNames.encode:     %*dates<timeZoneNames>;
    $result ~= CLDR-DayPeriodRuleSets.encode: %*dates<dayPeriodRules>;

    $result
}
method parse(\base, \xml) {
    use Intl::CLDR::Util::XML-Helper;
    CLDR-Calendars.parse:         (base<calendars>      //= Hash.new), $_ with xml.&elem('calendars');
    CLDR-Fields.parse:            (base<fields>         //= Hash.new), $_ with xml.&elem('fields');
    CLDR-TimezoneNames.parse:     (base<timeZoneNames>  //= Hash.new), $_ with xml.&elem('timeZoneNames');
    CLDR-DayPeriodRuleSets.parse: (base<dayPeriodRules> //= Hash.new), $_ with $*day-period-xml
}
#>>>>> # GENERATOR
