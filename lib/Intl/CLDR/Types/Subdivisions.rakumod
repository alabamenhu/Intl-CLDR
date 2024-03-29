unit class CLDR::Subdivisions;
    use Intl::CLDR::Core;
    also does CLDR::Item;
    also is   CLDR::Unordered;

use Intl::CLDR::Types::Subdivision;

method of (--> CLDR::Subdivision) {}

method new(\blob, uint64 $offset is rw --> ::?CLASS) {
    use Intl::CLDR::Util::StrDecode;
    my uint $count = blob[$offset++];
    my \self-new = self.bless;
    for ^$count {
        self-new.Hash::BIND-KEY:
            StrDecode::get(       blob, $offset),
            CLDR::Subdivision.new(blob, $offset);
    }
    self-new
}



#`<<<<<# GENERATOR: Use toggle-generators.raku to [dis|en]able this code.
method encode(%subdivisions --> buf8) {
    use Intl::CLDR::Util::StrEncode;
    my $result = buf8.new;

    $result.append: %subdivisions.keys.elems;

    for %subdivisions.kv -> $country, %states {
        $result ~= StrEncode::get($country);
        $result ~= CLDR::Subdivision.encode(%states);
    }

    $result
}
method parse(\base, \xml --> Nil) {
    use Intl::CLDR::Util::XML-Helper;
    CLDR::Subdivision.parse: (base{.<type>} //= Hash.new), $_
        for $*subdivisions-xml.&elem('subdivisionContainment').&elems('subgroup').grep(*.<type>.chars == 2);
}
>>>>># GENERATOR