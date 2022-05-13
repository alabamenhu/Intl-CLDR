use Intl::CLDR::Immutability;

unit class CLDR-MonthContext is CLDR-ItemNew;

use Intl::CLDR::Types::MonthWidth;

has                 $!parent;
has CLDR-MonthWidth $.narrow;
has CLDR-MonthWidth $.abbreviated;
has CLDR-MonthWidth $.wide;

#| Creates a new CLDR-MonthContext object
method new(|c) {
    self.bless!bind-init: |c;
}

submethod !bind-init(\blob, uint64 $offset is rw, \parent) {
    $!parent := parent;

    $!narrow      = CLDR-MonthWidth.new: blob, $offset, self;
    $!abbreviated = CLDR-MonthWidth.new: blob, $offset, self;
    $!wide        = CLDR-MonthWidth.new: blob, $offset, self;

    self
}

##`<<<<< # GENERATOR: This method should only be uncommented out by the parsing script

method encode(%*month-context) {
    my $*month-width;
    my $result = buf8.new;

    $*month-width = 'narrow';
    $result ~= CLDR-MonthWidth.encode: %*month-context<narrow> // Hash;
    $*month-width = 'abbreviated';
    $result ~= CLDR-MonthWidth.encode: %*month-context<abbreviated> // Hash;
    $*month-width = 'wide';
    $result ~= CLDR-MonthWidth.encode: %*month-context<wide> // Hash;

    $result;
}
method parse(\base, \xml) {
    use Intl::CLDR::Util::XML-Helper;
    CLDR-MonthWidth.parse: (base{.<type>} //= Hash.new), $_ for xml.&elems('monthWidth');
}
#>>>>> # GENERATOR
