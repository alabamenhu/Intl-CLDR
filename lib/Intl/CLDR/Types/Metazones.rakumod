unit class CLDR::Metazones;
    use Intl::CLDR::Core;
    also does CLDR::Item;
    also is   CLDR::Unordered;

use Intl::CLDR::Types::Zone;

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
            CLDR::Zone.new(blob, $offset)
    for ^$count;

    self
}

##`<<<<< # GENERATOR: This method should only be uncommented out by the parsing script
method encode(\hash) {
    use Intl::CLDR::Util::StrEncode;
    use Intl::CLDR::Types::Zone;

    my $count = hash.keys.elems;
    my $result = buf8.new;

    die "Add capacity for 255+ items in Metazones.pm6" if $count > 255;
    $result.append: $count;

    for hash.kv -> \tzname, \value {
        $result ~= StrEncode::get(tzname);
        $result ~= CLDR::Zone.encode(value);
    };

    $result
}
method parse(\base, \xml, \zone-type) {
    use Intl::CLDR::Util::XML-Helper;
    CLDR::Zone.parse: (base{$_<type>} //= Hash.new), $_ for xml.&elems(zone-type);
}
#>>>>> # GENERATOR
