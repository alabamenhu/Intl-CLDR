use Intl::CLDR::Immutability;

use Intl::CLDR::Types::Field;

#| A class implementing CLDR's <dates> element, containing information about formatting dates.
unit class CLDR-Fields is CLDR-ItemNew;


has            $!parent;         #= The CLDR-Dates object containing this CLDR-Fields
has CLDR-Field $.era;
has CLDR-Field $.year;
has CLDR-Field $.quarter;
has CLDR-Field $.month;
has CLDR-Field $.week;
has CLDR-Field $.week-of-month;
has CLDR-Field $.day;
has CLDR-Field $.day-of-year;
has CLDR-Field $.weekday;
has CLDR-Field $.weekday-of-month;
has CLDR-Field $.sun;
has CLDR-Field $.mon;
has CLDR-Field $.tue;
has CLDR-Field $.wed;
has CLDR-Field $.thu;
has CLDR-Field $.fri;
has CLDR-Field $.sat;
has CLDR-Field $.dayperiod;
has CLDR-Field $.hour;
has CLDR-Field $.minute;
has CLDR-Field $.second;
has CLDR-Field $.zone;

#| Creates a new CLDR-Dates object
method new(|c) {
    self.bless!bind-init: |c;
}

submethod !bind-init(\blob, uint64 $offset is rw) {

    $!era              = CLDR-Field.new: blob, $offset;
    $!year             = CLDR-Field.new: blob, $offset;
    $!quarter          = CLDR-Field.new: blob, $offset;
    $!month            = CLDR-Field.new: blob, $offset;
    $!week             = CLDR-Field.new: blob, $offset;
    $!week-of-month    = CLDR-Field.new: blob, $offset;
    $!day              = CLDR-Field.new: blob, $offset;
    $!day-of-year      = CLDR-Field.new: blob, $offset;
    $!weekday          = CLDR-Field.new: blob, $offset;
    $!weekday-of-month = CLDR-Field.new: blob, $offset;
    $!sun              = CLDR-Field.new: blob, $offset;
    $!mon              = CLDR-Field.new: blob, $offset;
    $!tue              = CLDR-Field.new: blob, $offset;
    $!wed              = CLDR-Field.new: blob, $offset;
    $!thu              = CLDR-Field.new: blob, $offset;
    $!fri              = CLDR-Field.new: blob, $offset;
    $!sat              = CLDR-Field.new: blob, $offset;
    $!dayperiod        = CLDR-Field.new: blob, $offset;
    $!hour             = CLDR-Field.new: blob, $offset;
    $!minute           = CLDR-Field.new: blob, $offset;
    $!second           = CLDR-Field.new: blob, $offset;
    $!zone             = CLDR-Field.new: blob, $offset;

    self
}

constant \detour = Map.new(
    weekdayOfMonth => 'weekday-of-month',
    dayOfYear      => 'day-of-year',
    weekOfMonth    => 'week-of-month'
);
method DETOUR(--> detour) {;}


##`<<<<< # GENERATOR: This method should only be uncommented out by the parsing script
method encode(%*fields) {
    my $result = buf8.new;

    use Intl::CLDR::Util::StrEncode;

    my $*field-type;

    for <era year quarter month week weekOfMonth day dayOfYear weekday weekdayOfMonth
         sun mon tue wed thu fri sat dayperiod hour minute second zone> -> $*field-type {
        $result ~= CLDR-Field.encode: (%*fields{$*field-type} // Hash);
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
            CLDR-Field.parse: (base{type} //= Hash.new), fields{type, "{type}-short", "{type}-narrow"}
        }
    }
}
#>>>>> # GENERATOR
