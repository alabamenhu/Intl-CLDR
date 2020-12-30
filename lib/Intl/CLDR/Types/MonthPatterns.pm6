use Intl::CLDR::Immutability;

unit class CLDR-MonthPatterns is CLDR-ItemNew;

use Intl::CLDR::Types::MonthPatternContext;

has $!parent;
has CLDR-MonthPatternContext $.stand-alone;
has CLDR-MonthPatternContext $.format;
has CLDR-MonthPatternContext $.numeric;

#| Creates a new CLDR-Dates object
method new(|c) {
    self.bless!bind-init: |c;
}

submethod !bind-init(\blob, uint64 $offset is rw, \parent) {
    $!parent := parent;

    $!stand-alone = CLDR-MonthPatternContext.new: blob, $offset, self;
    $!format      = CLDR-MonthPatternContext.new: blob, $offset, self;
    $!numeric     = CLDR-MonthPatternContext.new: blob, $offset, self;
    self
}
constant detour = Map.new: (
    standAlone => 'stand-alone'
);
method DETOUR (-->detour) {;}

##`<<<<<#GENERATOR: This method should only be uncommented out by the parsing script
method encode(%*month-patterns) {

    my $*month-pattern-context;
    my $result = buf8.new;

    $*month-pattern-context = 'stand-alone';
    $result ~= CLDR-MonthPatternContext.encode: (%*months-patterns<stand-alone> // Hash);
    $*month-pattern-context = 'format';
    $result ~= CLDR-MonthPatternContext.encode: (%*months-patterns<format>      // Hash);
    $*month-pattern-context = 'numeric';
    $result ~= CLDR-MonthPatternContext.encode: (%*months-patterns<numeric>     // Hash);

    $result;
}
method parse(\base, \xml) {
    use Intl::CLDR::Util::XML-Helper;
    CLDR-MonthPatternContext.parse: (base{.<type>} //= Hash.new), $_ for xml.&elems('monthContext');
}

#>>>>>#GENERATOR
