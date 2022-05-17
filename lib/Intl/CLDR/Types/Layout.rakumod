#| A class implementing CLDR's <layout> element, containing information about text direction.
unit class CLDR::Layout;
    use Intl::CLDR::Core;
    also does CLDR::Item;

use Intl::CLDR::Types::Orientation;

# See https://www.unicode.org/reports/tr35/tr35-general.html#Layout_Elements for information
has CLDR::Orientation $.orientation; #= Information about document orientation and text flow

#| Creates a new CLDR-Dates object
method new(\blob, uint64 $offset is rw --> ::?CLASS) {
    use Intl::CLDR::Util::StrDecode;

    self.bless:
        $!orientation = CLDR::Orientation.new(blob, $offset)
}

##`<<<<< # GENERATOR: This method should only be uncommented out by the parsing script
method encode(%layout) {
    my $result = buf8.new;
    $result ~= CLDR::Orientation.encode(%layout<orientation> // Hash);
    $result
}
method parse(\base, \xml) {
    use Intl::CLDR::Util::XML-Helper;
    CLDR::Orientation.parse: (base<orientation> //= Hash.new), $_ with xml.&elem('orientation');
}
#>>>>> # GENERATOR
