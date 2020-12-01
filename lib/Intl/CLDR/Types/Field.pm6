use Intl::CLDR::Immutability;

use Intl::CLDR::Types::FieldWidth;

#| A class implementing CLDR's <dates> element, containing information about formatting dates.
unit class CLDR-Field is CLDR-Item;


has                 $!parent;         #= The CLDR-Dates object containing this CLDR-Fields
has CLDR-FieldWidth $.standard;
has CLDR-FieldWidth $.short;
has CLDR-FieldWidth $.narrow;

#| Creates a new CLDR-Dates object
method new(|c) {
    self.bless!bind-init: |c;
}

submethod !bind-init(\blob, uint64 $offset is rw, \parent) {
    $!parent := parent;

    self.Hash::BIND-KEY: 'standard', $!standard;
    self.Hash::BIND-KEY: 'short',    $!short;
    self.Hash::BIND-KEY: 'narrow',   $!narrow;

    $!standard = CLDR-FieldWidth.new: blob, $offset, self;
    $!short    = CLDR-FieldWidth.new: blob, $offset, self;
    $!narrow   = CLDR-FieldWidth.new: blob, $offset, self;

    self
}

##`<<<<< # GENERATOR: This method should only be uncommented out by the parsing script
method encode(%*field) {
    my $result = buf8.new;

    my $*field-width;

    $*field-width = 'standard';
    $result ~= CLDR-FieldWidth.encode(%*field<standard> // Hash);
    $*field-width = 'short';
    $result ~= CLDR-FieldWidth.encode(%*field<short> // Hash);
    $*field-width = 'narrow';
    $result ~= CLDR-FieldWidth.encode(%*field<narrow> // Hash);

    $result
}
method parse(\base, @ (\standard,\short,\narrow) ) {
    #  This technically handles three at once, but are merged here.
    use Intl::CLDR::Util::XML-Helper;
    with standard { CLDR-FieldWidth.parse: (base<standard> //= Hash.new), standard }
    with short    { CLDR-FieldWidth.parse: (base<short>    //= Hash.new), short    }
    with narrow   { CLDR-FieldWidth.parse: (base<narrow>   //= Hash.new), narrow   }
}

#>>>>> # GENERATOR
