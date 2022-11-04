#| A class implementing CLDR's <orientation> element, containing information about text and document flow.
unit class CLDR::Orientation;
    use Intl::CLDR::Core;
    also does CLDR::Item;


has Str $.line-order      is aliased-by<lineOrder>;      #= The direction of text flow from one line to another
has Str $.character-order is aliased-by<characterOrder>; #= The direction of text flow from one letter to another

#| Creates a new CLDR::Orientation object
method new(\blob, uint64 $offset is rw --> ::?CLASS) {
    use Intl::CLDR::Util::StrDecode;

    self.bless:
        line-order      => StrDecode::get(blob, $offset),
        character-order => StrDecode::get(blob, $offset),
}

#`<<<<<# GENERATOR: Use toggle-generators.raku to [dis|en]able this code.
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
>>>>># GENERATOR