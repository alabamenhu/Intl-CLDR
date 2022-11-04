unit class CLDR::MonthPatterns;
    use Intl::CLDR::Core;
    also does CLDR::Item;

use Intl::CLDR::Types::MonthPatternContext;

has CLDR::MonthPatternContext $.stand-alone is aliased-by<standAlone>;
has CLDR::MonthPatternContext $.format;
has CLDR::MonthPatternContext $.numeric;

#| Creates a new CLDR-Dates object
method new(\blob, uint64 $offset is rw --> ::?CLASS) {
    self.bless:
        stand-alone => CLDR::MonthPatternContext.new(blob, $offset),
        format      => CLDR::MonthPatternContext.new(blob, $offset),
        numeric     => CLDR::MonthPatternContext.new(blob, $offset),
}

#`<<<<<# GENERATOR: Use toggle-generators.raku to [dis|en]able this code.
method encode(%*month-patterns) {

    my $*month-pattern-context;
    my $result = buf8.new;

    $*month-pattern-context = 'stand-alone';
    $result ~= CLDR::MonthPatternContext.encode: (%*months-patterns<stand-alone> // Hash);
    $*month-pattern-context = 'format';
    $result ~= CLDR::MonthPatternContext.encode: (%*months-patterns<format>      // Hash);
    $*month-pattern-context = 'numeric';
    $result ~= CLDR::MonthPatternContext.encode: (%*months-patterns<numeric>     // Hash);

    $result;
}
method parse(\base, \xml) {
    use Intl::CLDR::Util::XML-Helper;
    CLDR::MonthPatternContext.parse: (base{.<type>} //= Hash.new), $_ for xml.&elems('monthContext');
}

>>>>># GENERATOR