#| A class implementing CLDR's <regionFormat> element, containing information about formatting dates.
unit class CLDR::RegionFormat;
    use Intl::CLDR::Core;
    also does CLDR::Item;

has Str $.generic;
has Str $.standard;
has Str $.daylight;

#| Creates a new CLDR-Dates object
method new(\blob, uint64 $offset is rw --> ::?CLASS) {
    use Intl::CLDR::Util::StrDecode;
    self.bless:
        generic  => StrDecode::get( blob, $offset),
        standard => StrDecode::get( blob, $offset),
        daylight => StrDecode::get( blob, $offset),

}

#`<<<<<# GENERATOR: Use toggle-generators.raku to [dis|en]able this code.
method encode(%*region-format) {
    use Intl::CLDR::Util::StrEncode;

    my $result = buf8.new;

    $result ~= StrEncode::get(%*region-format<generic>  // '');
    $result ~= StrEncode::get(%*region-format<standard> // '');
    $result ~= StrEncode::get(%*region-format<daylight> // '');

    $result
}
method parse(\base, \xml) {
    # handled at a different level
}
>>>>># GENERATOR