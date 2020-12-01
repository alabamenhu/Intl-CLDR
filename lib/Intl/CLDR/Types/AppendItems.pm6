use Intl::CLDR::Immutability;

unit class CLDR-AppendItems is CLDR-Item;

###################################################
# Some of these append items aren't in the wild   #
# yet, but they are contemplated in the standard. #
# So, e.g., the hour / minute will probably be    #
# blank in most cases.                            #
###################################################

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
has Str $.timezone;

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
    self.Hash::BIND-KEY: 'timezone',         $!timezone;
    self.Hash::BIND-KEY: 'Timeone',          $!timezone;


    use Intl::CLDR::Classes::StrDecode;

    $!era              = StrDecode::get(blob, $offset);
    $!year             = StrDecode::get(blob, $offset);
    $!quarter          = StrDecode::get(blob, $offset);
    $!month            = StrDecode::get(blob, $offset);
    $!week             = StrDecode::get(blob, $offset);
    $!week-of-month    = StrDecode::get(blob, $offset);
    $!day              = StrDecode::get(blob, $offset);
    $!day-of-year      = StrDecode::get(blob, $offset);
    $!weekday          = StrDecode::get(blob, $offset);
    $!weekday-of-month = StrDecode::get(blob, $offset);
    $!dayperiod        = StrDecode::get(blob, $offset);
    $!hour             = StrDecode::get(blob, $offset);
    $!minute           = StrDecode::get(blob, $offset);
    $!second           = StrDecode::get(blob, $offset);
    $!timezone         = StrDecode::get(blob, $offset);

    self
}

##`<<<<<#GENERATOR: This method should only be uncommented out by the parsing script
method encode(\hash) {
    use Intl::CLDR::Classes::StrEncode;

    my $result = buf8.new;

    for <Era Year Quarter Month Week Week-Of-Month Day Day-Of-Year Weekday Weekday-Of-Month Dayperiod Hour Minute Second Timezone> -> $type {
        $result ~= StrEncode::get(hash{$type} // '');
    }

    $result;

}
method parse(\base, \xml) {
    use Intl::CLDR::Util::XML-Helper;
    base{.<request>} = contents $_ for xml.&elems('appendItem');
}
#>>>>>#GENERATOR
