unit class CLDR::DateFormats;
    use Intl::CLDR::Core;
    also does CLDR::Item;

use Intl::CLDR::Types::DateFormat;

has CLDR::DateFormat $.full;
has CLDR::DateFormat $.long;
has CLDR::DateFormat $.medium;
has CLDR::DateFormat $.short;

#| Creates a new CLDR-Dates object
method new(\blob, uint64 $offset is rw) {
    self.bless:
        full   => CLDR::DateFormat.new(blob, $offset),
        long   => CLDR::DateFormat.new(blob, $offset),
        medium => CLDR::DateFormat.new(blob, $offset),
        short  => CLDR::DateFormat.new(blob, $offset),
}

##`<<<<<#GENERATOR: This method should only be uncommented out by the parsing script
method encode(%date-formats) {
    my $result = buf8.new;

    my $*date-format-width;

    $*date-format-width = 'full';
    $result ~= CLDR::DateFormat.encode: %date-formats<full>;
    $*date-format-width = 'long';
    $result ~= CLDR::DateFormat.encode: %date-formats<long>;
    $*date-format-width = 'medium';
    $result ~= CLDR::DateFormat.encode: %date-formats<medium>;
    $*date-format-width = 'short';
    $result ~= CLDR::DateFormat.encode: %date-formats<short>;

    $result;
}
method parse(\base, \xml) {
    use Intl::CLDR::Util::XML-Helper;
    for xml.&elems('dateFormatLength') {
        # There should really only be one pattern.
        # There isn't always (read: rarely if ever) a display name.
        my $length = .<type>;
        my $format = .&elem('dateFormat');

        base{$length}<pattern>     = $format.&elem('pattern').&contents;
        base{$length}<displayName> = $format.&elem('displayName').&contents;
    }
}
#>>>>>#GENERATOR
