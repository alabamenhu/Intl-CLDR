use Intl::CLDR::Immutability;

unit class CLDR-CyclicNameSets is CLDR-ItemNew;

use Intl::CLDR::Types::CyclicNameSet;

has $!parent;
has CLDR-CyclicNameSet $.years;
has CLDR-CyclicNameSet $.months;
has CLDR-CyclicNameSet $.days;
has CLDR-CyclicNameSet $.day-parts;
has CLDR-CyclicNameSet $.zodiacs;
has CLDR-CyclicNameSet $.solar-terms;

#| Creates a new CLDR-CyclicNameSets object
method new(|c) {
    self.bless!bind-init: |c;
}

submethod !bind-init(\blob, uint64 $offset is rw, \parent) {
    $!parent := parent;

    $!years       = CLDR-CyclicNameSet.new: blob, $offset, self;
    $!months      = CLDR-CyclicNameSet.new: blob, $offset, self;
    $!days        = CLDR-CyclicNameSet.new: blob, $offset, self;
    $!day-parts   = CLDR-CyclicNameSet.new: blob, $offset, self;
    $!zodiacs     = CLDR-CyclicNameSet.new: blob, $offset, self;
    $!solar-terms = CLDR-CyclicNameSet.new: blob, $offset, self;

    self
}
constant \detour = Map.new(
    dayParts   => 'day-parts',
    solarTerms => 'solar-terms'
);
method DETOUR(--> detour) {;}

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
