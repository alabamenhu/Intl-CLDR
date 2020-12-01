use Intl::CLDR::Immutability;


unit class CLDR-IntervalFormats is CLDR-Item;
use Intl::CLDR::Types::IntervalFormat;

has $!parent; #= The CLDR-DateTimeFormats that contains this CLDR-IntervalFormats

# TODO: provide matching method here?  or just rely on other modules and hash .keys value?

#| Creates a new CLDR-IntervalFormats object
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
                CLDR-IntervalFormat.new(blob, $offset,self)
    }

    self
}

##`<<<<< # GENERATOR: This method should only be uncommented out by the parsing script
method encode(\hash) {
    use Intl::CLDR::Util::StrEncode;

    my $result = buf8.new;
    my $format-count = hash.keys.elems;

    die "Need to update AvailableFormats.pm6 to enable more than 255 items"
        if $format-count > 255;

    $result.append: $format-count;

    for hash<formats>.kv -> \key, \value {
        $result ~= StrEncode::get(key // '');
        $result ~= CLDR-IntervalFormat.encode(value // '');
    }

    state $a = 0;

    $result
}
method parse(\base, \xml) {
    use Intl::CLDR::Util::XML-Helper;
    base<fallback> = contents $_ with xml.&elem('intervalFormatFallback');
    CLDR-IntervalFormat.parse: (base<formats>{.<id>} //= Hash.new), $_ for xml.&elems('intervalFormatItem')
}

#>>>>> # GENERATOR
