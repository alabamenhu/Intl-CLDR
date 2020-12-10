use Intl::CLDR::Immutability;
use Intl::CLDR::Types::ZoneWidth;

unit class CLDR-Zone is CLDR-ItemNew;

has Str            $.exemplar-city;
has CLDR-ZoneWidth $.long;
has CLDR-ZoneWidth $.short;

#| Creates a new CLDR-Zone object
method new(|c) {
    self.bless!bind-init: |c;
}

submethod !bind-init(\blob, uint64 $offset is rw) {

    use Intl::CLDR::Util::StrDecode;

    $!exemplar-city  = StrDecode::get(     blob, $offset);
    $!long           = CLDR-ZoneWidth.new: blob, $offset;
    $!short          = CLDR-ZoneWidth.new: blob, $offset;

    self
}

constant \detour = Map.new: (
    exemplarCity => 'exemplar-city'
);
method DETOUR (--> detour) {;}

##`<<<<< # GENERATOR: This method should only be uncommented out by the parsing script
method encode(%*zone) {
    use Intl::CLDR::Util::StrEncode;

    my $result = buf8.new;

    $result ~= StrEncode::get(%*zone<exemplarCity> // '');
    $result ~= CLDR-ZoneWidth.encode(%*zone<long> // Hash);
    $result ~= CLDR-ZoneWidth.encode(%*zone<short> // Hash);

    $result
}
method parse(\base, \xml) {
    use Intl::CLDR::Util::XML-Helper;
    with xml.&elem('exemplarCity', :ignore-alt) { base<exemplarCity> = contents $_ }
    with xml.&elem('short') { CLDR-ZoneWidth.parse: (base<short> //= Hash.new), $_ }
    with xml.&elem('long' ) { CLDR-ZoneWidth.parse: (base<long>  //= Hash.new), $_ }
}
#>>>>> # GENERATOR
