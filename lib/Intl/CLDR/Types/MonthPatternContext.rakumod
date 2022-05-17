unit class CLDR::MonthPatternContext;
    use Intl::CLDR::Core;
    also does CLDR::Item;

use Intl::CLDR::Types::MonthPatternWidth;

has CLDR::MonthPatternWidth $.narrow;
has CLDR::MonthPatternWidth $.abbreviated;
has CLDR::MonthPatternWidth $.wide;
has CLDR::MonthPatternWidth $.all;

#| Creates a new CLDR-MonthContext object
method new(\blob, uint64 $offset is rw --> ::?CLASS) {
    self.bless:
        narrow      => CLDR::MonthPatternWidth.new(blob, $offset),
        abbreviated => CLDR::MonthPatternWidth.new(blob, $offset),
        wide        => CLDR::MonthPatternWidth.new(blob, $offset),
        all         => CLDR::MonthPatternWidth.new(blob, $offset),
}

##`<<<<< # GENERATOR: This method should only be uncommented out by the parsing script
method encode(%*month-pattern-contexts) {
    my $*month-pattern-width;
    my $result = buf8.new;

    $*month-pattern-width = 'narrow';
    $result ~= CLDR::MonthPatternWidth.encode: %*month-pattern-context<narrow>      // Hash;
    $*month-pattern-width = 'abbreviated';
    $result ~= CLDR::MonthPatternWidth.encode: %*month-pattern-context<abbreviated> // Hash;
    $*month-pattern-width = 'wide';
    $result ~= CLDR::MonthPatternWidth.encode: %*month-pattern-context<wide>        // Hash;
    $*month-pattern-width = 'all';
    $result ~= CLDR::MonthPatternWidth.encode: %*month-pattern-context<all>         // Hash;

    $result;
}
method parse(\base, \xml) {
    use Intl::CLDR::Util::XML-Helper;
    CLDR::MonthPatternWidth.parse: (base{.<type>} //= Hash.new), $_ for xml.&elems('monthWidth');
}

#>>>>> # GENERATOR
