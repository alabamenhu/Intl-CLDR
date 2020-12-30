use Intl::CLDR::Immutability;

#| A class implementing CLDR's <orientation> element, containing information about text and document flow.
unit class CLDR-Orientation is CLDR-ItemNew;


has     $!parent;          #= The CLDR-Base object containing this CLDR-Delimiter
has Str $.line-order;      #= The direction of text flow from one line to another
has Str $.character-order; #= The direction of text flow from one letter to another

#| Creates a new CLDR-Dates object
method new(|c) {
    self.bless!bind-init: |c;
}

submethod !bind-init(\blob, uint64 $offset is rw) {
    use Intl::CLDR::Util::StrDecode;

    $!line-order = StrDecode::get(blob, $offset);
    $!character-order = StrDecode::get(blob, $offset);

    self
}

constant detour = Map.new: (
    lineOrder => 'line-order',
    characterOrder => 'characterOrder'
);
method DETOUR (-->detour) {;}
##`<<<<< # GENERATOR: This method should only be uncommented out by the parsing script
method encode(%orientation) {
    my $result = buf8.new;

    use Intl::CLDR::Util::StrEncode;

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
