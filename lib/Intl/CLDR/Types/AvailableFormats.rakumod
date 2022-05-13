# Used by DataTimeFormats to list date/time formats that are known to a language
unit class CLDR::AvailableFormats;

use       Intl::CLDR::Core;
also does CLDR::Item;
also is   CLDR::Unordered;

#| Creates a new CLDR::AvailableFormats object
method new(\blob, uint64 $offset is rw --> ::?CLASS) {
    my \new-self = self.bless;

    use Intl::CLDR::Util::StrDecode;

    my $count = blob[$offset++];
    self.Hash::BIND-KEY:
        StrDecode::get(blob, $offset),
        StrDecode::get(blob, $offset)
    for ^$count;

    new-self
}

submethod !bind-init(\blob, uint64 $offset is rw --> ::?CLASS) {
    use Intl::CLDR::Util::StrDecode;

    my $count = blob[$offset++];

    self.Hash::BIND-KEY:
        StrDecode::get(blob, $offset),
        StrDecode::get(blob, $offset)
    for ^$count;

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
