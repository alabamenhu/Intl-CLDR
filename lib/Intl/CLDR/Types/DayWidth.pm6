use Intl::CLDR::Immutability;

unit class CLDR-DayWidth is CLDR-Item;

has     $!parent;
has Str $.sun;
has Str $.mon;
has Str $.tue;
has Str $.wed;
has Str $.thu;
has Str $.fri;
has Str $.sat;



#| Creates a new CLDR-DayWidth object
method new(|c) {
    self.bless!bind-init: |c;
}

submethod !bind-init(\blob, uint64 $offset is rw, \parent) {
    $!parent := parent;

    self.Hash::BIND-KEY: 'sun', $!sun;
    self.Hash::BIND-KEY: 'mon', $!mon;
    self.Hash::BIND-KEY: 'tue', $!tue;
    self.Hash::BIND-KEY: 'wed', $!wed;
    self.Hash::BIND-KEY: 'thu', $!thu;
    self.Hash::BIND-KEY: 'fri', $!fri;
    self.Hash::BIND-KEY: 'sat', $!sat;

    use Intl::CLDR::Classes::StrDecode;

    $!sun = StrDecode::get(blob, $offset);
    $!mon = StrDecode::get(blob, $offset);
    $!tue = StrDecode::get(blob, $offset);
    $!wed = StrDecode::get(blob, $offset);
    $!thu = StrDecode::get(blob, $offset);
    $!fri = StrDecode::get(blob, $offset);
    $!sat = StrDecode::get(blob, $offset);

    self
}

multi method AT-POS(\pos, :$leap!) {
    self.Array::AT-POS(pos + 128)
}

##`<<<<< # GENERATOR: This method should only be uncommented out by the parsing script
method encode(\hash) {
    my $result = buf8.new;
    # Fallback patterns are rather complex.  I try to make this code as presentable as possible.
    # Currently, the fallbacks here are identical across all calendar types, if making any changes
    # ensure that all files follow suit, or that there are real differences.

    # Within a month context, the rules are defined in root.xml
    sub context (%d #`[days], $id) {
        do given $*day-context, $*day-width {
            when 'stand-alone', 'wide'         { %d<stand-alone><wide       >{$id} // %d<format     ><wide       >{$id}                          }
            when 'stand-alone', 'abbreviated'  { %d<stand-alone><abbreviated>{$id} // %d<format     ><abbreviated>{$id} // %d<format><wide>{$id} }
            when 'stand-alone', 'narrow'       { %d<stand-alone><narrow     >{$id}                                                               }
            when 'format',      'wide'         { %d<format     ><wide       >{$id}                                                               }
            when 'format',      'abbreviated'  { %d<format     ><abbreviated>{$id} // %d<format     ><wide        >{$id}                          }
            when 'format',      'narrow'       { %d<format     ><narrow     >{$id} // %d<stand-alone><narrow      >{$id}                          }
        } || Nil
    }

    # If the above search fails, then we need to change calendars per
    # http://cldr.unicode.org/development/development-process/design-proposals/generic-calendar-data
    sub fallback ($id) {
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
            .return with context (%*calendars{$type}<days> // Hash), $id;
        }
        return ''; # last resort
    }

    use Intl::CLDR::Classes::StrEncode;

    for <sun mon tue wed thu fri sat> -> $day-id {
        $result ~= StrEncode::get(fallback $day-id);
    }

    $result
}
method parse(\base, \xml) {
    use Intl::CLDR::Util::XML-Helper;
    base{.<type>} = contents $_ for xml.&elems('day')
}
#>>>>> # GENERATOR
