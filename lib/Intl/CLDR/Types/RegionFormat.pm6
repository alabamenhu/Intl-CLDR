use Intl::CLDR::Immutability;

#| A class implementing CLDR's <dates> element, containing information about formatting dates.
unit class CLDR-RegionFormat is CLDR-ItemNew;

has Str $.generic;
has Str $.standard;
has Str $.daylight;

#| Creates a new CLDR-Dates object
method new(|c) {
    self.bless!bind-init: |c;
}

submethod !bind-init(\blob, uint64 $offset is rw) {

    use Intl::CLDR::Util::StrDecode;

    $!generic  = StrDecode::get( blob, $offset);
    $!standard = StrDecode::get( blob, $offset);
    $!daylight = StrDecode::get( blob, $offset);

    self
}

##`<<<<< # GENERATOR: This method should only be uncommented out by the parsing script
method encode(%*region-format) {
    use Intl::CLDR::Util::StrEncode;

    my $result = buf8.new;

    $result ~= StrEncode::get(%*region-format<generic>  // '');
    $result ~= StrEncode::get(%*region-format<standard> // '');
    $result ~= StrEncode::get(%*region-format<daylight> // '');

    $result
}
#>>>>> # GENERATOR
