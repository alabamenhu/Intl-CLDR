use Intl::CLDR::Immutability;

use Intl::CLDR::Types::Calendars;
use Intl::CLDR::Types::Fields;
use Intl::CLDR::Types::TimezoneNames;


#| A class implementing CLDR's <dates> element, containing information about formatting dates.
unit class CLDR-Dates is CLDR-Item;


has                    $!parent;         #= The CLDR-Base object containing this CLDR-Dates
has CLDR-Calendars     $.calendars;      #= The calendar data for the date collection
has CLDR-Fields        $.fields;         #= The fields (naming) data for the date collection
has CLDR-TimezoneNames $.timezone-names; #= The timezone data for the date collection

#| Creates a new CLDR-Dates object
method new(|c) {
    self.bless!bind-init: |c;
}

submethod !bind-init(\blob, uint64 $offset is rw, \parent = "foo") {
    $!parent := parent;

    self.Hash::BIND-KEY: 'calendars',      $!calendars;
    self.Hash::BIND-KEY: 'fields',         $!fields;
    self.Hash::BIND-KEY: 'timezone-names', $!timezone-names;
    self.Hash::BIND-KEY: 'timeZoneNames',  $!timezone-names;

    $!calendars      = CLDR-Calendars.new:     blob, $offset, self;
    $!fields         = CLDR-Fields.new:        blob, $offset, self;
    $!timezone-names = CLDR-TimezoneNames.new: blob, $offset, self;

    self
}

##`<<<<< # GENERATOR: This method should only be uncommented out by the parsing script
method encode(%*dates) {
    my $result = buf8.new;

    $result ~= CLDR-Calendars.encode:     %*dates<calendars>;
    $result ~= CLDR-Fields.encode:        %*dates<fields>;
    $result ~= CLDR-TimezoneNames.encode: %*dates<timeZoneNames>;

    $result
}
method parse(\base, \xml) {
    use Intl::CLDR::Util::XML-Helper;
    CLDR-Calendars.parse:     (base<calendars>     //= Hash.new), $_ with xml.&elem('calendars');
    CLDR-Fields.parse:        (base<fields>        //= Hash.new), $_ with xml.&elem('fields');
    CLDR-TimezoneNames.parse: (base<timeZoneNames> //= Hash.new), $_ with xml.&elem('timeZoneNames');
}
#>>>>> # GENERATOR
