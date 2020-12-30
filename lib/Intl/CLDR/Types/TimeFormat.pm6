use Intl::CLDR::Immutability;

#| A class implementing CLDR's <dates> element, containing information about formatting dates.
unit class CLDR-TimeFormat is CLDR-ItemNew;


has     $!parent;         #= The CLDR-DateFormats object containing this CLDR-DateFormat
has Str $.display-name;
has Str $.pattern;

#| Creates a new CLDR-Dates object
method new(|c) {
    self.bless!bind-init: |c;
}

submethod !bind-init(\blob, uint64 $offset is rw, \parent) {
    $!parent := parent;

    use Intl::CLDR::Util::StrDecode;

    $!display-name = StrDecode::get(blob, $offset);
    $!pattern      = StrDecode::get(blob, $offset);

    self
}
constant detour = Map.new: (
    displayName => 'display-name'
);

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
            .return with %*calendars{$type}<timeFormats>{$*time-format-width}{$id};
        }
        return ''; # last resort
    }

    use Intl::CLDR::Util::StrEncode;

    $result ~= StrEncode::get( fallback 'displayName');
    $result ~= StrEncode::get( fallback 'pattern');

    $result
}
method parse(\base, \xml) {
    # currently handled in TimeFormats.pm6
}
#>>>>> # GENERATOR
