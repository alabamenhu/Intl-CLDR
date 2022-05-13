unit class CLDR::Subdivisions;
    use Intl::CLDR::Core;
    also does CLDR::Item;
    also is   CLDR::Unordered;

use Intl::CLDR::Types::Subdivision;

# I'm not sure why these have to be here separately, as they are
# identically defined in CLDR::Unordered
method AT-KEY     (\key) { self.Hash::AT-KEY(    key) }
method EXISTS-KEY (\key) { self.Hash::EXISTS-KEY(key) }

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



##`<<<<< # GENERATOR: This method should only be uncommented out by the parsing script
method encode(%subdivisions --> buf8) {
    use Intl::CLDR::Util::StrEncode;
    my $result = buf8.new;

    $result.append: %subdivisions.keys.elems;

    for %subdivisions.kv -> $country, %states {
        say "Encoding country $country (states {%states.keys})";
        $result ~= StrEncode::get($country);
        $result ~= CLDR::Subdivision.encode(%states);
    }

    $result
}
method parse(\base, \xml --> Nil) {
    use Intl::CLDR::Util::XML-Helper;
    CLDR::Subdivision.parse: (base{.<type>} //= Hash.new), $_
        for $*subdivisions-xml.&elem('subdivisionContainment').&elems('subgroup').grep(*.<type>.chars == 2);
    say "Subdivisions base: \n", base.raku;
}
#>>>>> # GENERATOR
