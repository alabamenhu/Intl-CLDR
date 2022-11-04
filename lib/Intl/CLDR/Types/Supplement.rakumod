unit class CLDR::Supplement;
    use Intl::CLDR::Core;
    also does CLDR::Item;

use Intl::CLDR::Types::Subdivisions;
use Intl::CLDR::Types::TimezoneMaps;

has CLDR::Subdivisions $.subdivisions;
has CLDR::TimezoneMaps $.timezones;

#| Creates a new CLDR-Supplement object
method new(\blob, uint64 $offset is rw --> ::?CLASS) {
    self.bless:
        subdivisions => CLDR::Subdivisions.new(blob, $offset),
        timezones => CLDR::TimezoneMaps.new(blob, $offset)
}


#`<<<<<# GENERATOR: Use toggle-generators.raku to [dis|en]able this code.
method encode(%supplement --> buf8) {
    use Intl::CLDR::Util::StrEncode;
    my $result = buf8.new;

    $result ~= CLDR::Subdivisions.encode: %supplement<subdivisions>;
    $result ~= CLDR::TimezoneMaps.encode: %supplement<timezones>;

    $result
}
method parse(\base, \xml --> Nil) {
    CLDR::Subdivisions.parse: (base<subdivisions> //= Hash.new), $_ with $*subdivisions-xml;
    CLDR::TimezoneMaps.parse: (base<timezones>    //= Hash.new), $_; # need to "pass" both, so we'll capture dynamic later
}
>>>>># GENERATOR