unit class CLDR::Subdivision;
    use Intl::CLDR::Core;

    also does CLDR::Item;
    also does Stringy;
    also is CLDR::Unordered;

has Str $.id; #= The unique identifier for this subdivision

# Role based methods
method of      (--> CLDR::Subdivision) {      }
method Str     (-->               Str) { $!id }
method Stringy (-->           Stringy) { $!id }
method keys    (-->               Seq) { self.Hash::keys }
method AT-KEY  (\key --> ::?CLASS) { self.Hash::AT-KEY(key) }

method new (\blob, uint64 $offset is rw --> ::?CLASS) {
    use Intl::CLDR::Util::StrDecode;
    my Str $id := StrDecode::get(blob, $offset -= 2);

    my \self-new = self.bless: :$id;

    my int $count = blob[$offset++];

    # Hashes do not have a build phase
    self-new.Hash::BIND-KEY:
        StrDecode::get(       blob, $offset),
        CLDR::Subdivision.new(blob, $offset)
            for ^$count;

    self-new
}

##`<<<<< # GENERATOR: This method should only be uncommented out by the parsing script
method encode(%subdivisions --> buf8) {
    use Intl::CLDR::Util::StrEncode;
    my $result = buf8.new;

    # Note the number of elements first
    $result.append: %subdivisions.elems;

    for %subdivisions.kv -> $region, %subregion {
        $result ~= StrEncode::get($region);
        $result ~= CLDR::Subdivision.encode(%subregion);
    }

    $result
}
method parse(\base, \xml --> Nil) {
    use Intl::CLDR::Util::XML-Helper;
    for xml.<contains>.split(/\h+/) -> $sub-type {
        CLDR::Subdivision.parse: (base{.<type>} //= Hash.new), $_
            with $*subdivisions-xml.&elem('subdivisionContainment').&elems('subgroup')
                .grep( *.<type> eq $sub-type).head;
    }
}
#>>>>> # GENERATOR
