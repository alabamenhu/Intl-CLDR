unit class CLDR::Months;
    use Intl::CLDR::Core;
    also does CLDR::Item;

use Intl::CLDR::Types::MonthContext;

has CLDR::MonthContext $.stand-alone is aliased-by<standAlone>;
has CLDR::MonthContext $.format;

#| Creates a new CLDR::Months object
method new(\blob, uint64 $offset is rw --> ::?CLASS) {
    self.bless:
        stand-alone => CLDR::MonthContext.new(blob, $offset),
        format      => CLDR::MonthContext.new(blob, $offset),
}

##`<<<<< # GENERATOR: This method should only be uncommented out by the parsing script
method encode(%*months) {
    my $*month-context;
    my $result = buf8.new;

    $*month-context = 'stand-alone';
    $result ~= CLDR::MonthContext.encode: (%*months<stand-alone> // Hash);
    $*month-context = 'format';
    $result ~= CLDR::MonthContext.encode: (%*months<format> // Hash);

    $result;
}
method parse(\base, \xml) {
    use Intl::CLDR::Util::XML-Helper;
    CLDR::MonthContext.parse: (base{.<type>} //= Hash.new), $_ for xml.&elems('monthContext');
}
#>>>>> # GENERATOR
