use Intl::CLDR::Immutability;

unit class CLDR-EraWidth is CLDR-Ordered is CLDR-Item;

has $!parent;

#| Creates a new CLDR-EraWidth object
method new(|c) {
    self.bless!bind-init: |c;
}

submethod !bind-init(\blob, uint64 $offset is rw, \parent) {
    $!parent := parent;

    # Different calendars have different numbers, first encoded number is the era count
    my $eras = blob[$offset++];

    use Intl::CLDR::Classes::StrDecode;

    for ^$eras -> \id {
        my \text = StrDecode::get(blob, $offset);
        self.Array::BIND-POS: id, text;
        self.Hash::BIND-KEY:  id, text;
    }

    self
}

##`<<<<< # GENERATOR: This method should only be uncommented out by the parsing script
method encode(\hash) {
    my $result = buf8.new;
    # Fallback patterns are rather complex.  I try to make this code as presentable as possible.
    # Currently, the fallbacks here are identical across all calendar types, if making any changes
    # ensure that all files follow suit, or that there are real differences.

    # Within an era context, the rules are defined in root.xml
    sub context (%m #`[months], $id) {
        do given $*era-width {
            when 'wide'         { %m<wide       >{$id} // %m<abbreviated>{$id} }
            when 'abbreviated'  { %m<abbreviated>{$id}                         }
            when 'narrow'       { %m<narrow     >{$id} // %m<abbreviated>{$id} }
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
            when 'dangi'       { <dangi    chinese>           } # no generic fallback for dangi
            when 'chinese'     { <chinese>                    } # no generic fallback for chinese
            when /^'islamic-'/ { $*calendar-type, 'islamic','generic' }
            default            { $*calendar-type, 'generic' }
        }

        for @try -> $type {
            .return with context (%*calendars{$type}<eras> // Hash), $id;
        }
        return ''; # last resort
    }

    use Intl::CLDR::Classes::StrEncode;

    # Calendars have a variable number of eras.  This obviously complicates
    # processing because there's no great best way to determine how many to search for.
    #
    # Number of eras = japanese 236 [ 0 .. 236 ]
    #                  islamic 1    [ 0 ]
    #                  persian 1    [ 0 ]
    #                  roc 2        [ 0 .. 1 ]
    #                  hebrew 1     [ 0 ]
    #                  indian 1     [ 0 ]
    #                  generic 2    [ 0 .. 1 ]
    #                  ethiopic 2   [ 0 .. 1 ]
    #                  ethiopic-amete 1 [ 0 ]
    #                  coptic 2 [ 0 .. 1 ]
    # chinese 0 [ Empty ][ calculated, so currently 2 until we figure out how to handle it ]

    my $eras = do given $*calendar-type {
        when 'japanese'  { 237 }
        when 'roc'       {   2 }
        when 'ethiopic'  {   2 }
        when 'coptic'    {   2 }
        when 'gregorian' {   2 }
        default          {   1 } # chinese should technically be 0, but it's computed and shouldn't be used anyways
    };

    $result ~= buf8.new($eras); # record the count.
                                # Will need to increase to two bytes after Japan has 20 more emperors lol
    for ^$eras -> $era-id {
        $result ~= StrEncode::get(fallback $era-id);
    }
    $result;

}
#>>>>> # GENERATOR
