use Intl::CLDR::Immutability;


unit class CLDR-IntervalFormats is CLDR-ItemNew is CLDR-Unordered;
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
method encode(%*interval-formats) {
    use Intl::CLDR::Util::StrEncode;

    my $result = buf8.new;
    my $format-count = %*interval-formats<formats>.keys.elems;

    die "Need to update AvailableFormats.pm6 to enable more than 255 items"
        if $format-count > 255;

    $result.append: $format-count;

    for %*interval-formats<formats>.kv -> \key, \value {
        $result ~= StrEncode::get(key // '');
        $result ~= CLDR-IntervalFormat.encode(value // '');
    }

    $result
}
method parse(\base, \xml) {
    use Intl::CLDR::Util::XML-Helper;
    base<fallback> = contents $_ with xml.&elem('intervalFormatFallback');
    CLDR-IntervalFormat.parse: (base<formats>{.<id>} //= Hash.new), $_ for xml.&elems('intervalFormatItem')
}

#>>>>> # GENERATOR
