#| A class implementing CLDR's <coordinateUnit> element, which
#| contains information about formatting geographic coordinates.
unit class CLDR::Coordinates;
    use Intl::CLDR::Core;
    also does CLDR::Item;

use Intl::CLDR::Types::CoordinateWidth;

has CLDR::CoordinateWidth $.long;   #= Pattern for degrees due north
has CLDR::CoordinateWidth $.short;  #= Pattern for degrees due north
has CLDR::CoordinateWidth $.narrow; #= Pattern for degrees due east

#| Creates a new CLDR-Units object
method new(\blob, uint64 $offset is rw --> ::?CLASS) {
    use Intl::CLDR::Util::StrDecode;
    self.bless:
        long   => CLDR::CoordinateWidth.new(blob, $offset),
        short  => CLDR::CoordinateWidth.new(blob, $offset),
        narrow => CLDR::CoordinateWidth.new(blob, $offset),
}

#`<<<<<# GENERATOR: Use toggle-generators.raku to [dis|en]able this code.
method encode(%*durations) {
    use Intl::CLDR::Util::StrEncode;
    my $result = buf8.new;

    $result ~= CLDR::CoordinateWidth.encode(%*durations<long>   // %*durations<short> // Hash);
    $result ~= CLDR::CoordinateWidth.encode(%*durations<short>  // '');
    $result ~= CLDR::CoordinateWidth.encode(%*durations<narrow> // %*durations<short> // Hash);

    $result
}
method parse(\base, \xml) {
    use Intl::CLDR::Util::XML-Helper;
    CLDR::CoordinateWidth.parse: (base{$*length} //= Hash.new), xml;
}
>>>>># GENERATOR