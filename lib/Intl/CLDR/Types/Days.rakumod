unit class CLDR::Days;
    use Intl::CLDR::Core;
    also does CLDR::Item;

use Intl::CLDR::Types::DayContext;

has CLDR::DayContext $.stand-alone is aliased-by<standAlone>;
has CLDR::DayContext $.format;

#| Creates a new CLDR-Dates object
method new(\blob, uint64 $offset is rw --> ::?CLASS) {
    self.bless:
        stand-alone => CLDR::DayContext.new(blob, $offset),
        format      => CLDR::DayContext.new(blob, $offset),
}

#`<<<<<# GENERATOR: Use toggle-generators.raku to [dis|en]able this code.
method encode(\hash) {
    my $*day-context;
    my $result = buf8.new;

    $*day-context = 'stand-alone';
    $result ~= CLDR::DayContext.encode: (%*days<stand-alone> // Hash);
    $*day-context = 'format';
    $result ~= CLDR::DayContext.encode: (%*days<format>      // Hash);

    $result;
}
method parse(\base, \xml) {
    use Intl::CLDR::Util::XML-Helper;
    CLDR::DayContext.parse: (base{.<type>} //= Hash.new), $_ for xml.&elems('dayContext');
}
>>>>># GENERATOR