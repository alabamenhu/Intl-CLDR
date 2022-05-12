unit class CLDR::CyclicNameSets;
    use Intl::CLDR::Core;
    also does CLDR::Item;

use Intl::CLDR::Types::CyclicNameSet;

has CLDR::CyclicNameSet $.years;
has CLDR::CyclicNameSet $.months;
has CLDR::CyclicNameSet $.days;
has CLDR::CyclicNameSet $.day-parts   is aliased-by<dayParts>;
has CLDR::CyclicNameSet $.zodiacs;
has CLDR::CyclicNameSet $.solar-terms is aliased-by<solarTerms>;

#| Creates a new CLDR::CyclicNameSets object
method new(\blob, uint64 $offset is rw, \parent) {
    self.bless:
        years       => CLDR::CyclicNameSet.new(blob, $offset),
        months      => CLDR::CyclicNameSet.new(blob, $offset),
        days        => CLDR::CyclicNameSet.new(blob, $offset),
        day-parts   => CLDR::CyclicNameSet.new(blob, $offset),
        zodiacs     => CLDR::CyclicNameSet.new(blob, $offset),
        solar-terms => CLDR::CyclicNameSet.new(blob, $offset),
}

##`<<<<< # GENERATOR: This method should only be uncommented out by the parsing script
method encode(%*cyclic-name-sets) {
    my $result = buf8.new;

    my $*cyclic-name-set;

    $*cyclic-name-set = 'years';
    $result ~= CLDR-CyclicNameSet.encode: %*cyclic-name-sets<years> // Hash;
    $*cyclic-name-set = 'months';
    $result ~= CLDR-CyclicNameSet.encode: %*cyclic-name-sets<months> // Hash;
    $*cyclic-name-set = 'days';
    $result ~= CLDR-CyclicNameSet.encode: %*cyclic-name-sets<days> // Hash;
    $*cyclic-name-set = 'dayParts';
    $result ~= CLDR-CyclicNameSet.encode: %*cyclic-name-sets<dayParts> // Hash;
    $*cyclic-name-set = 'zodiacs';
    $result ~= CLDR-CyclicNameSet.encode: %*cyclic-name-sets<zodiacs> // Hash;
    $*cyclic-name-set = 'solarTerms';
    $result ~= CLDR-CyclicNameSet.encode: %*cyclic-name-sets<solarTerms> // Hash;

    $result
}
method parse(\base, \xml) {
    use Intl::CLDR::Util::XML-Helper;
    CLDR-CyclicNameSet.parse: (base{.<type>} //= Hash.new), $_ for xml.&elems('cyclicNameSet');
}

#>>>>> # GENERATOR
