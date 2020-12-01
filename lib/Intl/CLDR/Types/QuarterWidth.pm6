use Intl::CLDR::Immutability;

unit class CLDR-QuarterWidth is CLDR-Ordered is CLDR-Item;

has                 $!parent;

#| Creates a new CLDR-QuarterContext object
method new(|c) {
    self.bless!bind-init: |c;
}

submethod !bind-init(\blob, uint64 $offset is rw, \parent) {
    $!parent := parent;

    use Intl::CLDR::Classes::StrDecode;

    for 1..4 -> \id {
        my \text = StrDecode::get(blob, $offset);
        self.Array::BIND-POS: id, text;
        self.Hash::BIND-KEY:  id, text;
    }

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

    use Intl::CLDR::Classes::StrEncode;


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
