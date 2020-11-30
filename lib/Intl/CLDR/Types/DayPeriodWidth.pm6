use Intl::CLDR::Immutability;


unit class CLDR-DayPeriodWidth is CLDR-Item;

has $!parent;
has Str $.noon;       #= The special name of 12:00 noon
has Str $.midnight;   #= The special name of 0:00/24:00 midnight
has Str $.am;         #= The generic term for times before noon
has Str $.pm;         #= The generic term for times after noon
has Str $.morning1;   #= The name for an (early) morning period
has Str $.morning2;   #= The name for a (late) morning period
has Str $.afternoon1; #= The name for an (early) afternoon period
has Str $.afternoon2; #= The name for a (late) afternoon period
has Str $.evening1;   #= The name for an (early) evening period
has Str $.evening2;   #= The name for a (late) evening period
has Str $.night1;     #= The name for an (early) night period
has Str $.night2;     #= The name for a (late) night period

#| Creates a new CLDR-Dates object
method new(|c) {
    self.bless!bind-init: |c;
}

submethod !bind-init(\blob, uint64 $offset is rw, \parent) {
    $!parent := parent;

    self.Hash::BIND-KEY: 'am',         $!am;
    self.Hash::BIND-KEY: 'pm',         $!pm;
    self.Hash::BIND-KEY: 'noon',       $!noon;
    self.Hash::BIND-KEY: 'midnight',   $!midnight;
    self.Hash::BIND-KEY: 'morning1',   $!morning1;
    self.Hash::BIND-KEY: 'morning2',   $!morning2;
    self.Hash::BIND-KEY: 'afternoon1', $!afternoon1;
    self.Hash::BIND-KEY: 'afternoon2', $!afternoon2;
    self.Hash::BIND-KEY: 'evening1',   $!evening1;
    self.Hash::BIND-KEY: 'evening2',   $!evening2;
    self.Hash::BIND-KEY: 'night1',     $!night1;
    self.Hash::BIND-KEY: 'night2',     $!night2;

    use Intl::CLDR::Classes::StrDecode;

    $!am         = StrDecode::get(blob, $offset);
    $!pm         = StrDecode::get(blob, $offset);
    $!noon       = StrDecode::get(blob, $offset);
    $!midnight   = StrDecode::get(blob, $offset);
    $!morning1   = StrDecode::get(blob, $offset);
    $!morning2   = StrDecode::get(blob, $offset);
    $!afternoon1 = StrDecode::get(blob, $offset);
    $!afternoon2 = StrDecode::get(blob, $offset);
    $!evening1   = StrDecode::get(blob, $offset);
    $!evening2   = StrDecode::get(blob, $offset);
    $!night1     = StrDecode::get(blob, $offset);
    $!night2     = StrDecode::get(blob, $offset);

    self
}

##`<<<<< # GENERATOR: This method should only be uncommented out by the parsing script
method encode(\hash) {
    my $result = buf8.new;
    # Fallback patterns are rather complex.  I try to make this code as presentable as possible.
    # Currently, the fallbacks here are identical across all calendar types, if making any changes
    # ensure that all files follow suit, or that there are real differences.

    # Within a month context, the rules are defined in root.xml
    sub context (%d #`[dayperiod], $id) {
        do given $*day-period-context, $*day-period-width {
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
            .return with context (%*calendars{$type}<dayPeriods> // Hash), $id;
        }
        return ''; # last resort
    }

    use Intl::CLDR::Classes::StrEncode;

    $result ~= StrEncode::get(fallback 'am');
    $result ~= StrEncode::get(fallback 'pm');
    $result ~= StrEncode::get(fallback 'noon');
    $result ~= StrEncode::get(fallback 'midnight');
    $result ~= StrEncode::get(fallback 'morning1');
    $result ~= StrEncode::get(fallback 'morning2');
    $result ~= StrEncode::get(fallback 'afternoon1');
    $result ~= StrEncode::get(fallback 'afternoon2');
    $result ~= StrEncode::get(fallback 'evening1');
    $result ~= StrEncode::get(fallback 'evening2');
    $result ~= StrEncode::get(fallback 'night1');
    $result ~= StrEncode::get(fallback 'night2');

    $result;
}
#>>>>> # GENERATOR