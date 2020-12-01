use Intl::CLDR::Immutability;

use Intl::CLDR::Types::Field;

#| A class implementing CLDR's <dates> element, containing information about formatting dates.
unit class CLDR-Fields is CLDR-Item;


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

submethod !bind-init(\blob, uint64 $offset is rw, \parent) {
    $!parent := parent;

    self.Hash::BIND-KEY: 'era',              $!era;
    self.Hash::BIND-KEY: 'year',             $!year;
    self.Hash::BIND-KEY: 'quarter',          $!quarter;
    self.Hash::BIND-KEY: 'month',            $!month;
    self.Hash::BIND-KEY: 'week',             $!week;
    self.Hash::BIND-KEY: 'week-of-month',    $!week-of-month;
    self.Hash::BIND-KEY: 'weekOfMonth',      $!week-of-month;
    self.Hash::BIND-KEY: 'day',              $!day;
    self.Hash::BIND-KEY: 'day-of-year',      $!day-of-year;
    self.Hash::BIND-KEY: 'dayOfYear',        $!day-of-year;
    self.Hash::BIND-KEY: 'weekday-of-month', $!weekday-of-month;
    self.Hash::BIND-KEY: 'weekdayOfMonth',   $!weekday-of-month;
    self.Hash::BIND-KEY: 'sun',              $!sun;
    self.Hash::BIND-KEY: 'mon',              $!mon;
    self.Hash::BIND-KEY: 'tue',              $!tue;
    self.Hash::BIND-KEY: 'wed',              $!wed;
    self.Hash::BIND-KEY: 'thu',              $!thu;
    self.Hash::BIND-KEY: 'fri',              $!fri;
    self.Hash::BIND-KEY: 'sat',              $!sat;
    self.Hash::BIND-KEY: 'dayperiod',        $!dayperiod;
    self.Hash::BIND-KEY: 'hour',             $!hour;
    self.Hash::BIND-KEY: 'minute',           $!minute;
    self.Hash::BIND-KEY: 'second',           $!second;
    self.Hash::BIND-KEY: 'zone',             $!zone;

    $!era              = CLDR-Field.new: blob, $offset, self;
    $!year             = CLDR-Field.new: blob, $offset, self;
    $!quarter          = CLDR-Field.new: blob, $offset, self;
    $!month            = CLDR-Field.new: blob, $offset, self;
    $!week             = CLDR-Field.new: blob, $offset, self;
    $!week-of-month    = CLDR-Field.new: blob, $offset, self;
    $!day              = CLDR-Field.new: blob, $offset, self;
    $!day-of-year      = CLDR-Field.new: blob, $offset, self;
    $!weekday          = CLDR-Field.new: blob, $offset, self;
    $!weekday-of-month = CLDR-Field.new: blob, $offset, self;
    $!sun              = CLDR-Field.new: blob, $offset, self;
    $!mon              = CLDR-Field.new: blob, $offset, self;
    $!tue              = CLDR-Field.new: blob, $offset, self;
    $!wed              = CLDR-Field.new: blob, $offset, self;
    $!thu              = CLDR-Field.new: blob, $offset, self;
    $!fri              = CLDR-Field.new: blob, $offset, self;
    $!sat              = CLDR-Field.new: blob, $offset, self;
    $!dayperiod        = CLDR-Field.new: blob, $offset, self;
    $!hour             = CLDR-Field.new: blob, $offset, self;
    $!minute           = CLDR-Field.new: blob, $offset, self;
    $!second           = CLDR-Field.new: blob, $offset, self;
    $!zone             = CLDR-Field.new: blob, $offset, self;

    self
}

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
