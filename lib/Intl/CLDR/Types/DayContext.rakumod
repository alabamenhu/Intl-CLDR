unit class CLDR::DayContext;
    use Intl::CLDR::Core;
    also does CLDR::Item;

use Intl::CLDR::Types::DayWidth;

has CLDR::DayWidth $.narrow;
has CLDR::DayWidth $.abbreviated;
has CLDR::DayWidth $.wide;

#| Creates a new CLDR-DayContext object
method new(\blob, uint64 $offset is rw) {
    self.bless:
        narrow      => CLDR::DayWidth.new(blob, $offset),
        abbreviated => CLDR::DayWidth.new(blob, $offset),
        wide        => CLDR::DayWidth.new(blob, $offset),
}

#`<<<<<# GENERATOR: Use toggle-generators.raku to [dis|en]able this code.
method encode(\hash) {
    my $*day-width;
    my $result = buf8.new;

    $*day-width = 'narrow';
    $result ~= CLDR::DayWidth.encode: %*day-context<narrow> // Hash;
    $*day-width = 'abbreviated';
    $result ~= CLDR::DayWidth.encode: %*day-context<abbreviated> // Hash;
    $*day-width = 'wide';
    $result ~= CLDR::DayWidth.encode: %*day-context<wide> // Hash;

    $result;
}
method parse(\base, \xml) {
    use Intl::CLDR::Util::XML-Helper;
    CLDR::DayWidth.parse: (base{.<type>} //= Hash.new), $_ for xml.&elems('dayWidth');
}
>>>>># GENERATOR