use Intl::CLDR::Immutability;

unit class CLDR-Months is CLDR-ItemNew;

use Intl::CLDR::Types::MonthContext;

has $!parent;
has CLDR-MonthContext $.stand-alone;
has CLDR-MonthContext $.format;

#| Creates a new CLDR-Dates object
method new(|c) {
    self.bless!bind-init: |c;
}

submethod !bind-init(\blob, uint64 $offset is rw, \parent) {
    $!parent := parent;

    $!stand-alone = CLDR-MonthContext.new: blob, $offset, self;
    $!format      = CLDR-MonthContext.new: blob, $offset, self;

    self
}

constant detour = Map.new: (
    standAlone => 'stand-alone'
);
method DETOUR (-->detour) {;}

##`<<<<< # GENERATOR: This method should only be uncommented out by the parsing script
method encode(%*months) {
    my $*month-context;
    my $result = buf8.new;

    $*month-context = 'stand-alone';
    $result ~= CLDR-MonthContext.encode: (%*months<stand-alone> // Hash);
    $*month-context = 'format';
    $result ~= CLDR-MonthContext.encode: (%*months<format> // Hash);

    $result;
}
method parse(\base, \xml) {
    use Intl::CLDR::Util::XML-Helper;
    CLDR-MonthContext.parse: (base{.<type>} //= Hash.new), $_ for xml.&elems('monthContext');
}
#>>>>> # GENERATOR
