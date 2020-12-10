use Intl::CLDR::Immutability;

unit class CLDR-DateTimeFormats is CLDR-ItemNew;

use Intl::CLDR::Types::DateTimeFormat;
use Intl::CLDR::Types::AvailableFormats;
use Intl::CLDR::Types::IntervalFormats;
use Intl::CLDR::Types::AppendItems;

has $!parent;
has CLDR-DateTimeFormat   $.full;
has CLDR-DateTimeFormat   $.long;
has CLDR-DateTimeFormat   $.medium;
has CLDR-DateTimeFormat   $.short;
has CLDR-AvailableFormats $.available-formats;
has CLDR-AppendItems      $.append-items;
has CLDR-IntervalFormats  $.interval-formats;
has Str                   $.interval-fallback-format;

#| Creates a new CLDR-DateTimes object
method new(|c) {
    self.bless!bind-init: |c;
}

submethod !bind-init(\blob, uint64 $offset is rw, \parent) {
    $!parent := parent;

    use Intl::CLDR::Util::StrDecode;

    $!full                      = CLDR-DateTimeFormat.new:   blob, $offset, self;
    $!long                      = CLDR-DateTimeFormat.new:   blob, $offset, self;
    $!medium                    = CLDR-DateTimeFormat.new:   blob, $offset, self;
    $!short                     = CLDR-DateTimeFormat.new:   blob, $offset, self;
    $!available-formats         = CLDR-AvailableFormats.new: blob, $offset, self;
    $!append-items              = CLDR-AppendItems.new:      blob, $offset, self;
    $!interval-formats          = CLDR-IntervalFormats.new:  blob, $offset, self;
    $!interval-fallback-format  = StrDecode::get(            blob, $offset);

    self
}

constant detour = Map.new: (
    availableFormats       => 'available-formats',
    intervalFormats        => 'interval-formats',
    intervalFallBackFormat => 'interval-fallback-format',
    appendItems            => 'append-items'
);
method DETOUR (-->detour) {;}

##`<<<<<#GENERATOR: This method should only be uncommented out by the parsing script
method encode(%*datetime-formats) {
    my $result = buf8.new;

    use Intl::CLDR::Util::StrEncode;

    my $*datetime-format-width;

    $*datetime-format-width = 'full';
    $result ~= CLDR-DateTimeFormat.encode: %*datetime-formats<full> // Hash;
    $*datetime-format-width = 'long';
    $result ~= CLDR-DateTimeFormat.encode: %*datetime-formats<long> // Hash;
    $*datetime-format-width = 'medium';
    $result ~= CLDR-DateTimeFormat.encode: %*datetime-formats<medium> // Hash;
    $*datetime-format-width = 'short';
    $result ~= CLDR-DateTimeFormat.encode: %*datetime-formats<short> // Hash;

    $result ~= CLDR-AvailableFormats.encode: %*datetime-formats<availableFormats> // Hash;
    $result ~= CLDR-AppendItems.encode:      %*datetime-formats<appendItems> // Hash;
    $result ~= CLDR-IntervalFormats.encode:  %*datetime-formats<intervalFormats> // Hash;


    sub fallback {
        my @try = do given $*calendar-type {
            when 'buddhist'    { <buddhist gregorian generic> }
            when 'japanese'    { <japanese gregorian generic> }
            when 'roc'         { <roc      gregorian generic> }
            when 'ethiopic-amete-alem'         { <ethiopic-amete-alem ethiopic generic> }
            when 'dangi'       { <dangi    chinese   generic> }
            when /^'islamic-'/ { $*calendar-type, 'islamic','generic' }
            default            { $*calendar-type,   'generic' }
        }

        for @try -> $type {
            .return with %*calendars{$type}<dateTimeFormats><intervalFallbackFormat>;
        }
        return ''; # last resort
    }

    # This still needs calendar-based fallbacks to occur
    $result ~= StrEncode::get( fallback() || '');

    $result
}
method parse(\base, \xml) {
    use Intl::CLDR::Util::XML-Helper;
    for xml.&elems('dateTimeFormatLength') {
        # There should really only be one pattern.
        # There isn't always (read: rarely if ever) a display name.
        my $length = .<type>;
        my $format = .&elem('dateTimeFormat');

        base{$length}<pattern>     = $format.&elem('pattern').&contents;
        base{$length}<displayName> = $format.&elem('displayName').&contents;
    }

    CLDR-AvailableFormats.parse: (base<availableFormats> //= Hash.new), $_ with xml.&elem('availableFormats');
    CLDR-AppendItems.parse:      (base<appendItems>      //= Hash.new), $_ with xml.&elem('appendItems');
    CLDR-IntervalFormats.parse:  (base<intervalFormats>  //= Hash.new), $_ with xml.&elem('intervalFormats');
    base<intervalFormatFallback> = contents $_ with xml.&elem('intervalFormats').&elem('intervalFormatFallback');
}

#>>>>>#GENERATOR
