unit class CLDR::WindowsZoneMaps;
    use Intl::CLDR::Core;
    also does CLDR::Item;
    also is CLDR::Unordered;

use Intl::CLDR::Types::WindowsZoneMap;

# Because names are not stable, no other attributes:
#   attribute access handled via Unordered FALLBACK capture)

#| Creates a new CLDR::Metazones object
method new(|c --> ::?CLASS) {
    self.bless!add-items: |c;
}

submethod !add-items(\blob, uint64 $offset is rw --> ::?CLASS) {

    use Intl::CLDR::Util::StrDecode;

    my $count = blob[$offset++];
    self.Hash::BIND-KEY:
            StrDecode::get(blob, $offset),
            CLDR::WindowsZoneMap.new(blob, $offset)
    for ^$count;

    self
}

#`<<<<<# GENERATOR: Use toggle-generators.raku to [dis|en]able this code.
method encode(\hash) {
    use Intl::CLDR::Util::StrEncode;

    my $count = hash.keys.elems;
    my $result = buf8.new;

    die "Add capacity for 255+ items in Metazones.pm6" if $count > 255;
    $result.append: $count;

    for hash.kv -> \win-name, \value {
        $result ~= StrEncode::get(win-name);
        $result ~= CLDR::WindowsZoneMap.encode(value);
    };

    $result
}
method parse(\base, \xml) {
    use Intl::CLDR::Util::XML-Helper;
    CLDR::WindowsZoneMap.parse: (base{$_.<other>} //= Hash.new), $_ for xml.&elem('windowsZones').&elem('mapTimezones').&elems('mapZone');
}
>>>>># GENERATOR