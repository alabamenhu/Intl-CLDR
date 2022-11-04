unit class CLDR::QuarterContext;
    use Intl::CLDR::Core;
    also does CLDR::Item;

use Intl::CLDR::Types::QuarterWidth;

has CLDR::QuarterWidth $.narrow;
has CLDR::QuarterWidth $.abbreviated;
has CLDR::QuarterWidth $.wide;

#| Creates a new CLDR-QuarterContext object
method new(\blob, uint64 $offset is rw --> ::?CLASS) {
    self.bless:
        narrow      => CLDR::QuarterWidth.new(blob, $offset),
        abbreviated => CLDR::QuarterWidth.new(blob, $offset),
        wide        => CLDR::QuarterWidth.new(blob, $offset),
}

#`<<<<<# GENERATOR: Use toggle-generators.raku to [dis|en]able this code.
method encode(\hash) {
    my $*quarter-width;
    my $result = buf8.new;

    $*quarter-width = 'narrow';
    $result ~= CLDR::QuarterWidth.encode: %*quarter-context<narrow>      // Hash;
    $*quarter-width = 'abbreviated';
    $result ~= CLDR::QuarterWidth.encode: %*quarter-context<abbreviated> // Hash;
    $*quarter-width = 'wide';
    $result ~= CLDR::QuarterWidth.encode: %*quarter-context<wide>        // Hash;

    $result;
}
method parse(\base, \xml) {
    use Intl::CLDR::Util::XML-Helper;
    CLDR::QuarterWidth.parse: (base{.<type>} //= Hash.new), $_ for xml.&elems('quarterWidth');
}

>>>>># GENERATOR