#| A class implementing CLDR's <field> element
unit class CLDR::Field;
    use Intl::CLDR::Core;
    also does CLDR::Item;

use Intl::CLDR::Types::FieldWidth;

has CLDR::FieldWidth $.standard;
has CLDR::FieldWidth $.short;
has CLDR::FieldWidth $.narrow;

#| Creates a new CLDR-Dates object
method new(\blob, uint64 $offset is rw --> ::?CLASS) {
    self.bless:
        standard => CLDR::FieldWidth.new(blob, $offset),
        short    => CLDR::FieldWidth.new(blob, $offset),
        narrow   => CLDR::FieldWidth.new(blob, $offset),

}

#`<<<<<# GENERATOR: Use toggle-generators.raku to [dis|en]able this code.
method encode(%*field) {
    my $result = buf8.new;

    my $*field-width;

    $*field-width = 'standard';
    $result ~= CLDR::FieldWidth.encode(%*field<standard> // Hash);
    $*field-width = 'short';
    $result ~= CLDR::FieldWidth.encode(%*field<short> // Hash);
    $*field-width = 'narrow';
    $result ~= CLDR::FieldWidth.encode(%*field<narrow> // Hash);

    $result
}
method parse(\base, @ (\standard,\short,\narrow) ) {
    #  This technically handles three at once, but are merged here.
    use Intl::CLDR::Util::XML-Helper;
    with standard { CLDR::FieldWidth.parse: (base<standard> //= Hash.new), standard }
    with short    { CLDR::FieldWidth.parse: (base<short>    //= Hash.new), short    }
    with narrow   { CLDR::FieldWidth.parse: (base<narrow>   //= Hash.new), narrow   }
}
>>>>># GENERATOR