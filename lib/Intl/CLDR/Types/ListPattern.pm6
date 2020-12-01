use Intl::CLDR::Immutability;

#| A class implementing CLDR's <listPatterns> element, containing information about creating lists.
unit class CLDR-ListPattern is CLDR-Item;


use Intl::CLDR::Types::ListPatternWidth;

# See https://www.unicode.org/reports/tr35/tr35-general.html#Layout_Elements for information

has                      $!parent;    #= The CLDR-ListPatterns object containing this CLDR-ListPattern
has CLDR-ListPatternWidth $.standard; #= The most common representation for the list pattern
has CLDR-ListPatternWidth $.short;    #= A shorter way of representing the list pattern
has CLDR-ListPatternWidth $.narrow;   #= The shortest way of representing the list pattern

#| Creates a new CLDR-Dates object
method new(|c) {
    self.bless!bind-init: |c;
}

submethod !bind-init(\blob, uint64 $offset is rw, \parent = "foo") {
    use Intl::CLDR::Util::StrDecode;
    self.Hash::BIND-KEY: 'normal', $!standard;
    self.Hash::BIND-KEY: 'short',  $!short;
    self.Hash::BIND-KEY: 'narrow', $!narrow;

    $!parent := parent;

    $!standard = CLDR-ListPatternWidth.new: blob, $offset, self;
    $!short    = CLDR-ListPatternWidth.new: blob, $offset, self;
    $!narrow   = CLDR-ListPatternWidth.new: blob, $offset, self;
    self
}

##`<<<<< # GENERATOR: This method should only be uncommented out by the parsing script
method encode($*list-pattern-type) {
    my $result = buf8.new;
    $result ~= CLDR-ListPatternWidth.encode('standard');
    $result ~= CLDR-ListPatternWidth.encode('short');
    $result ~= CLDR-ListPatternWidth.encode('narrow');
    $result;
}
method parse(\base, \xml) {
    use Intl::CLDR::Util::XML-Helper;
    # pass through, because this is an intermediate representation handled during encoding
    CLDR-ListPatternWidth.parse: base, xml;
}
#>>>>> # GENERATOR