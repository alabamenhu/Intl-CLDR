use Intl::CLDR::Immutability;

unit class CLDR-Quarters is CLDR-ItemNew;

use Intl::CLDR::Types::QuarterContext;

has $!parent;
has CLDR-QuarterContext $.stand-alone;
has CLDR-QuarterContext $.format;

#| Creates a new CLDR-Dates object
method new(|c) {
    self.bless!bind-init: |c;
}

submethod !bind-init(\blob, uint64 $offset is rw, \parent) {
    $!parent := parent;

    $!stand-alone = CLDR-QuarterContext.new: blob, $offset, self;
    $!format      = CLDR-QuarterContext.new: blob, $offset, self;

    self
}

constant detour = Map.new: (
    standAlone => 'stand-alone'
);
method DETOUR(-->detour) {;}

##`<<<<< # GENERATOR: This method should only be uncommented out by the parsing script
method encode(%*quarters) {
    my $*quarter-context;
    my $result = buf8.new;

    $*quarter-context = 'stand-alone';
    $result ~= CLDR-QuarterContext.encode: (%*quarters<stand-alone> // Hash);
    $*quarter-context = 'format';
    $result ~= CLDR-QuarterContext.encode: (%*quarters<format>      // Hash);

    $result;
}
method parse(\base, \xml) {
    use Intl::CLDR::Util::XML-Helper;
    CLDR-QuarterContext.parse: (base{.<type>} //= Hash.new), $_ for xml.&elems('quarterContext');
}

#>>>>> # GENERATOR
