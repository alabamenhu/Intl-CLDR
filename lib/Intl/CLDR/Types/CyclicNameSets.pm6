use Intl::CLDR::Immutability;

unit class CLDR-CyclicNameSets is CLDR-Item;

use Intl::CLDR::Types::CyclicNameSet;

has $!parent;
has CLDR-CyclicNameSet $.years;
has CLDR-CyclicNameSet $.months;
has CLDR-CyclicNameSet $.days;
has CLDR-CyclicNameSet $.day-parts;
has CLDR-CyclicNameSet $.zodiacs;
has CLDR-CyclicNameSet $.solar-terms;

#| Creates a new CLDR-Dates object
method new(|c) {
    self.bless!bind-init: |c;
}

submethod !bind-init(\blob, uint64 $offset is rw, \parent) {
    $!parent := parent;

    self.Hash::BIND-KEY: 'years', $!years;
    self.Hash::BIND-KEY: 'months', $!months;
    self.Hash::BIND-KEY: 'days', $!days;
    self.Hash::BIND-KEY: 'day-parts', $!day-parts;
    self.Hash::BIND-KEY: 'dayParts', $!day-parts;
    self.Hash::BIND-KEY: 'zodiacs', $!zodiacs;
    self.Hash::BIND-KEY: 'solar-terms', $!solar-terms;
    self.Hash::BIND-KEY: 'solarTerms', $!solar-terms;

    $!years       = CLDR-CyclicNameSet.new: blob, $offset, self;
    $!months      = CLDR-CyclicNameSet.new: blob, $offset, self;
    $!days        = CLDR-CyclicNameSet.new: blob, $offset, self;
    $!day-parts   = CLDR-CyclicNameSet.new: blob, $offset, self;
    $!zodiacs     = CLDR-CyclicNameSet.new: blob, $offset, self;
    $!solar-terms = CLDR-CyclicNameSet.new: blob, $offset, self;

    self
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
#>>>>> # GENERATOR
