unit class CLDR::MonthContext;
    use Intl::CLDR::Core;
    also does CLDR::Item;

use Intl::CLDR::Types::MonthWidth;

has CLDR::MonthWidth $.narrow;
has CLDR::MonthWidth $.abbreviated;
has CLDR::MonthWidth $.wide;

#| Creates a new CLDR::MonthContext object
method new(\blob, uint64 $offset is rw --> ::?CLASS) {
    self.bless:
        narrow      => CLDR::MonthWidth.new(blob, $offset),
        abbreviated => CLDR::MonthWidth.new(blob, $offset),
        wide        => CLDR::MonthWidth.new(blob, $offset),
}

#`<<<<<# GENERATOR: Use toggle-generators.raku to [dis|en]able this code.
method encode(%*month-context) {
    my $*month-width;
    my $result = buf8.new;

    $*month-width = 'narrow';
    $result ~= CLDR::MonthWidth.encode: %*month-context<narrow> // Hash;
    $*month-width = 'abbreviated';
    $result ~= CLDR::MonthWidth.encode: %*month-context<abbreviated> // Hash;
    $*month-width = 'wide';
    $result ~= CLDR::MonthWidth.encode: %*month-context<wide> // Hash;

    $result;
}
method parse(\base, \xml) {
    use Intl::CLDR::Util::XML-Helper;
    CLDR::MonthWidth.parse: (base{.<type>} //= Hash.new), $_ for xml.&elems('monthWidth');
}
>>>>># GENERATOR