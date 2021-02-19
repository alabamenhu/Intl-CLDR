use Intl::CLDR::Immutability;

unit class CLDR-AppendItems is CLDR-ItemNew;

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

    use Intl::CLDR::Util::StrDecode;

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

# For some inane reason, CLDR switches to Pascal-Kebab case here
constant detour = Map.new: (
    Era              => 'era',
    Year             => 'year',
    Quarter          => 'quarter',
    Month            => 'month',
    Week             => 'week',
    Week-Of-Month    => 'week-of-month',
    Day              => 'day',
    Day-Of-Year      => 'day-of-year',
    Weekday          => 'weekday',
    Weekday-Of-Month => 'weekday-of-month',
    Dayperiod        => 'dayperiod',
    Hour             => 'hour',
    Minute           => 'minute',
    Second           => 'second',
    Timezone         => 'timezone'
);
method DETOUR (-->detour) {;}

##`<<<<<#GENERATOR: This method should only be uncommented out by the parsing script
method encode(\hash) {
    use Intl::CLDR::Util::StrEncode;

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
