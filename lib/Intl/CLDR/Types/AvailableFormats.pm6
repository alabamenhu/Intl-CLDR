use Intl::CLDR::Immutability;

unit class CLDR-AvailableFormats is CLDR-Item;

has $!parent; #= The CLDR-DateTimeFormats that contains this CLDR-AvailableFormats

# TODO: provide matching method here?  or just rely on other modules and hash .keys value?

#| Creates a new CLDR-AvailableFormats object
method new(|c) {
    self.bless!bind-init: |c;
}

submethod !bind-init(\blob, uint64 $offset is rw, \parent) {
    $!parent := parent;

    use Intl::CLDR::Util::StrDecode;

    my $count = blob[$offset++];
    for ^$count {
        self.Hash::BIND-KEY:
                StrDecode::get(blob, $offset),
                StrDecode::get(blob, $offset)
    }

    self
}

##`<<<<< # GENERATOR: This method should only be uncommented out by the parsing script
method encode(%*formats) {
    use Intl::CLDR::Util::StrEncode;

    my $result = buf8.new;

    my $format-count = %*formats.keys.elems;
    die "Need to update AvailableFormats.pm6 to enable more than 255 items"
        if $format-count > 255;

    $result.append: $format-count;

    for %*formats.kv -> \key, \value {
        $result ~= StrEncode::get(key);
        $result ~= StrEncode::get(value);
    }

    $result;
}
method parse(\base, \xml) {
    use Intl::CLDR::Util::XML-Helper;
    base{.<id>} = contents $_ for xml.&elems('dateFormatItem')
}

#>>>>> # GENERATOR
