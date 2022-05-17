unit class CLDR::MonthWidth;
    use Intl::CLDR::Core;
    also does CLDR::Item;
    also is   CLDR::Ordered;

#| Creates a new CLDR::MonthWidth object
method new(|c --> ::?CLASS) {
    self.bless!add-items: |c;
}

submethod !add-items(\blob, uint64 $offset is rw, \parent --> ::?CLASS) {
    use Intl::CLDR::Util::StrDecode;

    self.Array::BIND-POS: $_, StrDecode::get(blob, $offset)
        for 1..13;

    self
}

# Hardcoded for now, because only the Hebrew calendar gets this attribute,
# and only on the 7th month -- for ease of encoding, it's stored in
# the 13th slot which shouldn't ever be requested otherwise.
multi method AT-POS($, :$leap!) {
    self.Array::AT-POS(13)
}

#`<<<<<# GENERATOR: Use toggle-generators.raku to [dis|en]able this code.
method encode(%*month-width) {
    my $result = buf8.new;
    # Fallback patterns are rather complex.  I try to make this code as presentable as possible.
    # Currently, the fallbacks here are identical across all calendar types, if making any changes
    # ensure that all files follow suit, or that there are real differences.

    # Within a month context, the rules are defined in root.xml
    sub context (%m #`[months], $id) {
         do given $*month-context, $*month-width {
             when 'stand-alone', 'wide'         { %m<stand-alone><wide       >{$id} // %m<format     ><wide       >{$id}                          }
             when 'stand-alone', 'abbreviated'  { %m<stand-alone><abbreviated>{$id} // %m<format     ><abbreviated>{$id} // %m<format><wide>{$id} }
             when 'stand-alone', 'narrow'       { %m<stand-alone><narrow     >{$id}                                                               }
             when 'format',      'wide'         { %m<format     ><wide       >{$id}                                                               }
             when 'format',      'abbreviated'  { %m<format     ><abbreviated>{$id} // %m<format     ><wide        >{$id}                          }
             when 'format',      'narrow'       { %m<format     ><narrow     >{$id} // %m<stand-alone><narrow      >{$id}                          }
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
            .return with context (%*calendars{$type}<months> // Hash), $id;
        }
        return ''; # last resort
    }

    use Intl::CLDR::Util::StrEncode;

    # Not all calendars have 13 months
    # but &fallback will return '' for 13 if not
    for 1 .. 13 -> $month-id {

        # Special cased because affects only one calendar
        if $*calendar-type eq 'hebrew' && $month-id == 13 {
            $result ~= StrEncode::get(fallback '7leap');
            next;
        }

        $result ~= StrEncode::get(fallback $month-id);
    }

    $result
}
method parse(\base, \xml) {
    use Intl::CLDR::Util::XML-Helper;
    # The leap year adds the text "leap" to the number.  Only affects the Hebrew calendar
    base{.<type> ~ (.<yeartype>||'') } = contents $_ for xml.&elems('month')
}
>>>>># GENERATOR