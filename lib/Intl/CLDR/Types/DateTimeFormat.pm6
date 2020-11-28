use Intl::CLDR::Immutability;

#| A class implementing CLDR's <DateTimes> element, containing information about formatting DateTimes.
unit class CLDR-DateTimeFormat is CLDR-Item;


has     $!parent;         #= The CLDR-DateTimeFormats object containing this CLDR-DateTimeFormat
has Str $.display-name;
has Str $.pattern;

#| Creates a new CLDR-DateTimes object
method new(|c) {
    self.bless!bind-init: |c;
}

submethod !bind-init(\blob, uint64 $offset is rw, \parent) {
    $!parent := parent;

    self.Hash::BIND-KEY: 'display-name', $!display-name;
    self.Hash::BIND-KEY: 'displayName',  $!display-name;
    self.Hash::BIND-KEY: 'pattern',      $!pattern;

    use Intl::CLDR::Classes::StrDecode;

    loop {
        my \code = blob[$offset++];
        if    code == 1 { $!display-name = StrDecode.get: blob, $offset }
        if    code == 2 { $!pattern      = StrDecode.get: blob, $offset }
        elsif code == 0 { last                                                  }
        else            { die "Unknown code {code} found when decoding DateTimeFormat element" }
    }

    self
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

    use Intl::CLDR::Classes::StrEncode;

    $result ~= StrEncode::get( fallback 'displayName');
    $result ~= StrEncode::get( fallback 'pattern');

    $result
}
#>>>>> # GENERATOR
