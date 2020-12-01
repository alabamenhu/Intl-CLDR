use Intl::CLDR::Immutability;

unit class CLDR-CyclicNameWidth is CLDR-Ordered is CLDR-Item;

has                 $!parent;

#| Creates a new CLDR-CyclicNameWidth object
method new(|c) {
    self.bless!bind-init: |c;
}

submethod !bind-init(\blob, uint64 $offset is rw, \parent) {
    $!parent := parent;

    my $cycles = blob[$offset++];

    use Intl::CLDR::Classes::StrDecode;

    for 1 .. $cycles -> $id {
        my \text = StrDecode::get(blob, $offset);
        self.Array::BIND-POS: $id, text;
        self.Hash::BIND-KEY:  $id, text;
    }

    self
}

##`<<<<< # GENERATOR: This method should only be uncommented out by the parsing script
method encode(\hash) {
    my $result = buf8.new;

    # Fallback patterns are rather complex.  I try to make this code as presentable as possible.
    # Currently, the fallbacks here are virtually identical across all calendar types, if making any
    # changes ensure that all files follow suit, or that there are real differences.

    # Within a cyclic name pattern context, the rules are defined in root.xml
    # (type numeric/all is exclusive to pattern context)
    # Note that in this case, narrow falls back to abbreviated, and that stand-alone appears to not exist in root,
    # so it will fallback identically to format, and then fall back as its format sibling would
    sub context (%c #`[cyclicNames], $id) {
        do given $*cyclic-name-context, $*cyclic-name-width {
            when 'stand-alone', 'wide'        { %c<stand-alone><wide>{$id} // %c<stand-alone><abbreviated>{$id} // %c<format><wide>{$id} // %c<format><abbreviated>{$id} }
            when 'stand-alone', 'abbreviated' { %c<stand-alone><abbreviated>{$id} // %c<format><abbreviated>{$id} }
            when 'stand-alone', 'narrow'      { %c<stand-alone><narrow>{$id} // %c<stand-alone><abbreviated>{$id} // %c<format><narrow>{$id} // %c<format><abbreviated>{$id} }
            when 'format', 'wide'             { %c<format><wide>{$id} // %c<format><abbreviated>{$id} }
            when 'format', 'abbreviated'      { %c<format><abbreviated>{$id} }
            when 'format', 'narrow'           { %c<format><narrow>{$id} // %c<format><abbreviated>{$id} }
        } || Nil
    }

    # Different to other fields, there are different sets.  So after exhausting the context,
    # sets are shifted around before fiddling with calendars.  Annoying, but it is what it is.
    sub set (%sets, $id) {
        my @try = do given $*cyclic-name-set {
            when 'zodiac' { <zodiac dayParts> }
            when 'days' { <days   years> }
            when 'months' { <months years> }
            default { $*cyclic-name-set }
            # no fall back, explicit in root
        }

        for @try -> $type {
            .return with context (%sets{$type} // Hash), $id;
        }
        return Nil;
    }

    # If the above search fails, then we need to change calendars per
    # http://cldr.unicode.org/development/development-process/design-proposals/generic-calendar-data
    # For month pattern context, data should only be available for chinese and maybe indian calendars
    sub fallback ($id) {
        my @try = do given $*calendar-type {
            when 'dangi' { <dangi    chinese   generic> }
            when 'chinese' { <chinese generic> }
            default { 'generic' }
            # which is to say, nothing.
        }

        for @try -> $type {
            .return with set (%*calendars{$type}<cyclicNameSets> // Hash), $id;
        }
        return '';
        # last resort
    }


    my $cycles = do given $*cyclic-name-set {
        when any <years days months> { 60 }
        when any <zodiac dayParts>   { 12 }
        when 'solarTerms'            { 24 }
    };

    use Intl::CLDR::Classes::StrEncode;

    # Variable number, so store it
    $result ~= buf8.new($cycles);

    for 1 .. $cycles -> $id {
        $result ~= StrEncode::get( fallback $id )
    }

    $result;

}
method parse(\base, \xml) {
    use Intl::CLDR::Util::XML-Helper;
    base{.<type>} = contents $_ for xml.&elems('cyclicName');
}
#>>>>> # GENERATOR
