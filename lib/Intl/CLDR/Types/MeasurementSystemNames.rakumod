unit class CLDR::MeasurementSystemNames;
    use Intl::CLDR::Core;
    also does CLDR::Item;

has Str $.metric;                #= The metric system
has Str $.uk is aliased-by<UK>;  #= The UK imperial system
has Str $.us is aliased-by<US>;  #= The US customary system

method new(\blob, uint64 $offset is rw --> ::?CLASS) {
    use Intl::CLDR::Util::StrDecode;
    self.bless:
        metric => StrDecode::get(blob, $offset),
        uk     => StrDecode::get(blob, $offset),
        us     => StrDecode::get(blob, $offset),
}

#`<<<<<# GENERATOR: Use toggle-generators.raku to [dis|en]able this code.
method encode(%*territories --> buf8) {
    use Intl::CLDR::Util::StrEncode;

    my $result = buf8.new;

    $result ~= StrEncode::get(%*measurement-systems<metric> // '');
    $result ~= StrEncode::get(%*measurement-systems<uk>     // '');
    $result ~= StrEncode::get(%*measurement-systems<us>     // '');

    $result
}
method parse(\base, \xml) {
    use Intl::CLDR::Util::XML-Helper;
    base{.<type>} = contents $_ for xml.&elems('measurementSystemName');
}
>>>>># GENERATOR