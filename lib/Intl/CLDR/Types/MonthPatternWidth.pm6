use Intl::CLDR::Immutability;

unit class CLDR-MonthPatternWidth is CLDR-Item;

has     $!parent;
has Str $.leap;
has Str $.after-leap; #= The 'standardAfterLeap' from CLDR
has Str $.combined;

#| Creates a new CLDR-MonthContext object
method new(|c) {
    self.bless!bind-init: |c;
}

submethod !bind-init(\blob, uint64 $offset is rw, \parent) {
    $!parent := parent;

    self.Hash::BIND-KEY: 'leap',                $!leap;
    self.Hash::BIND-KEY: 'standardAfterLeap',   $!after-leap;
    self.Hash::BIND-KEY: 'after-leap',          $!after-leap;
    self.Hash::BIND-KEY: 'standard-after-leap', $!after-leap;
    self.Hash::BIND-KEY: 'afterLeap',           $!after-leap;
    self.Hash::BIND-KEY: 'combined',            $!combined;

    use Intl::CLDR::Util::StrDecode;

    $!leap       = StrDecode::get(blob, $offset);
    $!after-leap = StrDecode::get(blob, $offset);
    $!combined   = StrDecode::get(blob, $offset);

    self
}

##`<<<<<#GENERATOR: This method should only be uncommented out by the parsing script
method encode(\hash) {

    my $result = buf8.new;
    # Fallback patterns are rather complex.  I try to make this code as presentable as possible.
    # Currently, the fallbacks here are virtually identical across all calendar types, if making any
    # changes ensure that all files follow suit, or that there are real differences.

    # Within a month pattern context, the rules are defined in root.xml
    # (type numeric/all is exclusive to pattern context)
    sub context (%m #`[monthsPatterns], $id) {
        do given $*month-pattern-context, $*month-pattern-width {
            when 'stand-alone', 'wide'         { %m<stand-alone><wide       >{$id} // %m<format     ><wide       >{$id}                          }
            when 'stand-alone', 'abbreviated'  { %m<stand-alone><abbreviated>{$id} // %m<format     ><abbreviated>{$id} // %m<format><wide>{$id} }
            when 'stand-alone', 'narrow'       { %m<stand-alone><narrow     >{$id}                                                               }
            when 'format',      'wide'         { %m<format     ><wide       >{$id}                                                               }
            when 'format',      'abbreviated'  { %m<format     ><abbreviated>{$id} // %m<format     ><wide        >{$id}                         }
            when 'format',      'narrow'       { %m<format     ><narrow     >{$id} // %m<stand-alone><narrow      >{$id}                         }
            when 'numeric',     'all'          { %m<numeric    ><all        >{$id}                                                               }
        } || Nil
    }

    # If the above search fails, then we need to change calendars per
    # http://cldr.unicode.org/development/development-process/design-proposals/generic-calendar-data
    # For month pattern context, data should only be available for chinese and maybe indian calendars
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
            .return with context (%*calendars{$type}<monthPatterns> // Hash), $id;
        }
        return ''; # last resort
    }

    use Intl::CLDR::Util::StrEncode;

    # Most calendars will have no values for these
    for <leap standardAfterLeap combined> -> $pattern-id {
        $result ~= StrEncode::get(fallback $pattern-id);
    }

    $result
}
method parse(\base, \xml) {
    use Intl::CLDR::Util::XML-Helper;
    base{.<type>} = contents $_ for xml.&elems('month')
}
#>>>>>#GENERATOR
