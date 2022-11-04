unit class CLDR::Quarters;
    use Intl::CLDR::Core;
    also does CLDR::Item;

use Intl::CLDR::Types::QuarterContext;

has CLDR::QuarterContext $.stand-alone is aliased-by<standAlone>;
has CLDR::QuarterContext $.format;

#| Creates a new CLDR::Quarters object
method new(\blob, uint64 $offset is rw --> ::?CLASS) {
    self.bless:
        stand-alone => CLDR::QuarterContext.new(blob, $offset),
        format      => CLDR::QuarterContext.new(blob, $offset),
}

#`<<<<<# GENERATOR: Use toggle-generators.raku to [dis|en]able this code.
method encode(%*quarters) {
    my $*quarter-context;
    my $result = buf8.new;

    $*quarter-context = 'stand-alone';
    $result ~= CLDR::QuarterContext.encode: (%*quarters<stand-alone> // Hash);
    $*quarter-context = 'format';
    $result ~= CLDR::QuarterContext.encode: (%*quarters<format>      // Hash);

    $result;
}
method parse(\base, \xml) {
    use Intl::CLDR::Util::XML-Helper;
    CLDR::QuarterContext.parse: (base{.<type>} //= Hash.new), $_ for xml.&elems('quarterContext');
}

>>>>># GENERATOR