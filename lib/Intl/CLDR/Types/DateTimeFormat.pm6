#| A class implementing CLDR's <DateTimes> element, containing information about formatting DateTimes.
unit class CLDR::DateTimeFormat;
    use Intl::CLDR::Core;
    also does CLDR::Item;

has Str $.display-name is aliased-by<displayName>;
has Str $.pattern;

#| Creates a new CLDR-DateTimes object
method new(\blob, uint64 $offset is rw) {
    use Intl::CLDR::Util::StrDecode;
    self.bless:
        display-name => StrDecode::get(blob, $offset),
        pattern      => StrDecode::get(blob, $offset),
}

##`<<<<< # GENERATOR: This method should only be uncommented out by the parsing script
method encode(\hash) {
    my $result = buf8.new;

    sub fallback ($id) {
        my @try = do given $*calendar-type {
            when 'buddhist'    { <buddhist gregorian generic> }
            when 'japanese'    { <japanese gregorian generic> }
            when 'roc'         { <roc      gregorian generic> }
            when 'ethiopic-amete-alem' { <ethiopic-amete-alem ethiopic generic> }
            when 'dangi'       { <dangi    chinese   generic> }
            when /^'islamic-'/ { $*calendar-type, 'islamic','generic' }
            default            { $*calendar-type,   'generic' }
        }

        for @try -> $type {
            .return with %*calendars{$type}<dateTimeFormats>{$*datetime-format-width}{$id};
        }
        return ''; # last resort
    }

    use Intl::CLDR::Util::StrEncode;

    $result ~= StrEncode::get( fallback 'displayName');
    $result ~= StrEncode::get( fallback 'pattern');

    $result
}
#>>>>> # GENERATOR
