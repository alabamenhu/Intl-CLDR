use Intl::CLDR::Immutability;

unit class CLDR-AppendItems is CLDR-Item;

has $!parent;
has Str $.era;
has Str $.year;
has Str $.quarter;
has Str $.month;
has Str $.week;
has Str $.week-of-month;
has Str $.day;
has Str $.day-of-year;
has Str $.weekday;
has Str $.weekday-of-month;
has Str $.dayperiod;
has Str $.hour;
has Str $.minute;
has Str $.second;
has Str $.zone;

#| Creates a new CLDR-Dates object
method new(|c) {
    self.bless!bind-init: |c;
}

submethod !bind-init(\blob,uint64 $offset is rw, \parent) {
    $!parent := parent;

    # For some inane reason, CLDR switches to Pascal case here
    self.Hash::BIND-KEY: 'era',              $!era;
    self.Hash::BIND-KEY: 'Era',              $!era;
    self.Hash::BIND-KEY: 'year',             $!year;
    self.Hash::BIND-KEY: 'Year',             $!year;
    self.Hash::BIND-KEY: 'quarter',          $!quarter;
    self.Hash::BIND-KEY: 'Quarter',          $!quarter;
    self.Hash::BIND-KEY: 'month',            $!month;
    self.Hash::BIND-KEY: 'Month',            $!month;
    self.Hash::BIND-KEY: 'week',             $!week;
    self.Hash::BIND-KEY: 'Week',             $!week;
    self.Hash::BIND-KEY: 'week-of-month',    $!week-of-month;
    self.Hash::BIND-KEY: 'Week-Of-Month',    $!week-of-month;
    self.Hash::BIND-KEY: 'day',              $!day;
    self.Hash::BIND-KEY: 'Day',              $!day;
    self.Hash::BIND-KEY: 'day-of-year',      $!day-of-year;
    self.Hash::BIND-KEY: 'Day-Of-Year',      $!day-of-year;
    self.Hash::BIND-KEY: 'weekday',          $!weekday;
    self.Hash::BIND-KEY: 'Weekday',          $!weekday;
    self.Hash::BIND-KEY: 'weekday-of-month', $!weekday-of-month;
    self.Hash::BIND-KEY: 'Weekday-Of-Month', $!weekday-of-month;
    self.Hash::BIND-KEY: 'dayperiod',        $!dayperiod;
    self.Hash::BIND-KEY: 'Dayperiod',        $!dayperiod;
    self.Hash::BIND-KEY: 'hour',             $!hour;
    self.Hash::BIND-KEY: 'Hour',             $!hour;
    self.Hash::BIND-KEY: 'minute',           $!minute;
    self.Hash::BIND-KEY: 'Minute',           $!minute;
    self.Hash::BIND-KEY: 'second',           $!second;
    self.Hash::BIND-KEY: 'Second',           $!second;
    self.Hash::BIND-KEY: 'zone',             $!zone;
    self.Hash::BIND-KEY: 'Zone',             $!zone;

    loop {
        my   \code  = blob[$offset++];
        if    code == 1 { $! = StrDecode::get(blob, $offset) }
        elsif code == 2 { $! = StrDecode::get(blob, $offset) }
        elsif code == 3 { $! = StrDecode::get(blob, $offset) }
        elsif code == 4 { $! = StrDecode::get(blob, $offset) }
        elsif code == 0 { last                                                 }
        else            { die "Unknown element {code} found when decoding DateFormats element" }
    }

    self
}

##`<<<<<#GENERATOR: This method should only be uncommented out by the parsing script
method encode(\hash) {
    use Intl::CLDR::Classes::StrEncode;
    my buf8 $result = [~] do for hash.kv -> $_, \value {
        when 'full'   { StrEncode.get(value).append: 1 }
        when 'long'   { StrEncode.get(value).append: 2 }
        when 'medium' { StrEncode.get(value).append: 3 }
        when 'short'  { StrEncode.get(value).append: 4 }
        default       { die "Unknown value passed to CLDR-DateFormats encoder" }
    }

    $result.append: 0
}
#>>>>>#GENERATOR
