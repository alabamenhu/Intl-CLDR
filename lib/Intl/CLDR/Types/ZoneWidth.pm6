use Intl::CLDR::Immutability;

#| A class implementing CLDR's <dates> element, containing information about formatting dates.
unit class CLDR-ZoneWidth is CLDR-Item;


has     $!parent;         #= The CLDR-Dates object containing this CLDR-Fields
has Str $.generic;
has Str $.standard;
has Str $.daylight;

#| Creates a new CLDR-Dates object
method new(|c) {
    self.bless!bind-init: |c;
}

submethod !bind-init(\blob, uint64 $offset is rw, \parent) {
    $!parent := parent;

    self.Hash::BIND-KEY: 'generic',  $!generic;
    self.Hash::BIND-KEY: 'standard', $!standard;
    self.Hash::BIND-KEY: 'daylight', $!daylight;

    use Intl::CLDR::Classes::StrDecode;

    $!generic  = StrDecode::get( blob, $offset);
    $!standard = StrDecode::get( blob, $offset);
    $!daylight = StrDecode::get( blob, $offset);

    self
}

##`<<<<< # GENERATOR: This method should only be uncommented out by the parsing script
method encode(%*zone-width) {
    use Intl::CLDR::Classes::StrEncode;

    my $result = buf8.new;

    $result ~= StrEncode::get(%*zone-width<generic>  // '');
    $result ~= StrEncode::get(%*zone-width<standard> // '');
    $result ~= StrEncode::get(%*zone-width<daylight> // '');

    $result
}
method parse(\base, \xml) {
    use Intl::CLDR::Util::XML-Helper;
    with xml.&elem('generic' ) { base<generic>  = contents $_ }
    with xml.&elem('standard') { base<standard> = contents $_ }
    with xml.&elem('daylight') { base<daylight> = contents $_ }
}
#>>>>> # GENERATOR
