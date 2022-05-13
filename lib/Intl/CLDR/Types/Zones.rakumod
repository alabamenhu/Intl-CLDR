use Intl::CLDR::Immutability;
use Intl::CLDR::Types::Zone;

unit class CLDR-Zones is CLDR-Unordered is CLDR-ItemNew ;

#! Because names are not stable, no other attributes:
#!   hashy access is required)

#| Creates a new CLDR-Zones object
method new(|c) {
    self.bless!bind-init: |c;
}

submethod !bind-init(\blob, uint64 $offset is rw) {

    use Intl::CLDR::Util::StrDecode;

    my $count = blob[$offset++] * 256 + blob[$offset++];

    for ^$count {
        self.Hash::BIND-KEY:
                StrDecode::get(blob, $offset),
                CLDR-Zone.new(blob, $offset)
    }

    self
}

##`<<<<< # GENERATOR: This method should only be uncommented out by the parsing script
method encode(\hash) {
    use Intl::CLDR::Util::StrEncode;
    use Intl::CLDR::Types::Zone;

    my $count = hash.keys.elems;
    my $result = buf8.new;

    $result.append: $count div 256;
    $result.append: $count mod 256;
    for hash.kv -> \tzname, \value {
        $result ~= StrEncode::get(tzname);
        $result ~= CLDR-Zone.encode(value);
    };

    $result
}
method parse(\base, \xml, \zone-type) {
    use Intl::CLDR::Util::XML-Helper;
    CLDR-Zone.parse: (base{$_<type>} //= Hash.new), $_ for xml.&elems(zone-type);
}

#>>>>> # GENERATOR
