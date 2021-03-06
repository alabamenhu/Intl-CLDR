use Intl::CLDR::Immutability;

unit class CLDR-CyclicNameContext is CLDR-ItemNew;

use Intl::CLDR::Types::CyclicNameWidth;

has                      $!parent;
has CLDR-CyclicNameWidth $.narrow;
has CLDR-CyclicNameWidth $.abbreviated;
has CLDR-CyclicNameWidth $.wide;

#| Creates a new CLDR-CyclicNameContext object
method new(|c) {
    self.bless!bind-init: |c;
}

submethod !bind-init(\blob, uint64 $offset is rw, \parent) {
    $!parent := parent;

    $!narrow      = CLDR-CyclicNameWidth.new: blob, $offset, self;
    $!abbreviated = CLDR-CyclicNameWidth.new: blob, $offset, self;
    $!wide        = CLDR-CyclicNameWidth.new: blob, $offset, self;

    self
}

##`<<<<< # GENERATOR: This method should only be uncommented out by the parsing script
method encode(%*cyclic-name-width) {
    my $result = buf8.new;

    my $*cyclic-name-width;

    $*cyclic-name-width = 'narrow';
    $result ~= CLDR-CyclicNameWidth.encode: %*cyclic-name-width<narrow> // Hash;
    $*cyclic-name-width = 'abbreviated';
    $result ~= CLDR-CyclicNameWidth.encode: %*cyclic-name-width<abbreviated> // Hash;
    $*cyclic-name-width = 'format';
    $result ~= CLDR-CyclicNameWidth.encode: %*cyclic-name-width<format> // Hash;

    $result
}
method parse(\base, \xml) {
    use Intl::CLDR::Util::XML-Helper;
    CLDR-CyclicNameWidth.parse: (base{.<type>} //= Hash.new), $_ for xml.&elems('cyclicNameWidth');
}
#>>>>> # GENERATOR
