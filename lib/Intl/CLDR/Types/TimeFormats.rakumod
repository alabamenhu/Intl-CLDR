unit class CLDR::TimeFormats;
    use Intl::CLDR::Core;
    also does CLDR::Item;

use Intl::CLDR::Types::TimeFormat;

has CLDR::TimeFormat $.full;
has CLDR::TimeFormat $.long;
has CLDR::TimeFormat $.medium;
has CLDR::TimeFormat $.short;

#| Creates a new CLDR-Times object
method new(\blob, uint64 $offset is rw --> ::?CLASS) {
    self.bless:
        full   => CLDR::TimeFormat.new(blob, $offset),
        long   => CLDR::TimeFormat.new(blob, $offset),
        medium => CLDR::TimeFormat.new(blob, $offset),
        short  => CLDR::TimeFormat.new(blob, $offset),
}

##`<<<<<#GENERATOR: This method should only be uncommented out by the parsing script
method encode(%time-formats) {
    my $result = buf8.new;

    my $*time-format-width;

    $*time-format-width = 'full';
    $result ~= CLDR::TimeFormat.encode: %time-formats<full>;
    $*time-format-width = 'long';
    $result ~= CLDR::TimeFormat.encode: %time-formats<long>;
    $*time-format-width = 'medium';
    $result ~= CLDR::TimeFormat.encode: %time-formats<medium>;
    $*time-format-width = 'short';
    $result ~= CLDR::TimeFormat.encode: %time-formats<short>;

    $result;
}
method parse(\base, \xml) {
    use Intl::CLDR::Util::XML-Helper;
    for xml.&elems('timeFormatLength') {
        # There should really only be one pattern.
        # There isn't always (read: rarely if ever) a display name.
        my $length = .<type>;
        my $format = .&elem('timeFormat');

        base{$length}<pattern>     = $format.&elem('pattern', :ignore-alt).&contents; # wtf nn
        base{$length}<displayName> = $format.&elem('displayName').&contents;
    }
}

#>>>>>#GENERATOR
