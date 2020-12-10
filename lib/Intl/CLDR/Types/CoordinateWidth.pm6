use Intl::CLDR::Immutability;


#| A class implementing CLDR's <dates> element, containing information about formatting dates.
unit class CLDR-CoordinateWidth is CLDR-ItemNew;

has Str $.display-name; #= Pattern for degrees due north
has Str $.north; #= Pattern for degrees due north
has Str $.east;  #= Pattern for degrees due east
has Str $.south; #= Pattern for degrees due south
has Str $.west;  #= Pattern for degrees due west

#| Creates a new CLDR-Units object
method new(|c --> CLDR-CoordinateWidth) {
    self.bless!bind-init: |c;
}

submethod !bind-init(\blob, uint64 $offset is rw --> CLDR-CoordinateWidth) {
    use Intl::CLDR::Util::StrDecode;
    $!display-name = StrDecode::get(blob, $offset);
    $!north = StrDecode::get(blob, $offset);
    $!east  = StrDecode::get(blob, $offset);
    $!south = StrDecode::get(blob, $offset);
    $!west  = StrDecode::get(blob, $offset);

    self
}

##`<<<<< # GENERATOR: This method should only be uncommented out by the parsing script
method encode(%*durations) {
    use Intl::CLDR::Util::StrEncode;
    my $result = buf8.new;

    $result ~= StrEncode::get(%*durations<displayName> // '');
    $result ~= StrEncode::get(%*durations<north> // '');
    $result ~= StrEncode::get(%*durations<east>  // '');
    $result ~= StrEncode::get(%*durations<south> // '');
    $result ~= StrEncode::get(%*durations<west>  // '');

    $result
}
method parse(\base, \xml) {
    use Intl::CLDR::Util::XML-Helper;
    base{.<type>}     = contents $_ for  xml.&elems('coordinateUnitPattern');
    base<displayName> = contents $_ with xml.&elem( 'displayName');
}
#>>>>> # GENERATOR
