#| A class implementing CLDR's <listPatterns> element, containing information about creating lists.
unit class CLDR::ListPattern;
    use Intl::CLDR::Core;
    also does CLDR::Item;

use Intl::CLDR::Types::ListPatternWidth;

# See https://www.unicode.org/reports/tr35/tr35-general.html#Layout_Elements for information
has CLDR::ListPatternWidth $.standard; #= The most common representation for the list pattern
has CLDR::ListPatternWidth $.short;    #= A shorter way of representing the list pattern
has CLDR::ListPatternWidth $.narrow;   #= The shortest way of representing the list pattern

#| Creates a new CLDR-Dates object
method new(\blob, uint64 $offset is rw --> ::?CLASS) {
    use Intl::CLDR::Util::StrDecode;
    self.bless:
        standard => CLDR::ListPatternWidth.new(blob, $offset),
        short    => CLDR::ListPatternWidth.new(blob, $offset),
        narrow   => CLDR::ListPatternWidth.new(blob, $offset),
}

##`<<<<< # GENERATOR: This method should only be uncommented out by the parsing script
method encode($*list-pattern-type) {
    my $result = buf8.new;
    $result ~= CLDR::ListPatternWidth.encode('standard');
    $result ~= CLDR::ListPatternWidth.encode('short');
    $result ~= CLDR::ListPatternWidth.encode('narrow');
    $result;
}
method parse(\base, \xml) {
    use Intl::CLDR::Util::XML-Helper;
    # pass through, because this is an intermediate representation handled during encoding
    CLDR::ListPatternWidth.parse: base, xml;
}
#>>>>> # GENERATOR