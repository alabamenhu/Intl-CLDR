#| A class implementing CLDR's <fields> element, containing information about formatting dates.
unit class CLDR::Fields;
    use Intl::CLDR::Core;
    also does CLDR::Item;

use Intl::CLDR::Types::Field;

has CLDR::Field $.era;
has CLDR::Field $.year;
has CLDR::Field $.quarter;
has CLDR::Field $.month;
has CLDR::Field $.week;
has CLDR::Field $.week-of-month    is aliased-by<weekOfMonth>;
has CLDR::Field $.day;
has CLDR::Field $.day-of-year      is aliased-by<dayOfYear>;
has CLDR::Field $.weekday;
has CLDR::Field $.weekday-of-month is aliased-by<weekdayOfMonth>;
has CLDR::Field $.sun;
has CLDR::Field $.mon;
has CLDR::Field $.tue;
has CLDR::Field $.wed;
has CLDR::Field $.thu;
has CLDR::Field $.fri;
has CLDR::Field $.sat;
has CLDR::Field $.dayperiod;
has CLDR::Field $.hour;
has CLDR::Field $.minute;
has CLDR::Field $.second;
has CLDR::Field $.zone;

#| Creates a new CLDR-Dates object
method new(\blob, uint64 $offset is rw --> ::?CLASS) {
    self.bless:

    era              => CLDR::Field.new(blob, $offset),
    year             => CLDR::Field.new(blob, $offset),
    quarter          => CLDR::Field.new(blob, $offset),
    month            => CLDR::Field.new(blob, $offset),
    week             => CLDR::Field.new(blob, $offset),
    week-of-month    => CLDR::Field.new(blob, $offset),
    day              => CLDR::Field.new(blob, $offset),
    day-of-year      => CLDR::Field.new(blob, $offset),
    weekday          => CLDR::Field.new(blob, $offset),
    weekday-of-month => CLDR::Field.new(blob, $offset),
    sun              => CLDR::Field.new(blob, $offset),
    mon              => CLDR::Field.new(blob, $offset),
    tue              => CLDR::Field.new(blob, $offset),
    wed              => CLDR::Field.new(blob, $offset),
    thu              => CLDR::Field.new(blob, $offset),
    fri              => CLDR::Field.new(blob, $offset),
    sat              => CLDR::Field.new(blob, $offset),
    dayperiod        => CLDR::Field.new(blob, $offset),
    hour             => CLDR::Field.new(blob, $offset),
    minute           => CLDR::Field.new(blob, $offset),
    second           => CLDR::Field.new(blob, $offset),
    zone             => CLDR::Field.new(blob, $offset),
}

##`<<<<< # GENERATOR: This method should only be uncommented out by the parsing script
method encode(%*fields) {
    my $result = buf8.new;

    use Intl::CLDR::Util::StrEncode;

    my $*field-type;

    for <era year quarter month week weekOfMonth day dayOfYear weekday weekdayOfMonth
         sun mon tue wed thu fri sat dayperiod hour minute second zone> -> $*field-type {
        $result ~= CLDR::Field.encode: (%*fields{$*field-type} // Hash);
    }

    $result
}
method parse(\base, \xml) {
    use Intl::CLDR::Util::XML-Helper;
    my \fields = Hash.new;
    fields{$_<type>} = $_ for xml.&elems('field');

    for <era quarter month week weekOfMonth day dayOfYear weekday weekdayOfMonth
         sun mon tue wed thu fri sat dayperiod hour minute second zone> -> \type {
        with fields{type} {
            CLDR::Field.parse: (base{type} //= Hash.new), fields{type, "{type}-short", "{type}-narrow"}
        }
    }
}
#>>>>> # GENERATOR
