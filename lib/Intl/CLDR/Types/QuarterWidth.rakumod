unit class CLDR::QuarterWidth;
    use Intl::CLDR::Core;
    also does CLDR::Item;
    also is   CLDR::Ordered;

#| Creates a new CLDR::QuarterWidth object
method new(|c --> ::?CLASS) {
    self.bless!add-items: |c;
}

submethod !add-items(\blob, uint64 $offset is rw --> ::?CLASS) {
    use Intl::CLDR::Util::StrDecode;

    self.Array::BIND-POS: $_, StrDecode::get(blob, $offset)
        for 1..4;

    self
}

##`<<<<< # GENERATOR: This method should only be uncommented out by the parsing script
method encode(\hash) {

    my $result = buf8.new;
    # Fallback patterns are rather complex.  I try to make this code as presentable as possible.
    # Currently, the fallbacks here are identical across all calendar types, if making any changes
    # ensure that all files follow suit, or that there are real differences.

    # Within a month context, the rules are defined in root.xml
    sub context (%q #`[quarters], $id) {
        do given $*quarter-context, $*quarter-width {
            when 'stand-alone', 'wide'         { %q<stand-alone><wide       >{$id} // %q<format     ><wide       >{$id}                          }
            when 'stand-alone', 'abbreviated'  { %q<stand-alone><abbreviated>{$id} // %q<format     ><abbreviated>{$id} // %q<format><wide>{$id} }
            when 'stand-alone', 'narrow'       { %q<stand-alone><narrow     >{$id}                                                               }
            when 'format',      'wide'         { %q<format     ><wide       >{$id}                                                               }
            when 'format',      'abbreviated'  { %q<format     ><abbreviated>{$id} // %q<format     ><wide        >{$id}                          }
            when 'format',      'narrow'       { %q<format     ><narrow     >{$id} // %q<stand-alone><narrow      >{$id}                          }
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
            .return with context (%*calendars{$type}<quarters> // Hash), $id;
        }
        return ''; # last resort
    }

    use Intl::CLDR::Util::StrEncode;


    # Not all calendars have 13 months
    # but &fallback will return '' for 13 if not
    for 1 .. 4 -> $quarter-id {
        $result ~= StrEncode::get(fallback $quarter-id);
    }

    $result
}
method parse(\base, \xml) {
    use Intl::CLDR::Util::XML-Helper;
    base{.<type>} = contents $_ for xml.&elems('quarter')
}
#>>>>> # GENERATOR
