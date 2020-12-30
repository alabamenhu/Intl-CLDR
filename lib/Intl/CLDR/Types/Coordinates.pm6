use Intl::CLDR::Immutability;


#| A class implementing CLDR's <dates> element, containing information about formatting dates.
unit class CLDR-Coordinates is CLDR-ItemNew;
use Intl::CLDR::Types::CoordinateWidth;

has CLDR-CoordinateWidth $.long;   #= Pattern for degrees due north
has CLDR-CoordinateWidth $.short;  #= Pattern for degrees due north
has CLDR-CoordinateWidth $.narrow; #= Pattern for degrees due east

#| Creates a new CLDR-Units object
method new(|c --> CLDR-Coordinates) {
    self.bless!bind-init: |c;
}

submethod !bind-init(\blob, uint64 $offset is rw --> CLDR-Coordinates) {
    use Intl::CLDR::Util::StrDecode;
    $!long   = CLDR-CoordinateWidth.new(blob, $offset);
    $!short  = CLDR-CoordinateWidth.new(blob, $offset);
    $!narrow = CLDR-CoordinateWidth.new(blob, $offset);

    self
}

##`<<<<< # GENERATOR: This method should only be uncommented out by the parsing script
method encode(%*durations) {
    use Intl::CLDR::Util::StrEncode;
    my $result = buf8.new;

    $result ~= CLDR-CoordinateWidth.encode(%*durations<long>   // %*durations<short> // Hash);
    $result ~= CLDR-CoordinateWidth.encode(%*durations<short>  // '');
    $result ~= CLDR-CoordinateWidth.encode(%*durations<narrow> // %*durations<short> // Hash);

    $result
}
method parse(\base, \xml) {
    use Intl::CLDR::Util::XML-Helper;
    CLDR-CoordinateWidth.parse: (base{$*length} //= Hash.new), xml;
}
#>>>>> # GENERATOR
