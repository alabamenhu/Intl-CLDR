unit class CLDR::CyclicNameContext;
    use Intl::CLDR::Core;
    also does CLDR::Item;

use Intl::CLDR::Types::CyclicNameWidth;

has CLDR::CyclicNameWidth $.narrow;
has CLDR::CyclicNameWidth $.abbreviated;
has CLDR::CyclicNameWidth $.wide;

#| Creates a new CLDR::CyclicNameContext object
method new(\blob, uint64 $offset is rw) {
    self.bless:
        narrow      => CLDR::CyclicNameWidth.new(blob, $offset),
        abbreviated => CLDR::CyclicNameWidth.new(blob, $offset),
        wide        => CLDR::CyclicNameWidth.new(blob, $offset),
}

##`<<<<< # GENERATOR: This method should only be uncommented out by the parsing script
method encode(%*cyclic-name-width) {
    my $result = buf8.new;

    my $*cyclic-name-width;

    $*cyclic-name-width = 'narrow';
    $result ~= CLDR::CyclicNameWidth.encode: %*cyclic-name-width<narrow> // Hash;
    $*cyclic-name-width = 'abbreviated';
    $result ~= CLDR::CyclicNameWidth.encode: %*cyclic-name-width<abbreviated> // Hash;
    $*cyclic-name-width = 'format';
    $result ~= CLDR::CyclicNameWidth.encode: %*cyclic-name-width<format> // Hash;

    $result
}
method parse(\base, \xml) {
    use Intl::CLDR::Util::XML-Helper;
    CLDR::CyclicNameWidth.parse: (base{.<type>} //= Hash.new), $_ for xml.&elems('cyclicNameWidth');
}
#>>>>> # GENERATOR
