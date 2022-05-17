#| A class implementing CLDR's <listPatterns> element, containing information about creating lists.
unit class CLDR::ListPatterns;
    use Intl::CLDR::Core;
    also does CLDR::Item;

use Intl::CLDR::Types::ListPattern;

# See https://www.unicode.org/reports/tr35/tr35-general.html#Layout_Elements for information
has CLDR::ListPattern $.and;    #= Pattern to list elements in an 'and' manner
has CLDR::ListPattern $.or;     #= Pattern to list elements in an 'or' manner
has CLDR::ListPattern $.unit;   #= Pattern to list elements in a neutral manner

#| Creates a new CLDR-Dates object
method new(\blob, uint64 $offset is rw --> ::?CLASS) {
    use Intl::CLDR::Util::StrDecode;
    self.bless:
        and  => CLDR::ListPattern.new(blob, $offset),
        or   => CLDR::ListPattern.new(blob, $offset),
        unit => CLDR::ListPattern.new(blob, $offset),

}

##`<<<<< # GENERATOR: This method should only be uncommented out by the parsing script
method encode(%*list-patterns) {
    my $result = buf8.new;
    $result ~= CLDR::ListPattern.encode('standard'); # read as 'and'
    $result ~= CLDR::ListPattern.encode('or');
    $result ~= CLDR::ListPattern.encode('unit');
    $result;
}
method parse(\base, \xml) {
    use Intl::CLDR::Util::XML-Helper;
    CLDR::ListPattern.parse: (base{.<type> // 'standard'} //= Hash.new), $_ for xml.&elems('listPattern');
}
#>>>>> # GENERATOR