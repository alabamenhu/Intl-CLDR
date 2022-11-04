unit class CLDR::IntervalFormats;
    use Intl::CLDR::Core;
    also does CLDR::Item;
    also is   CLDR::Unordered;

use Intl::CLDR::Types::IntervalFormat;

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
            CLDR::IntervalFormat.new(blob, $offset,self)
    for ^$count;

    self
}

#`<<<<<# GENERATOR: Use toggle-generators.raku to [dis|en]able this code.
method encode(%*interval-formats) {
    use Intl::CLDR::Util::StrEncode;

    my $result = buf8.new;
    my $format-count = %*interval-formats<formats>.keys.elems;

    die "Need to update AvailableFormats.pm6 to enable more than 255 items"
        if $format-count > 255;

    $result.append: $format-count;

    for %*interval-formats<formats>.kv -> \key, \value {
        $result ~= StrEncode::get(key // '');
        $result ~= CLDR::IntervalFormat.encode(value // '');
    }

    $result
}
method parse(\base, \xml) {
    use Intl::CLDR::Util::XML-Helper;
    base<fallback> = contents $_ with xml.&elem('intervalFormatFallback');
    CLDR::IntervalFormat.parse: (base<formats>{.<id>} //= Hash.new), $_ for xml.&elems('intervalFormatItem')
}
>>>>># GENERATOR