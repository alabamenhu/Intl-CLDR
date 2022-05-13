use Intl::CLDR::Immutability;

unit class CLDR-QuarterContext is CLDR-ItemNew;

use Intl::CLDR::Types::QuarterWidth;

has                   $!parent;
has CLDR-QuarterWidth $.narrow;
has CLDR-QuarterWidth $.abbreviated;
has CLDR-QuarterWidth $.wide;

#| Creates a new CLDR-QuarterContext object
method new(|c) {
    self.bless!bind-init: |c;
}

submethod !bind-init(\blob, uint64 $offset is rw, \parent) {
    $!parent := parent;

    $!narrow      = CLDR-QuarterWidth.new: blob, $offset, self;
    $!abbreviated = CLDR-QuarterWidth.new: blob, $offset, self;
    $!wide        = CLDR-QuarterWidth.new: blob, $offset, self;

    self
}

##`<<<<< # GENERATOR: This method should only be uncommented out by the parsing script
method encode(\hash) {
    my $*quarter-width;
    my $result = buf8.new;

    $*quarter-width = 'narrow';
    $result ~= CLDR-QuarterWidth.encode: %*quarter-context<narrow>      // Hash;
    $*quarter-width = 'abbreviated';
    $result ~= CLDR-QuarterWidth.encode: %*quarter-context<abbreviated> // Hash;
    $*quarter-width = 'wide';
    $result ~= CLDR-QuarterWidth.encode: %*quarter-context<wide>        // Hash;

    $result;
}
method parse(\base, \xml) {
    use Intl::CLDR::Util::XML-Helper;
    CLDR-QuarterWidth.parse: (base{.<type>} //= Hash.new), $_ for xml.&elems('quarterWidth');
}

#>>>>> # GENERATOR
