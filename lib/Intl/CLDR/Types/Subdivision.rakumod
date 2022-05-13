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
#method keys    (-->               Seq) { say "Called keys"; self.Hash::keys }
#method AT-KEY  (\key --> ::?CLASS) { self.Hash::AT-KEY(key) }
method Bool    (--> True) { } #for some reason, this is occasionally being returned as false

method new (\blob, uint64 $offset is rw --> ::?CLASS) {
    use Intl::CLDR::Util::StrDecode;
    my Str $id := StrDecode::get(blob, $offset -= 2);

    my \self-new = self.bless: :$id;

    my uint $count = blob[$offset++];

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

    say "Need to parse ", xml.<contains>.split(/\h+/).join('/');

    for xml.<contains>.split(/\h+/) -> $sub-type {
        say "  Parsing $sub-type";
        with $*subdivisions-xml.&elem('subdivisionContainment').&elems('subgroup')
                .grep(*.<type> eq $sub-type).head {
                CLDR::Subdivision.parse: (base{$sub-type} //= Hash.new), $_
        } else {
            base{$sub-type} //= Hash.new
        }
    }
    say base;
}
#>>>>> # GENERATOR
