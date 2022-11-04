unit class CLDR::TimezoneMaps;
    use Intl::CLDR::Core;
    also does CLDR::Item;

use Intl::CLDR::Types::WindowsZoneMaps;
#use Intl::CLDR::Types::MetazoneMaps;

#has CLDR::MetazoneMaps    $.metazones;
has CLDR::WindowsZoneMaps $.windows-zones;

method new(\blob, uint64 $offset is rw --> ::?CLASS) {
    self.bless:
        #metazones => CLDR::MetazoneMaps.new(blob, $offset),
        windows-zones => CLDR::WindowsZoneMaps.new(blob, $offset);
}

#`<<<<<# GENERATOR: Use toggle-generators.raku to [dis|en]able this code.
method encode(\hash) {
    use Intl::CLDR::Util::StrEncode;
    say hash<winzones>;
    my $result = buf8.new;

    $result.append: CLDR::WindowsZoneMaps.encode(hash<winzones>);
    #$result.append: $count mod 256;

    $result
}
method parse(\base, \xml) {
    use Intl::CLDR::Util::XML-Helper;
    CLDR::WindowsZoneMaps.parse: (base<winzones>  //= Hash.new), $_ with $*winzones-xml;
    #CLDR::MetazoneMaps.parse:    (base<metazones> //= Hash.new), $_ with $*metazones-xml;
}

>>>>># GENERATOR