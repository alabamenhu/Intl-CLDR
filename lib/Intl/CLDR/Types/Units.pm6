use Intl::CLDR::Immutability;

use Intl::CLDR::Types::Durations;
use Intl::CLDR::Types::Coordinates;
#use Intl::CLDR::Types::;


#| A class implementing CLDR's <dates> element, containing information about formatting dates.
unit class CLDR-Units is CLDR-ItemNew;

use Intl::CLDR::Types::SimpleUnits;
use Intl::CLDR::Types::CompoundUnits;
use Intl::CLDR::Types::Durations;
use Intl::CLDR::Types::Coordinates;


has CLDR-SimpleUnits   $.simple;     #= The individual units to be described
has CLDR-CompoundUnits $.compound;   #= Patterns for combining units
has CLDR-Durations     $.duration;   #= Patterns for formatting time without rollover (no width options)
has CLDR-Coordinates   $.coordinate; #= Patterns for formatting coordinates (°N, etc)

#| Creates a new CLDR-Units object
method new(|c --> CLDR-Units) {
    self.bless!bind-init: |c;
}

submethod !bind-init(\blob, uint64 $offset is rw --> CLDR-Units) {

    $!simple     = CLDR-SimpleUnits.new:   blob, $offset;
    $!compound   = CLDR-CompoundUnits.new: blob, $offset;
    $!duration   = CLDR-Durations.new:     blob, $offset;
    $!coordinate = CLDR-Coordinates.new:   blob, $offset;

    self
}

##`<<<<< # GENERATOR: This method should only be uncommented out by the parsing script
method encode(%*units) {
    my $result = buf8.new;

    $result ~= CLDR-SimpleUnits.encode:   %*units<simple>;
    $result ~= CLDR-CompoundUnits.encode: %*units<compound>;
    $result ~= CLDR-Durations.encode:     %*units<duration>;
    $result ~= CLDR-Coordinates.encode:   %*units<coordinate>;

    $result
}
method parse(\base, \xml) {
    use Intl::CLDR::Util::XML-Helper;

    # the unitlengths contain compound units AND simple units
    for xml.&elems('unitLength') -> \xml-length {
        my $*length = xml-length<type>; #long short narrow
        CLDR-SimpleUnits.parse:    (base<simple>     //= Hash.new), $_ for  xml-length.&elems('unit');
        CLDR-CompoundUnits.parse:  (base<compound>   //= Hash.new), $_ for  xml-length.&elems('compoundUnit');
        CLDR-Coordinates.parse:    (base<coordinate> //= Hash.new), $_ with xml-length.&elem( 'coordinateUnit'); #one per
    }
    CLDR-Durations.parse: (base<duration> //= Hash.new), $_ for  xml.&elems('durationUnit');
    #use Data::Dump::Tree;
    #dump base<compound>;

}
#>>>>> # GENERATOR
