#| A class implementing CLDR's <coordinateUnit> element,
#| separated by width.
unit class CLDR::CoordinateWidth;
    use Intl::CLDR::Core;
    also does CLDR::Item;

has Str $.display-name is built; #= Pattern for degrees due north
has Str $.north        is built; #= Pattern for degrees due north
has Str $.east         is built; #= Pattern for degrees due east
has Str $.south        is built; #= Pattern for degrees due south
has Str $.west         is built; #= Pattern for degrees due west

#| Creates a new CLDR-Units object
method new(\blob, uint64 $offset is rw --> ::?CLASS) {
    use Intl::CLDR::Util::StrDecode;

    self.bless:
        display-name => StrDecode::get(blob, $offset),
        north        => StrDecode::get(blob, $offset),
        east         => StrDecode::get(blob, $offset),
        south        => StrDecode::get(blob, $offset),
        west         => StrDecode::get(blob, $offset),
}

#`<<<<<# GENERATOR: Use toggle-generators.raku to [dis|en]able this code.
method encode(%*durations) {
    use Intl::CLDR::Util::StrEncode;
    my $result = buf8.new;

    $result ~= StrEncode::get(%*durations<displayName> // '');
    $result ~= StrEncode::get(%*durations<north> // '');
    $result ~= StrEncode::get(%*durations<east>  // '');
    $result ~= StrEncode::get(%*durations<south> // '');
    $result ~= StrEncode::get(%*durations<west>  // '');

    $result
}
method parse(\base, \xml) {
    use Intl::CLDR::Util::XML-Helper;
    base{.<type>}     = contents $_ for  xml.&elems('coordinateUnitPattern');
    base<displayName> = contents $_ with xml.&elem( 'displayName');
}
>>>>># GENERATOR