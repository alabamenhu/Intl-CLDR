unit class CLDR::Supplement;
    use Intl::CLDR::Core;
    also does CLDR::Item;

use Intl::CLDR::Types::Subdivisions;

has CLDR::Subdivisions $.subdivisions;
#has CLDR::Timezones    $.timezones;

#| Creates a new CLDR-Supplement object
method new(\blob, uint64 $offset is rw --> ::?CLASS) {
    self.bless:
        subdivisions => CLDR::Subdivisions.new(blob, $offset)
}


#`<<<<<# GENERATOR: Use toggle-generators.raku to [dis|en]able this code.
method encode(%supplement --> buf8) {
    use Intl::CLDR::Util::StrEncode;
    my $result = buf8.new;

    $result ~= CLDR::Subdivisions.encode: %supplement<subdivisions>;

    $result
}
method parse(\base, \xml --> Nil) {
    CLDR::Subdivisions.parse: (base<supplemental> //= Hash.new), $_ with $*subdivisions-xml;
}
>>>>># GENERATOR