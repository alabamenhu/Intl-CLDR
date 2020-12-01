use Intl::CLDR::Immutability;

#| A set of interval formats categorized by their greatest common difference
unit class CLDR-IntervalFormat is CLDR-Item;

has $!parent; #= The CLDR-IntervalFormats that contains this CLDR-IntervalFormat

# TODO: provide matching method here?  or just rely on other modules and hash .keys value?

#| Creates a new CLDR-IntervalFormats object
method new(|c) {
    self.bless!bind-init: |c;
}

submethod !bind-init(\blob, uint64 $offset is rw, \parent) {
    $!parent := parent;

    use Intl::CLDR::Classes::StrDecode;

    my $count = blob[$offset++];
    for ^$count {
        self.Hash::BIND-KEY:
                StrDecode::get(blob, $offset),
                StrDecode::get(blob, $offset)
    }

    self
}

##`<<<<< # GENERATOR: This method should only be uncommented out by the parsing script
method encode(\hash) {
    use Intl::CLDR::Classes::StrEncode;

    my $result = buf8.new;

    my $format-count = hash.keys.elems;

    $result.append: $format-count;

    for hash.kv -> \key, \value {
        $result ~= StrEncode::get(key);
        $result ~= StrEncode::get(value);
    }

    $result
}
method parse(\base, \xml) {
    use Intl::CLDR::Util::XML-Helper;
    base{.<id>} = contents $_ for xml.&elems('greatestDifference')
}

#>>>>> # GENERATOR
