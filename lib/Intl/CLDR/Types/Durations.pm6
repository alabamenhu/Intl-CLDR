use Intl::CLDR::Immutability;


#| A class implementing CLDR's <dates> element, containing information about formatting dates.
unit class CLDR-Durations is CLDR-ItemNew;

has Str $.hm;    #= Hours and minutes
has Str $.ms;    #= Minutes and seconds
has Str $.hms;   #= Hours minutes and seconds

#| Creates a new CLDR-Units object
method new(|c --> CLDR-Durations) {
    self.bless!bind-init: |c;
}

submethod !bind-init(\blob, uint64 $offset is rw --> CLDR-Durations) {
    use Intl::CLDR::Util::StrDecode;
    $!hm  = StrDecode::get(blob, $offset);
    $!ms  = StrDecode::get(blob, $offset);
    $!hms = StrDecode::get(blob, $offset);

    self
}

##`<<<<< # GENERATOR: This method should only be uncommented out by the parsing script
method encode(%*durations) {
    use Intl::CLDR::Util::StrEncode;
    my $result = buf8.new;

    $result ~= StrEncode::get(%*durations<hm>  // '');
    $result ~= StrEncode::get(%*durations<ms>  // '');
    $result ~= StrEncode::get(%*durations<hms> // '');

    $result
}
method parse(\base, \xml) {
    use Intl::CLDR::Util::XML-Helper;
    base{xml<type>} = contents $_ with xml.&elem('durationUnitPattern');
}
#>>>>> # GENERATOR
