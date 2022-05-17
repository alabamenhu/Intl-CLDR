#| A class implementing CLDR's <zoneWidth> element, containing information about formatting dates.
unit class CLDR::ZoneWidth;
    use Intl::CLDR::Core;
    also does CLDR::Item;

has Str $.generic;
has Str $.standard;
has Str $.daylight;

#| Creates a new CLDR-Dates object
method new(\blob, uint64 $offset is rw --> ::?CLASS) {
    use Intl::CLDR::Util::StrDecode;
    self.bless:
        generic  => StrDecode::get(blob, $offset),
        standard => StrDecode::get(blob, $offset),
        daylight => StrDecode::get(blob, $offset),
}

#`<<<<<# GENERATOR: Use toggle-generators.raku to [dis|en]able this code.
method encode(%*zone-width) {
    use Intl::CLDR::Util::StrEncode;

    my $result = buf8.new;

    $result ~= StrEncode::get(%*zone-width<generic>  // '');
    $result ~= StrEncode::get(%*zone-width<standard> // '');
    $result ~= StrEncode::get(%*zone-width<daylight> // '');

    $result
}
method parse(\base, \xml) {
    use Intl::CLDR::Util::XML-Helper;
    with xml.&elem('generic' ) { base<generic>  = contents $_ }
    with xml.&elem('standard') { base<standard> = contents $_ }
    with xml.&elem('daylight') { base<daylight> = contents $_ }
}
>>>>># GENERATOR