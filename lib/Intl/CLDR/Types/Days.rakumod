use Intl::CLDR::Immutability;

unit class CLDR-Days is CLDR-ItemNew;

use Intl::CLDR::Types::DayContext;

has $!parent;
has CLDR-DayContext $.stand-alone;
has CLDR-DayContext $.format;

#| Creates a new CLDR-Dates object
method new(|c) {
    self.bless!bind-init: |c;
}

submethod !bind-init(\blob, uint64 $offset is rw, \parent) {
    $!parent := parent;

    $!stand-alone = CLDR-DayContext.new: blob, $offset, self;
    $!format      = CLDR-DayContext.new: blob, $offset, self;

    self
}

constant detour = Map.new: (
    standAlone => 'stand-alone'
);
method DETOUR (--> detour) {;}
##`<<<<< # GENERATOR: This method should only be uncommented out by the parsing script
method encode(\hash) {
    my $*day-context;
    my $result = buf8.new;

    $*day-context = 'stand-alone';
    $result ~= CLDR-DayContext.encode: (%*days<stand-alone> // Hash);
    $*day-context = 'format';
    $result ~= CLDR-DayContext.encode: (%*days<format>      // Hash);

    $result;
}
method parse(\base, \xml) {
    use Intl::CLDR::Util::XML-Helper;
    CLDR-DayContext.parse: (base{.<type>} //= Hash.new), $_ for xml.&elems('dayContext');
}
#>>>>> # GENERATOR
