use Intl::CLDR::Immutability;

unit class CLDR-DateTimeFormats is CLDR-Item;

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

    self.Hash::BIND-KEY: 'full',                   $!full;
    self.Hash::BIND-KEY: 'long',                   $!long;
    self.Hash::BIND-KEY: 'medium',                 $!medium;
    self.Hash::BIND-KEY: 'short',                  $!short;
    self.Hash::BIND-KEY: 'available-formats',      $!available-formats;
    self.Hash::BIND-KEY: 'availableFormats',       $!available-formats;
    self.Hash::BIND-KEY: 'append-items',           $!append-items;
    self.Hash::BIND-KEY: 'appendItems',            $!append-items;
    self.Hash::BIND-KEY: 'interval-formats',       $!interval-formats;
    self.Hash::BIND-KEY: 'intervalFormats',        $!interval-formats;
    self.Hash::BIND-KEY: 'intervalFallbackFormat', $!interval-fallback-format;

    use Intl::CLDR::Classes::StrDecode;

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

##`<<<<<#GENERATOR: This method should only be uncommented out by the parsing script
method encode(%*datetime-formats) {
    my $result = buf8.new;

    use Intl::CLDR::Classes::StrEncode;

    my $*datetime-format-width;

    $*datetime-format-width = 'full';
    $result ~= CLDR-DateTimeFormat.encode: %*datetime-formats<full>;
    $*datetime-format-width = 'long';
    $result ~= CLDR-DateTimeFormat.encode: %*datetime-formats<long>;
    $*datetime-format-width = 'medium';
    $result ~= CLDR-DateTimeFormat.encode: %*datetime-formats<medium>;
    $*datetime-format-width = 'short';
    $result ~= CLDR-DateTimeFormat.encode: %*datetime-formats<short>;

    $result ~= CLDR-AvailableFormats.encode: %*datetime-formats<availableFormats>;
    $result ~= CLDR-AppendItems.encode:      %*datetime-formats<appendItems>;
    $result ~= CLDR-IntervalFormats.encode:  %*datetime-formats<intervalFormats>;


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
    $result ~= StrEncode::get( fallback );

    $result
}
#>>>>>#GENERATOR
