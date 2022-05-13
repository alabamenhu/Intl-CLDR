use Intl::CLDR::Immutability;

#| A class implementing CLDR's <layout> element, containing information about text direction.
unit class CLDR-Layout is CLDR-ItemNew;


use Intl::CLDR::Types::Orientation;

# See https://www.unicode.org/reports/tr35/tr35-general.html#Layout_Elements for information

has                  $!parent;      #= The CLDR-Base object containing this CLDR-Layout
has CLDR-Orientation $.orientation; #= Information about document orientation and text flow

#| Creates a new CLDR-Dates object
method new(|c) {
    self.bless!bind-init: |c;
}

submethod !bind-init(\blob, uint64 $offset is rw) {
    use Intl::CLDR::Util::StrDecode;

    $!orientation = CLDR-Orientation.new: blob, $offset;
    self
}

##`<<<<< # GENERATOR: This method should only be uncommented out by the parsing script
method encode(%layout) {
    my $result = buf8.new;
    $result ~= CLDR-Orientation.encode(%layout<orientation> // Hash);
    $result
}
method parse(\base, \xml) {
    use Intl::CLDR::Util::XML-Helper;
    CLDR-Orientation.parse: (base<orientation> //= Hash.new), $_ with xml.&elem('orientation');
}
#>>>>> # GENERATOR
