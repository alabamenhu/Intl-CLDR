#| A set of interval formats categorized by their greatest common difference
#| (mapped by codes: 'm' for minute, 'M' for month, etc.
unit class CLDR::IntervalFormat;
    use Intl::CLDR::Core;
    also does CLDR::Item;
    also is   CLDR::Unordered;

has $!parent; #= The CLDR-IntervalFormats that contains this CLDR-IntervalFormat

# TODO: provide matching method here?  or just rely on other modules and hash .keys value?

#| Creates a new CLDR-IntervalFormats object
method new(|c --> ::?CLASS) {
    self.bless!add-items: |c;
}

submethod !add-items(\blob, uint64 $offset is rw --> ::?CLASS) {
    use Intl::CLDR::Util::StrDecode;
    my $count = blob[$offset++];

    self.Hash::BIND-KEY:
            StrDecode::get(blob, $offset),
            StrDecode::get(blob, $offset)
    for ^$count;

    self
}

##`<<<<< # GENERATOR: This method should only be uncommented out by the parsing script
method encode(\hash) {
    use Intl::CLDR::Util::StrEncode;

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
