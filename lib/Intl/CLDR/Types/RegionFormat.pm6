use Intl::CLDR::Immutability;

#| A class implementing CLDR's <dates> element, containing information about formatting dates.
unit class CLDR-RegionFormat is CLDR-Item;


has     $!parent; #= The CLDR-FieldWidth object containing this CLDR-RelativeTime
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
