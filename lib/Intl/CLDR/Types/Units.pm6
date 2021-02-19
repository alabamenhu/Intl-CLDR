#| A class implementing CLDR's <units> element, containing information about units of measurement.
unit class CLDR::Units;

use       Intl::CLDR::Core;
also does CLDR::Item;

use Intl::CLDR::Types::SimpleUnits;
use Intl::CLDR::Types::CompoundUnits;
use Intl::CLDR::Types::Durations;
use Intl::CLDR::Types::Coordinates;

has CLDR::SimpleUnits   $.simple;     #= The individual units to be described
has CLDR::CompoundUnits $.compound;   #= Patterns for combining units
has CLDR::Durations     $.duration;   #= Patterns for formatting time without rollover (no width options)
has CLDR::Coordinates   $.coordinate; #= Patterns for formatting coordinates (°N, etc)

#| Creates a new CLDR::Units object
method new(\blob, uint64 $offset is rw --> ::?CLASS) {
    my $simple     = CLDR::SimpleUnits.new:   blob, $offset;
    my $compound   = CLDR::CompoundUnits.new: blob, $offset;
    my $duration   = CLDR::Durations.new:     blob, $offset;
    my $coordinate = CLDR::Coordinates.new:   blob, $offset;

    self.bless: :$simple, :$compound, :$duration, :$coordinate;
}

##`<<<<< # 🄶🄴🄽🄴🅁🄰🅃🄾🅁 This method should only be uncommented out by the parsing script
method encode(%*units) {
    my $result = buf8.new;

    $result ~= CLDR::SimpleUnits.encode:   %*units<simple>;
    $result ~= CLDR::CompoundUnits.encode: %*units<compound>;
    $result ~= CLDR::Durations.encode:     %*units<duration>;
    $result ~= CLDR::Coordinates.encode:   %*units<coordinate>;

    $result
}
method parse(\base, \xml) {
    use Intl::CLDR::Util::XML-Helper;

    # The <unitLength> elements contain compound units *and* simple units
    for xml.&elems('unitLength') -> \xml-length {

        # The length may be long, short, narrow
        my $*length = xml-length<type>;

        CLDR::SimpleUnits.parse:    (base<simple>     //= Hash.new), $_ for  xml-length.&elems('unit');
        CLDR::CompoundUnits.parse:  (base<compound>   //= Hash.new), $_ for  xml-length.&elems('compoundUnit');
        CLDR::Coordinates.parse:    (base<coordinate> //= Hash.new), $_ with xml-length.&elem( 'coordinateUnit'); #one per
    }

    CLDR::Durations.parse: (base<duration> //= Hash.new), $_ for xml.&elems('durationUnit');

}
#>>>>> # GENERATOR
