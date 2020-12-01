use Intl::CLDR::Immutability;

#| A class implementing CLDR's <listPatterns> element, containing information about creating lists.
unit class CLDR-ListPatterns is CLDR-Item;


use Intl::CLDR::Types::ListPattern;

# See https://www.unicode.org/reports/tr35/tr35-general.html#Layout_Elements for information

has                  $!parent; #= The CLDR-ListPatterns object containing this CLDR-ListPattern
has CLDR-ListPattern $.and;    #= Pattern to list elements in an 'and' manner
has CLDR-ListPattern $.or;     #= Pattern to list elements in an 'or' manner
has CLDR-ListPattern $.unit;   #= Pattern to list elements in a neutral manner

#| Creates a new CLDR-Dates object
method new(|c) {
    self.bless!bind-init: |c;
}

submethod !bind-init(\blob, uint64 $offset is rw, \parent = "foo") {
    use Intl::CLDR::Util::StrDecode;
    self.Hash::BIND-KEY: 'standard', $!and;
    self.Hash::BIND-KEY: 'and',      $!and;
    self.Hash::BIND-KEY: 'or',       $!or;
    self.Hash::BIND-KEY: 'unit',     $!unit;

    $!parent := parent;

    $!and  = CLDR-ListPattern.new: blob, $offset, self;
    $!or   = CLDR-ListPattern.new: blob, $offset, self;
    $!unit = CLDR-ListPattern.new: blob, $offset, self;
    self
}

##`<<<<< # GENERATOR: This method should only be uncommented out by the parsing script
method encode(%*list-patterns) {
    my $result = buf8.new;
    $result ~= CLDR-ListPattern.encode('standard'); # read as 'and'
    $result ~= CLDR-ListPattern.encode('or');
    $result ~= CLDR-ListPattern.encode('unit');
    $result;
}
method parse(\base, \xml) {
    use Intl::CLDR::Util::XML-Helper;
    CLDR-ListPattern.parse: (base{.<type> // 'standard'} //= Hash.new), $_ for xml.&elems('listPattern');
}
#>>>>> # GENERATOR