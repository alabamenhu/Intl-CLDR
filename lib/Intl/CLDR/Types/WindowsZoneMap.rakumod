unit class CLDR::WindowsZoneMap;
    use Intl::CLDR::Core;
    also does CLDR::Item;
    also is   XUnordered;

method default { self.Hash::AT-KEY('001').head }

method new(|c --> ::?CLASS) {
    self.bless!add-items: |c
}

submethod !add-items(\blob, uint64 $offset is rw --> ::?CLASS) {

    use Intl::CLDR::Util::StrDecode;

    my $count = blob[$offset++];
    self.Hash::BIND-KEY:
            StrDecode::get(blob, $offset),
            List.new( (StrDecode::get(blob, $offset) for ^(blob[$offset++])) )
    for ^$count;

    self
}

method keys { self.Hash::keys }
method AT-KEY(|c) { self.Hash::AT-KEY: |c }

#`<<<<<# GENERATOR: Use toggle-generators.raku to [dis|en]able this code.
method encode(\hash) {
    use Intl::CLDR::Util::StrEncode;
    my $count = hash.keys.elems;
    my $result = buf8.new;

    die "Add capacity for 255+ items in WindowsZoneMap.rakumod" if $count > 255;
    $result.append: $count;

    for hash.kv -> \tzname, \zones {
        say "Processing {tzname} with {zones.elems} possibilities: {zones}";
        $result ~= StrEncode::get(tzname);
        $result.append: zones.elems;
        $result ~= StrEncode::get($_) for zones.values;
    };
    $result
}
method parse(\base, \xml) {
    use Intl::CLDR::Util::XML-Helper;
   #base<windows>   = xml.<other>.Str;           # Not needed, because key = Windows ID
    base{xml.<territory>.Str} = xml.<type>.Str.split(' ');
}
>>>>># GENERATOR