use Intl::CLDR::Immutability;

#| A class implementing CLDR's <orientation> element, containing information about text and document flow.
unit class CLDR-Orientation is CLDR-Item;


has     $!parent;          #= The CLDR-Base object containing this CLDR-Delimiter
has Str $.line-order;      #= The direction of text flow from one line to another
has Str $.character-order; #= The direction of text flow from one letter to another

#| Creates a new CLDR-Dates object
method new(|c) {
    self.bless!bind-init: |c;
}

submethod !bind-init(\blob, uint64 $offset is rw, \parent = "foo") {
    $!parent := parent;

    self.Hash::BIND-KEY: 'line-order',   $!line-order;
    self.Hash::BIND-KEY: 'lineOrder',   $!line-order;
    self.Hash::BIND-KEY: 'character-order', $!character-order;
    self.Hash::BIND-KEY: 'characterOrder', $!character-order;

    use Intl::CLDR::Classes::StrDecode;

    $!line-order = StrDecode::get(blob, $offset);
    $!character-order = StrDecode::get(blob, $offset);

    self
}

##`<<<<< # GENERATOR: This method should only be uncommented out by the parsing script
method encode(%orientation) {
    my $result = buf8.new;

    use Intl::CLDR::Classes::StrEncode;

    $result ~= StrEncode::get(%orientation<lineOrder>   // '');
    $result ~= StrEncode::get(%orientation<characterOrder> // '');

    $result
}
method parse(\base, \xml) {
    use Intl::CLDR::Util::XML-Helper;
    base<lineOrder>      = contents $_ with xml.&elem('lineOrder');
    base<characterOrder> = contents $_ with xml.&elem('characterOrder');
}
#>>>>> # GENERATOR
