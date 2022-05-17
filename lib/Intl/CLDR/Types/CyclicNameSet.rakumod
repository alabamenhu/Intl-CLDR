unit class CLDR::CyclicNameSet;
    use Intl::CLDR::Core;
    also does CLDR::Item;

use Intl::CLDR::Types::CyclicNameContext;

has CLDR::CyclicNameContext $.stand-alone is aliased-by<standAlone>;
has CLDR::CyclicNameContext $.format;

#| Creates a new CLDR-Dates object
method new(\blob, uint64 $offset is rw) {
    self.bless:
        stand-alone => CLDR::CyclicNameContext.new(blob, $offset),
        format      => CLDR::CyclicNameContext.new(blob, $offset),
}

#`<<<<<# GENERATOR: Use toggle-generators.raku to [dis|en]able this code.
method encode(%*cyclic-name-context) {
    my $result = buf8.new;

    my $*cyclic-name-context;

    $*cyclic-name-context = 'stand-alone';
    $result ~= CLDR::CyclicNameContext.encode: %*cyclic-name-context<stand-alone> // Hash;
    $*cyclic-name-context = 'format';
    $result ~= CLDR::CyclicNameContext.encode: %*cyclic-name-context<sformat> // Hash;

    $result
}
method parse(\base, \xml) {
    use Intl::CLDR::Util::XML-Helper;
    CLDR::CyclicNameContext.parse: (base{.<type>} //= Hash.new), $_ for xml.&elems('cyclicNameContext');
}
>>>>># GENERATOR