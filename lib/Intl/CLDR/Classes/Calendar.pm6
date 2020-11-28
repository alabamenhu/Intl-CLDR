unit module Calendar;
use Intl::CLDR::Immutability;

=begin pod
Each calendar class follows the same format:

   - Subclass of CLDR-Item
   - $!parent attribute plus attributes for each child
   - a new method that is exactly:
         method new ($parent?) { self.bless!bind-init: $parent }
   - a !bind-init submethod that binds each attribute to CLDR-named keys, e.g.
         self.Hash::BIND-KEY: 'foo', $!foo;
         self; # must return self
   - a multimethod ADD-TO-DATABASE (@branch, $offset) that defines objects if they don't already exist.  Looks like
          my $key = @branch[$offset];
          unless self.Hash::AT-KEY($key) {
              given $key {
                  when 'foo' { $!foo = CLDR-Foo.new: self }
                  when 'bar' { $!bar = CLDR-Bar.new: self }
                  default    { #`(default condition)`
              }
          }

Optionally, they may also have

   - a method AT-KEY, that will handle fallbacks
   - a method


All are subclasses of CLDR-Item (itself a subclass of Hash), but when they have an ordered set of elements
(e.g. months/days-of-week), then they also are subclasses of CLDR-Ordered (a subclass of Array).  If subclassing
both, CLDR-Ordered should take precedence, e.g.

    class Foo is CLDR-Ordered is CLDR-Item is export { ... }

At their core, these are more list-y than they are hash-y, so it ensures that any shared methods between
Hash and Array prefer the Array one and preserve DWIM.
See descriptions for each one -- I am currently working to add in proper POD documentation to aid in IDEs
=end pod

# Note that the fall backs are not optimized.  They should go ahead and bind results.

#    ╔╦╗  ╔═╗  ╦ ╦      ╔═╗  ╔═╗  ╦═╗  ╦  ╔═╗  ╔╦╗  ╔═╗
#     ║║  ╠═╣  ╚╦╝      ╠═╝  ║╣   ╠╦╝  ║  ║ ║   ║║  ╚═╗
#    ═╩╝  ╩ ╩   ╩       ╩    ╚═╝  ╩╚═  ╩  ╚═╝  ═╩╝  ╚═╝

#| A set of names for day periods for a given width (am, pm, noon, midnight, morning1, morning2,
#| afternoon1, afternoon2, evening1, evening2, night1, night2)
class CLDR-DayPeriodWidth is CLDR-Item is export {
    has $!parent;     #= The CLDR parent object
    has $.noon;       #= The special name of noon
    has $.midnight;   #= The special name of 12:00 midnight
    has $.am;         #= The generic term for times before noon
    has $.pm;         #= The generic term for times after noon
    has $.morning1;   #= The name for an (early) morning period
    has $.morning2;   #= The name for a (late) morning period
    has $.afternoon1; #= The name for an (early) afternoon period
    has $.afternoon2; #= The name for a (late) afternoon period
    has $.evening1;   #= The name for an (early) evening period
    has $.evening2;   #= The name for a (late) evening period
    has $.night1;     #= The name for an (early) night period
    has $.night2;     #= The name for a (late) night period

    method new ($parent?) { self.bless!bind-init: $parent }
    submethod !bind-init ($parent) {
        $!parent = $parent;
        self.Hash::BIND-KEY: 'noon',       $!noon;
        self.Hash::BIND-KEY: 'midnight',   $!midnight;
        self.Hash::BIND-KEY: 'am',         $!am;
        self.Hash::BIND-KEY: 'pm',         $!pm;
        self.Hash::BIND-KEY: 'morning1',   $!morning1;
        self.Hash::BIND-KEY: 'morning2',   $!morning2;
        self.Hash::BIND-KEY: 'afternoon1', $!afternoon1;
        self.Hash::BIND-KEY: 'afternoon2', $!afternoon2;
        self.Hash::BIND-KEY: 'evening1',   $!evening1;
        self.Hash::BIND-KEY: 'evening2',   $!evening2;
        self.Hash::BIND-KEY: 'night1',     $!night1;
        self.Hash::BIND-KEY: 'night2',     $!night2;
        self;
    }
    multi method ADD-TO-DATABASE(@branch, $offset = @branch - 1) {
        self.Hash::ASSIGN-KEY: @branch[1], @branch[0]
    }
}


#| A set of name lengths for day periods for a given context (narrow, wide, or abbreviated)
class CLDR-DayPeriodContext is CLDR-Item is export {
    has $!parent;
    has $.narrow;
    has $.abbreviated;
    has $.wide;

    method new ($parent?) { self.bless!bind-init: $parent }
    submethod !bind-init ($parent) {
        $!parent = $parent;
        self.Hash::BIND-KEY: 'narrow',      $!narrow;
        self.Hash::BIND-KEY: 'abbreviated', $!abbreviated;
        self.Hash::BIND-KEY: 'wide',        $!wide;
        self;
    }
    multi method ADD-TO-DATABASE(@branch, $offset = @branch - 1) {
        self.Hash::ASSIGN-KEY: @branch[1], @branch[0]
                andthen return if $offset == 1;

        my $key = @branch[$offset];
        unless self.Hash::AT-KEY($key) {
            given $key {
                when 'narrow'      { $!narrow      = CLDR-DayPeriodWidth.new: self }
                when 'abbreviated' { $!abbreviated = CLDR-DayPeriodWidth.new: self }
                when 'wide'        { $!wide        = CLDR-DayPeriodWidth.new: self }
                default            { self.Hash::ASSIGN-KEY: $key, CLDR-Item.new }
            }
        }

        self.Hash::AT-KEY($key).ADD-TO-DATABASE: @branch, $offset - 1
    }
    method NEW-ITEM(|) { CLDR-DayPeriodWidth.new }
}

#| A set of contexts for the day periods in a given calendar (stand-alone or format)
# Last resorts should be handled here, I think.
class CLDR-DayPeriods is CLDR-Item is export {
    has $!parent;
    has $.stand-alone;
    has $.format;

    method new ($parent?) { self.bless!bind-init: $parent }
    submethod !bind-init ($parent) {
        $!parent = $parent;
        self.Hash::BIND-KEY: 'stand-alone', $!stand-alone;
        self.Hash::BIND-KEY: 'standAlone',  $!stand-alone;
        self.Hash::BIND-KEY: 'format',      $!format;
        self
    }
    multi method ADD-TO-DATABASE(@branch, $offset = @branch - 1) {
        self.Hash::ASSIGN-KEY: @branch[1], @branch[0]
                andthen return if $offset == 1;

        my $key = @branch[$offset];
        unless self.Hash::AT-KEY($key) {
            given $key {
                when 'stand-alone' { $!stand-alone = CLDR-DayPeriodContext.new }
                when 'format'      { $!format      = CLDR-DayPeriodContext.new }
                default            { self.Hash::ASSIGN-KEY: $key, CLDR-Item.new }
            }
        }
        self.Hash::AT-KEY($key).ADD-TO-DATABASE: @branch, $offset - 1
    }
}


#    ╔╦╗  ╔═╗  ╦ ╦  ╔═╗
#     ║║  ╠═╣  ╚╦╝  ╚═╗
#    ═╩╝  ╩ ╩   ╩   ╚═╝

#| An ordered list of day names for a given width (1-indexed)
class CLDR-DayWidth is CLDR-Ordered is CLDR-Item is export {
  has $!parent;
  #| Creates a new day width.
  method new ($parent?) { self.bless!bind-init: $parent }
  submethod !bind-init ($parent) {
    $!parent = $parent;
    self;
  }

  # Should only ever get two elements here
  multi method ADD-TO-DATABASE(+@branch) { self.Array::ASSIGN-POS: +@branch[1], @branch[0] }

  method AT-KEY($key)     { self.Array::AT-POS:     +$key }
  method EXISTS-KEY($key) { self.Array::EXISTS-POS: +$key }
}

#| A set of name lengths for days for a given context (narrow, wide, or abbreviated)
class CLDR-DayContext is CLDR-Item is export {
  has $!parent;
  has $.narrow;
  has $.abbreviated;
  has $.wide;

  method new ($parent?) { self.bless!bind-init: $parent }
  submethod !bind-init ($parent) {
    $!parent = $parent;
    self.Hash::BIND-KEY: 'narrow',      $!narrow;
    self.Hash::BIND-KEY: 'abbreviated', $!abbreviated;
    self.Hash::BIND-KEY: 'wide',        $!wide;
    self;
  }
  multi method ADD-TO-DATABASE(@branch, $offset = @branch - 1) {
    self.Hash::ASSIGN-KEY: @branch[1], @branch[0]
            andthen return if $offset == 1;

    my $key = @branch[$offset];
    unless self.Hash::AT-KEY($key) {
      given $key {
        when 'narrow'      { $!narrow      = CLDR-DayWidth.new: self }
        when 'abbreviated' { $!abbreviated = CLDR-DayWidth.new: self }
        when 'wide'        { $!wide        = CLDR-DayWidth.new: self }
        default            { self.Hash::ASSIGN-KEY: $key, CLDR-Item.new }
      }
    }

    self.Hash::AT-KEY($key).ADD-TO-DATABASE: @branch, $offset - 1
  }
  method NEW-ITEM(|) { CLDR-DayWidth.new }
}

#| A set of contexts for the days in a given calendar (stand-alone or format)
class CLDR-Days is CLDR-Item is export {
  has $!parent;
  has $.stand-alone;
  has $.format;

  method new ($parent?) { self.bless!bind-init: $parent }
  submethod !bind-init ($parent) {
    $!parent = $parent;
    self.Hash::BIND-KEY: 'stand-alone', $!stand-alone;
    self.Hash::BIND-KEY: 'standAlone',  $!stand-alone;
    self.Hash::BIND-KEY: 'format',      $!format;
    self
  }
  multi method ADD-TO-DATABASE(@branch, $offset = @branch - 1) {
    self.Hash::ASSIGN-KEY: @branch[1], @branch[0]
        andthen return if $offset == 1;

    my $key = @branch[$offset];
    unless self.Hash::AT-KEY($key) {
      given $key {
        when 'stand-alone' { $!stand-alone = CLDR-DayContext.new }
        when 'format'      { $!format      = CLDR-DayContext.new }
        default            { self.Hash::ASSIGN-KEY: $key, CLDR-Item.new }
      }
    }
    self.Hash::AT-KEY($key).ADD-TO-DATABASE: @branch, $offset - 1
  }
}


#   ╔╦╗  ╔═╗  ╔╗╔  ╔╦╗  ╦ ╦  ╔═╗
#   ║║║  ║ ║  ║║║   ║   ╠═╣  ╚═╗
#   ╩ ╩  ╚═╝  ╝╚╝   ╩   ╩ ╩  ╚═╝

#| An ordered list of month names for a given width (1-indexed).
class CLDR-MonthWidth is CLDR-Ordered is CLDR-Item is export {
  # Not all of the calendars have 12 months.
  # Associative access coerces to number and finds position.
  has $!parent;

  #| Creates a new month width.
  method new ($parent?) { self.bless!bind-init: $parent }
  submethod !bind-init ($parent) {
    $!parent = $parent; # The parent (a month context)
    self;
  }

  # Should only ever get two elements here
  multi method ADD-TO-DATABASE(@branch, $offset = @branch - 1) {
    self.Hash::ASSIGN-POS: +@branch[1], @branch[0]
        andthen return if $offset == 1;

    die "Unexpected item found.  Month names cannot have child items."
  }
}

#| A set of name lengths for months for a given context (narrow, wide, or abbreviated).
class CLDR-MonthContext is CLDR-Item is export {
  has $!parent;
  has $.narrow;
  has $.abbreviated;
  has $.wide;

  method new ($parent?) { self.bless!bind-init: $parent }
  submethod !bind-init ($parent) {
    $!parent = $parent;
    self.Hash::BIND-KEY: 'narrow',      $!narrow;
    self.Hash::BIND-KEY: 'abbreviated', $!abbreviated;
    self.Hash::BIND-KEY: 'wide',        $!wide;
    self;
  }
  method ADD-TO-DATABASE(@branch, $offset = @branch - 1) {
    self.Hash::ASSIGN-KEY(@branch[1], @branch[0])
            andthen return if $offset == 1;

    my $key = @branch[$offset];
    unless self.Hash::AT-KEY($key) {
      given $key {
        when 'narrow'      { $!narrow      = CLDR-MonthWidth.new }
        when 'abbreviated' { $!abbreviated = CLDR-MonthWidth.new }
        when 'wide'        { $!wide        = CLDR-MonthWidth.new }
        default            { self.Hash::ASSIGN-KEY: $key, CLDR-Item.new }
      }
    }
    self.Hash::AT-KEY($key).ADD-TO-DATABASE: @branch, $offset - 1
  }

  method NEW-ITEM(|) { CLDR-MonthWidth.new}
}

#| A set of contexts for the months in a given calendar (stand-alone or format).
class CLDR-Months is CLDR-Item is export {
  has $!parent;
  has $.stand-alone;
  has $.format;

  method new ($parent?) { self.bless!bind-init: $parent }
  submethod !bind-init ($parent) {
    $!parent = $parent;
    self.Hash::BIND-KEY: 'stand-alone', $!stand-alone;
    self.Hash::BIND-KEY: 'standAlone',  $!stand-alone;
    self.Hash::BIND-KEY: 'format',      $!format;
    self
  }

  method ADD-TO-DATABASE(@branch, $offset = @branch - 1) {
    self.Hash::ASSIGN-KEY(@branch[1], @branch[0])
            andthen return if $offset == 1;

    my $key = @branch[$offset];
    unless self.Hash::AT-KEY($key) {
      given $key {
        when 'stand-alone' { $!stand-alone     = CLDR-MonthContext.new          }
        when 'format'      { $!format          = CLDR-MonthContext.new          }
        default            { self.Hash::ASSIGN-KEY: $key, CLDR-Item.new }
      }
    }
    self.Hash::AT-KEY($key).ADD-TO-DATABASE: @branch, $offset - 1
  }

  # This is the fallback
  #my %lr-months := BEGIN {
  #  my %h := CLDR-MonthWidth.new;
  #  %h.ADD-TO-DATABASE($_, ($_ < 10 ?? '0' !! '') ~ $_) for 1..13;
  #  %h
  #};
  method AT-KEY(*@keys) { self.CLDR-Item::AT-KEY(|@keys) }
}

#   ╔═╗   ╦ ╦  ╔═╗  ╦═╗  ╔╦╗  ╔═╗  ╦═╗  ╔═╗
#   ║═╬╗  ║ ║  ╠═╣  ╠╦╝   ║   ║╣   ╠╦╝  ╚═╗
#   ╚═╝╚  ╚═╝  ╩ ╩  ╩╚═   ╩   ╚═╝  ╩╚═  ╚═╝

#| An ordered list of quarter names for a given width (1-indexed).
class CLDR-QuarterWidth is CLDR-Ordered is CLDR-Item is export {
  # Associative access coerces to number and finds position.
  has $!parent;

  #| Creates a new quarter width.
  method new ($parent?) { self.bless!bind-init: $parent }
  submethod !bind-init ($parent) {
    $!parent = $parent; # The parent (a month context)
    self;
  }

  # Should only ever get two elements here
  multi method ADD-TO-DATABASE(@branch, $offset = @branch - 1) {
    self.Hash::ASSIGN-POS: +@branch[1], @branch[0]
            andthen return if $offset == 1;

    die "Unexpected item found.  Month names cannot have child items."
  }
}

#| A set of name lengths for quarters for a given context (narrow, wide, or abbreviated).
class CLDR-QuarterContext is CLDR-Item is export {
  has $!parent;
  has $.narrow;
  has $.abbreviated;
  has $.wide;

  method new ($parent?) { self.bless!bind-init: $parent }
  submethod !bind-init ($parent) {
    $!parent = $parent;
    self.Hash::BIND-KEY: 'narrow',      $!narrow;
    self.Hash::BIND-KEY: 'abbreviated', $!abbreviated;
    self.Hash::BIND-KEY: 'wide',        $!wide;
    self;
  }
  method ADD-TO-DATABASE(@branch, $offset = @branch - 1) {
    self.Hash::ASSIGN-KEY(@branch[1], @branch[0])
            andthen return if $offset == 1;

    my $key = @branch[$offset];
    unless self.Hash::AT-KEY($key) {
      given $key {
        when 'narrow'      { $!narrow      = CLDR-QuarterWidth.new }
        when 'abbreviated' { $!abbreviated = CLDR-QuarterWidth.new }
        when 'wide'        { $!wide        = CLDR-QuarterWidth.new }
        default            { self.Hash::ASSIGN-KEY: $key, CLDR-Item.new }
      }
    }
    self.Hash::AT-KEY($key).ADD-TO-DATABASE: @branch, $offset - 1
  }

  method NEW-ITEM(|) { CLDR-MonthWidth.new       }
}

#| A set of contexts for the quarters in a given calendar (stand-alone or format).
class CLDR-Quarters             is CLDR-Item is export {
  has $!parent;
  has $.stand-alone;
  has $.format;

  method new ($parent?) { self.bless!bind-init: $parent }
  submethod !bind-init ($parent) {
    $!parent = $parent;
    self.Hash::BIND-KEY: 'stand-alone', $!stand-alone;
    self.Hash::BIND-KEY: 'standAlone',  $!stand-alone;
    self.Hash::BIND-KEY: 'format',      $!format;
    self
  }

  method ADD-TO-DATABASE(@branch, $offset = @branch - 1) {
    self.Hash::ASSIGN-KEY(@branch[1], @branch[0])
            andthen return if $offset == 1;

    my $key = @branch[$offset];
    unless self.Hash::AT-KEY($key) {
      given $key {
        when 'stand-alone' { $!stand-alone     = CLDR-QuarterContext.new          }
        when 'format'      { $!format          = CLDR-QuarterContext.new          }
        default            { self.Hash::ASSIGN-KEY: $key, CLDR-Item.new }
      }
    }
    self.Hash::AT-KEY($key).ADD-TO-DATABASE: @branch, $offset - 1
  }


#  my %lr-quarters := BEGIN { my %h := CLDR-QuarterWidth.new; %h.ADD-TO-DATABASE($_, ~$_)                         for 1..4;  %h};
  method AT-KEY(*@keys) {
    self.CLDR-Item::AT-KEY(|@keys)
  }
}

#    ╔═╗  ╦═╗  ╔═╗  ╔═╗
#    ║╣   ╠╦╝  ╠═╣  ╚═╗
#    ╚═╝  ╩╚═  ╩ ╩  ╚═╝

#| An ordered list of era names for a given width (0-indexed)
class CLDR-EraWidth is CLDR-Ordered is CLDR-Item is export {
  # Calendars vary in the number of eras that they have substantially.
  # Associative access coerces to number and finds position.

  has $!parent; #= The era that contains this era width

  #| Creates a new month width.
  method new ($parent?) { self.bless!bind-init: $parent }
  submethod !bind-init ($parent) {
    $!parent = $parent; # The parent (an era width)
    self;
  }

  # Should only ever get two elements here
  multi method ADD-TO-DATABASE(@branch, $offset = @branch - 1) {
    self.Hash::ASSIGN-POS: +@branch[1], @branch[0]
            andthen return if $offset == 1;

    die "Unexpected item found.  Era names cannot have child items."
  }
}

#| Set of name widths for eras in a given calendar
class CLDR-Eras is CLDR-Item is export {
  # Different calendars have very different numbers of eras
  has               $!parent;
  has CLDR-EraWidth $.narrow;
  has CLDR-EraWidth $.abbreviated;
  has CLDR-EraWidth $.wide;

  #| Creates a new era collection.
  method new ($parent?) { self.bless!bind-init: $parent }
  submethod !bind-init ($parent) {
    $!parent = $parent; # The parent (a month context)
    self;
  }

  multi method ADD-TO-DATABASE(@branch, $offset = @branch - 1) {
    self.Hash::ASSIGN-KEY: @branch[1], @branch[0]
            andthen return if $offset == 1;

    my $key = @branch[$offset];
    unless self.Hash::AT-KEY($key) {
      given $key {
        when 'narrow'      { $!narrow      = CLDR-EraWidth.new }
        when 'abbreviated' { $!abbreviated = CLDR-EraWidth.new }
        when 'wide'        { $!wide        = CLDR-EraWidth.new }
        default            { self.Hash::ASSIGN-KEY: $key, CLDR-Item.new }
      }
    }
    self.Hash::AT-KEY($key).ADD-TO-DATABASE: @branch, $offset - 1
  }

  method NEW-ITEM(|) { CLDR-EraWidth.new }
  #my %lr-eras     := BEGIN { my %h := CLDR-EraWidth.new;     %h.ADD-TO-DATABASE(0, 'BC'); %h.ADD-TO-DATABASE(1, 'AD');      %h};
  #method AT-KEY(|c)     { self.CLDR-Item::AT-KEY(c) // %lr-eras                                         } }
}

# For each of these formats, it's possible for there
class CLDR-DateFormat           is CLDR-Item is export { }
class CLDR-DateFormatLength     is CLDR-Item is export { }
class CLDR-TimeFormatLength     is CLDR-Item is export { }
class CLDR-DateTimeFormatLength is CLDR-Item is export { }
class CLDR-IntervalFormat       is CLDR-Item is export { }
class CLDR-AvailableFormats     is CLDR-Item is export { }
class CLDR-AppendItems          is CLDR-Item is export { }
class CLDR-DateFormats          is CLDR-Item is export { method NEW-ITEM(|) { CLDR-DateFormatLength.new     } }
class CLDR-TimeFormats          is CLDR-Item is export { method NEW-ITEM(|) { CLDR-TimeFormatLength.new     } }
class CLDR-DateTimeFormats      is CLDR-Item is export { method NEW-ITEM(|) { CLDR-DateTimeFormatLength.new } }
class CLDR-IntervalFormats      is CLDR-Item is export { method NEW-ITEM(|) { CLDR-IntervalFormat.new       } }

#| A collection of information for a calendar system
class CLDR-Calendar is CLDR-Item is export {
  has $!parent; #= The parent (a collection of calendars)
  has CLDR-Months           $.months;
  has CLDR-Quarters         $.quarters;
  has CLDR-Days             $.days;
  has CLDR-DayPeriods       $.day-periods;
  has CLDR-Eras             $.eras;
  has CLDR-DateFormats      $.date-formats;
  has CLDR-TimeFormats      $.time-formats;
  has CLDR-DateTimeFormats  $.datetime-formats;
  has CLDR-AvailableFormats $.available-formats;
  has CLDR-IntervalFormats  $.interval-formats;

  method new($parent?) {
    self.bless!bind-init: $parent;
  }
  submethod !bind-init($parent) {
    $!parent = $parent;
    self.Hash::BIND-KEY: 'months',            $!months;
    self.Hash::BIND-KEY: 'quarters',          $!quarters;
    self.Hash::BIND-KEY: 'days',              $!days;
    self.Hash::BIND-KEY: 'dayPeriods',        $!day-periods;
    self.Hash::BIND-KEY: 'day-periods',       $!day-periods;
    self.Hash::BIND-KEY: 'eras',              $!eras;
    self.Hash::BIND-KEY: 'date-formats',      $!date-formats;
    self.Hash::BIND-KEY: 'dateFormats',       $!date-formats;
    self.Hash::BIND-KEY: 'time-formats',      $!time-formats;
    self.Hash::BIND-KEY: 'timeFormats',       $!time-formats;
    self.Hash::BIND-KEY: 'datetime-formats',  $!datetime-formats;
    self.Hash::BIND-KEY: 'dateTimeFormats',   $!datetime-formats;
    self.Hash::BIND-KEY: 'available-formats', $!available-formats;
    self.Hash::BIND-KEY: 'availableFormats',  $!available-formats;
    self.Hash::BIND-KEY: 'interval-formats',  $!interval-formats;
    self.Hash::BIND-KEY: 'intervalFormats',   $!interval-formats;
    self;
  }
  method ADD-TO-DATABASE (@branch, $offset = @branch - 1) {
    my $key = @branch[$offset];
    unless self.Hash::AT-KEY($key) {
      given $key {
        when 'months'           { $!months            = CLDR-Months.new           }
        when 'quarters'         { $!quarters          = CLDR-Quarters.new         }
        when 'days'             { $!days              = CLDR-Days.new             }
        when 'dayPeriods'       { $!day-periods       = CLDR-DayPeriods.new       }
        when 'eras'             { $!eras              = CLDR-Eras.new             }
        when 'dateFormats'      { $!date-formats      = CLDR-DateFormats.new      }
        when 'timeFormats'      { $!time-formats      = CLDR-TimeFormats.new      }
        when 'dateTimeFormats'  { $!datetime-formats  = CLDR-DateTimeFormats.new  }
        when 'availableFormats' { $!available-formats = CLDR-AvailableFormats.new }
        when 'intervalFormats'  { $!interval-formats  = CLDR-IntervalFormats.new  }
        default                 { self.Hash::ASSIGN-KEY: $key, CLDR-Item.new      }
      }
    }

    self.Hash::AT-KEY($key).ADD-TO-DATABASE: @branch, $offset - 1
  }
}


#| A collection of calendars for a given language
class CLDR-Calendars is CLDR-Item is export {
  has               $!parent;               #= The object parent (a languages object)
  # The following calendars are currently included in CLDR.  Expand as necessary
  has CLDR-Calendar $.buddhist;             #= Buddhist calendar data
  has CLDR-Calendar $.chinese;              #= Chinese calendar data
  has CLDR-Calendar $.coptic;               #= Coptic calendar data
  has CLDR-Calendar $.ethiopic;             #= Ethiopic calendar (284 AD epoch) data
  has CLDR-Calendar $.ethiopic-amete-alem;  #= Ethiopic calendar (5493 BC epoch) data
  has CLDR-Calendar $.generic;              #= Generic, numbers-only calendar data
  has CLDR-Calendar $.gregorian;            #= Gregorian (civil) calendar data
  has CLDR-Calendar $.hebrew;               #= Hebrew calendar data
  has CLDR-Calendar $.indian;               #= Indian calendar data
  has CLDR-Calendar $.islamic;              #= Islamic calendar (generic) data
  has CLDR-Calendar $.islamic-civil;        #= Islamic calendar (Friday-epoch tabular) data
  has CLDR-Calendar $.islamic-rgsa;         #= Tabular Islamic (Thursday-epoch tabular) calendar data
  has CLDR-Calendar $.islamic-tbla;         #= Islamic calendar (Saudi Arabia-sighted) data
  has CLDR-Calendar $.islamic-umalqura;     #= Islamic calendar (Umm al-Qura) data
  has CLDR-Calendar $.japanese;             #= Japanese calendar data
  has CLDR-Calendar $.persian;              #= Persian calendar data
  has CLDR-Calendar $.roc;                  #= Taiwanese calendar data

  method new($parent?) {
    self.bless!bind-init: $parent;
  }
  submethod !bind-init($parent) {
    $!parent = $parent;
    self.Hash::BIND-KEY: 'buddhist',  $!buddhist;
    self.Hash::BIND-KEY: 'chinese',   $!chinese;
    self.Hash::BIND-KEY: 'coptic',    $!coptic;
    self.Hash::BIND-KEY: 'ethiopic',  $!ethiopic;
    self.Hash::BIND-KEY: 'generic',   $!generic;
    self.Hash::BIND-KEY: 'gregorian', $!gregorian;
    self.Hash::BIND-KEY: 'hebrew',    $!hebrew;
    self.Hash::BIND-KEY: 'indian',    $!indian;
    self.Hash::BIND-KEY: 'islamic',   $!islamic;
    self.Hash::BIND-KEY: 'japanese',  $!japanese;
    self.Hash::BIND-KEY: 'persian',   $!persian;
    self.Hash::BIND-KEY: 'roc',       $!roc;
    self;
  }

  method ADD-TO-DATABASE (@branch, $offset = @branch - 1) {
    #self.Hash::ASSIGN-KEY(@branch[1], @branch[0])
    #  andthen return if $offset == 1;

    my $key = @branch[$offset];
    unless self.Hash::AT-KEY($key) {
      given $key {
        when 'buddhist'  { $!buddhist  = CLDR-Calendar.new }
        when 'chinese'   { $!chinese   = CLDR-Calendar.new }
        when 'coptic'    { $!coptic    = CLDR-Calendar.new }
        when 'ethiopic'  { $!ethiopic  = CLDR-Calendar.new }
        when 'generic'   { $!generic   = CLDR-Calendar.new }
        when 'gregorian' { $!gregorian = CLDR-Calendar.new }
        when 'hebrew'    { $!hebrew    = CLDR-Calendar.new }
        when 'indian'    { $!indian    = CLDR-Calendar.new }
        when 'islamic'   { $!islamic   = CLDR-Calendar.new }
        when 'japanese'  { $!japanese  = CLDR-Calendar.new }
        when 'persian'   { $!persian   = CLDR-Calendar.new }
        when 'roc'       { $!roc       = CLDR-Calendar.new }
        default { self.Hash::ASSIGN-KEY: $key, CLDR-Item.new }
      }
    }

    self.Hash::AT-KEY($key).ADD-TO-DATABASE: @branch, $offset - 1
  }


  method NEW-ITEM(|) { CLDR-Calendar.new }
  # The fallback calendar is 'gregorian' but
  # TODO more complex selection logic, see DateFormatSymbols::initializeData @ dtfmtsym.cpp #2116-2155
  method AT-KEY(|c) {
    self.Hash::AT-KEY(c) || $!gregorian
  }
}




class CLDR-ZoneWidth is CLDR-Item {
    has $!parent;
    has Str $.generic;
    has Str $.standard;
    has Str $.daylight;
    method new($parent?) {
        self.bless!bind-init: $parent
    }
    submethod !bind-init($parent) {
        $!parent= $parent;
        self.Hash::BIND-KEY: 'generic',  $!generic;
        self.Hash::BIND-KEY: 'standard', $!standard;
        self.Hash::BIND-KEY: 'daylight', $!daylight;
        self
    }
    method ADD-TO-DATABASE(@branch, $offset = @branch - 1) {
        self.Hash::ASSIGN-KEY: @branch[1], @branch[0];
    }
}


class CLDR-Zone is CLDR-Item {
    has                $!parent;
    has Str            $.exemplar-city;
    has CLDR-ZoneWidth $.long;
    has CLDR-ZoneWidth $.short;
    method new($parent?) { self.bless!bind-init: $parent }
    submethod !bind-init($parent) {
        $!parent = $parent;
        self.Hash::BIND-KEY: 'exemplar-city', $!exemplar-city;
        self.Hash::BIND-KEY: 'exemplarCity',  $!exemplar-city;
        self.Hash::BIND-KEY: 'long',          $!long;
        self.Hash::BIND-KEY: 'short',         $!short;
        self
    }
    method ADD-TO-DATABASE(@branch, $offset = @branch - 1) {
        my $key = @branch[$offset];

        self.Hash::ASSIGN-KEY: $key, @branch[0]
            and return
                if $offset == 1;

        # Not terminal, so construct containers if necessary
        unless self.Hash::AT-KEY($key) {
            given $key {
                when 'long'  { $!long  = CLDR-ZoneWidth.new }
                when 'short' { $!short = CLDR-ZoneWidth.new }
                default { self.Hash::ASSIGN-KEY: $key, CLDR-Item.new }
            }
        }

        self.Hash::AT-KEY($key).ADD-TO-DATABASE: @branch, $offset - 1
    }
}

# Terminal class that just assigns.  Keys are potentially variable
# so no attributes are given.
class CLDR-Zones is CLDR-Item {
    has $!parent;
    method new($parent?) { self.bless!bind-init: $parent}
    submethod !bind-init($parent) { $!parent = $parent; self }
    method ADD-TO-DATABASE(@branch, $offset = @branch - 1) {
        my $key = @branch[$offset];
        self.Hash::ASSIGN-KEY: $key, CLDR-Item.new
            unless self.Hash::AT-KEY($key);
        self.Hash::AT-KEY($key).ADD-TO-DATABASE: @branch, $offset - 1
    }
}
# Identical to CLDR-Zones, just different name
class CLDR-Metazones is CLDR-Item {
    has $!parent;
    method new($parent?) { self.bless!bind-init: $parent}
    submethod !bind-init($parent) { $!parent = $parent; self }
    method ADD-TO-DATABASE(@branch, $offset = @branch - 1) {
        my $key = @branch[$offset];
        self.Hash::ASSIGN-KEY: $key, CLDR-Item.new
            unless self.Hash::AT-KEY($key);
        self.Hash::AT-KEY($key).ADD-TO-DATABASE: @branch, $offset - 1
    }
}

class CLDR-RegionFormat is CLDR-Item {
    has $!parent;
    has Str $.generic;
    has Str $.standard;
    has Str $.daylight;
    method new($parent?) {
        self.bless!bind-init: $parent
    }
    submethod !bind-init($parent) {
        $!parent= $parent;
        self.Hash::BIND-KEY: 'generic',  $!generic;
        self.Hash::BIND-KEY: 'standard', $!standard;
        self.Hash::BIND-KEY: 'daylight', $!daylight;
        self
    }
    method ADD-TO-DATABASE(@branch, $offset = @branch - 1) {
        self.Hash::ASSIGN-KEY: @branch[1], @branch[0];
    }
}


class CLDR-TimezoneNames is CLDR-Item is export {
    has                   $!parent;
    has Str               $.hour-format;
    has Str               $.gmt-format;
    has Str               $.gmt-zero-format;
    has Str               $.fallback-format;
    has CLDR-RegionFormat $.region-format;
    has CLDR-Zones        $.zones;
    has CLDR-Metazones    $.metazones;

    method new($parent?) {
        self.bless!bind-init: $parent;
    }
    submethod !bind-init($parent) {
        $!parent = $parent;
        self.Hash::BIND-KEY: 'hourFormat',      $!hour-format;
        self.Hash::BIND-KEY: 'hour-format',     $!hour-format;
        self.Hash::BIND-KEY: 'gmtFormat',       $!gmt-format;
        self.Hash::BIND-KEY: 'gmt-format',      $!gmt-format;
        self.Hash::BIND-KEY: 'gmtZeroFormat',   $!gmt-zero-format;
        self.Hash::BIND-KEY: 'gmt-zero-format', $!gmt-zero-format;
        self.Hash::BIND-KEY: 'fallbackFormat',  $!fallback-format;
        self.Hash::BIND-KEY: 'fallback-format', $!fallback-format;
        self.Hash::BIND-KEY: 'regionFormat',    $!region-format;
        self.Hash::BIND-KEY: 'region-format',   $!region-format;
        self.Hash::BIND-KEY: 'zone',            $!zones;
        self.Hash::BIND-KEY: 'metazone',        $!metazones;
        self
    }
    method ADD-TO-DATABASE(@branch, $offset = @branch - 1) {
        my $key = @branch[$offset];

        self.Hash::ASSIGN-KEY: $key, @branch[0]
            and return
                if $offset == 1;

        # Not terminal, so construct containers if necessary
        unless self.Hash::AT-KEY($key) {
            given $key {
                when 'regionFormat' { $!region-format = CLDR-RegionFormat.new }
                when 'zone'         { $!zones         = CLDR-Zones.new        }
                when 'metazone'     { $!metazones     = CLDR-Metazones.new    }
                default { self.Hash::ASSIGN-KEY: $key, CLDR-Item.new }
            }
        }

        self.Hash::AT-KEY($key).ADD-TO-DATABASE: @branch, $offset - 1
    }
}

class CLDR-RelativeTime is CLDR-Item is export {
    has Str $.zero;
    has Str $.one;
    has Str $.two;
    has Str $.few;
    has Str $.many;
    has Str $.other;

    method new2(\blob, $offset is raw) {
        my Str $zero; my Str $one; my Str $two; my Str $few; my Str $many; my Str $other;
        loop {
            my \code = blob[$offset++];
            say "        Decoding relative-time, code = {code}, offset = $offset";
            if    code ==  1 { $zero  = @*cldr-strings[blob[$offset++]] }
            elsif code ==  2 { $one   = @*cldr-strings[blob[$offset++]] }
            elsif code ==  3 { $two   = @*cldr-strings[blob[$offset++]] }
            elsif code ==  4 { $few   = @*cldr-strings[blob[$offset++]] }
            elsif code ==  5 { $many  = @*cldr-strings[blob[$offset++]] }
            elsif code ==  6 { $other = @*cldr-strings[blob[$offset++]] }
            elsif code ==  0 { last }
            else             { die "Unknown value {code} passed to CLDR-Field decoder" }
        }
        say "        Finished decoding relative-time";
        self.bless: :$zero, :$one, :$two, :$few, :$many, :$other;
    }

    ##`<<<<< GENERATOR: This method should only be uncommented out by the parsing script
    method encode(%hash) {
        use Intl::CLDR::Classes::StrEncode;
        my $result = Buf[uint8].new;
        say "Encoding relative time: ", %hash;
        for %hash.kv -> $key, \value {
            given $key {
                when 'zero'  { $result.append:  1, StringCoder::get(value) }
                when 'one'   { $result.append:  2, StringCoder::get(value) }
                when 'two'   { $result.append:  3, StringCoder::get(value) }
                when 'few'   { $result.append:  4, StringCoder::get(value) }
                when 'many'  { $result.append:  5, StringCoder::get(value) }
                when 'other' { $result.append:  6, StringCoder::get(value) }
                default      { die "Unknown value passed to CLDR-Fields encoder" }
            }
        }
        $result.append: 0;
        say "Encoded form: ", $result;
        return $result
    }

}

class CLDR-FieldWidth is CLDR-Item is export {
    has Str $.display-name;
    has Str $.less-two;
    has Str $.less-one;
    has Str $.same;
    has Str $.plus-two;
    has Str $.plus-one;
    has CLDR-RelativeTime $.future;
    has CLDR-RelativeTime $.past;

    method new2(\blob, $offset is raw) {
        my Str $display-name; my Str $less-two; my Str $less-one; my Str $same; my Str $plus-two; my Str $plus-one; my CLDR-RelativeTime $future; my CLDR-RelativeTime $past;

        loop {
            my \code = blob[$offset++];
            if    code ==  1 { $display-name = @*cldr-strings[blob[$offset++]] }
            elsif code ==  2 { $less-two     = @*cldr-strings[blob[$offset++]] }
            elsif code ==  3 { $less-one     = @*cldr-strings[blob[$offset++]] }
            elsif code ==  4 { $same         = @*cldr-strings[blob[$offset++]] }
            elsif code ==  5 { $plus-one     = @*cldr-strings[blob[$offset++]] }
            elsif code ==  6 { $plus-two     = @*cldr-strings[blob[$offset++]] }
            elsif code ==  7 { $future       = CLDR-RelativeTime.new2: blob, $offset }
            elsif code ==  8 { $past         = CLDR-RelativeTime.new2: blob, $offset }
            elsif code ==  0 { last }
            else             { die "Unknown value {code} passed to CLDR-FieldWidth decoder" }
        }
        self.bless: :$display-name, :$less-two, :$less-one, :$same, :$plus-one, :$plus-two, :$future, :$past;
    }

    ##`<<<<< GENERATOR: This method should only be uncommented out by the parsing script
    method encode(%hash) {
        use Intl::CLDR::Classes::StrEncode;
        my $result = Buf[uint8].new;
        for %hash.kv -> $key, \value {
            given $key {
                when 'displayName' { $result.append: 1, StringCoder::get(value) }
                when '-2'          { $result.append: 2, StringCoder::get(value) }
                when '-1'          { $result.append: 3, StringCoder::get(value) }
                when '0'           { $result.append: 4, StringCoder::get(value) }
                when '1'           { $result.append: 5, StringCoder::get(value) }
                when '2'           { $result.append: 6, StringCoder::get(value) }
                when 'future'      { $result.append: 7; $result ~= CLDR-RelativeTime.encode(value) }
                when 'past'        { $result.append: 8; $result ~= CLDR-RelativeTime.encode(value) }
                default            { die "Unknown value '$key' passed to CLDR-Fields encoder" }
            }
        }
        return $result.append: 0
    }
    #>>>>># GENERATOR

}


class CLDR-Field {
    has CLDR-FieldWidth $.standard;
    has CLDR-FieldWidth $.short;
    has CLDR-FieldWidth $.narrow;

    method new2(\blob, $offset is raw) {
        my CLDR-FieldWidth $standard; my CLDR-FieldWidth $short; my CLDR-FieldWidth $narrow;
        loop {
            my \code = blob[$offset++];
            if    code ==  1 { $standard = CLDR-FieldWidth.new2: blob, $offset }
            elsif code ==  2 { $short    = CLDR-FieldWidth.new2: blob, $offset }
            elsif code ==  3 { $narrow   = CLDR-FieldWidth.new2: blob, $offset }
            elsif code ==  0 { last }
            else             { die "Unknown value {code} passed to CLDR-Field decoder" }
        }

        self.bless: :$standard, :$short, :$narrow;
    }

    ##`<<<<< GENERATOR: This method should only be uncommented out by the parsing script
    method encode(%hash) {
        my $result = Buf[uint8].new;
        for %hash.kv -> $key, %value {
            given $key {
                when 'standard' { $result.append: 1; $result ~= CLDR-FieldWidth.encode(%value) }
                when 'short'    { $result.append: 2; $result ~= CLDR-FieldWidth.encode(%value) }
                when 'narrow'   { $result.append: 3; $result ~= CLDR-FieldWidth.encode(%value) }
                default         { die "Unknown value passed to CLDR-Fields encoder" }
            }
        }
        return $result.append: 0
    }
    #>>>>># GENERATOR
}

class CLDR-Fields is CLDR-Item is export {
    has CLDR-Field $.era;
    has CLDR-Field $.year;
    has CLDR-Field $.quarter;
    has CLDR-Field $.month;
    has CLDR-Field $.week;
    has CLDR-Field $.week-of-month;
    has CLDR-Field $.day;
    has CLDR-Field $.day-of-year;
    has CLDR-Field $.weekday;
    has CLDR-Field $.weekday-of-month;
    has CLDR-Field $.sun;
    has CLDR-Field $.mon;
    has CLDR-Field $.tue;
    has CLDR-Field $.wed;
    has CLDR-Field $.thu;
    has CLDR-Field $.fri;
    has CLDR-Field $.sat;
    has CLDR-Field $.dayperiod;
    has CLDR-Field $.hour;
    has CLDR-Field $.minute;
    has CLDR-Field $.second;
    has CLDR-Field $.zone;

    method new2(\blob, $offset is raw) {
        my CLDR-Field $era; my CLDR-Field $year; my CLDR-Field $quarter; my CLDR-Field $month; my CLDR-Field $week; my CLDR-Field $week-of-month;
        my CLDR-Field $day; my CLDR-Field $day-of-year; my CLDR-Field $weekday; my CLDR-Field $weekday-of-month;
        my CLDR-Field $sun; my CLDR-Field $mon; my CLDR-Field $tue; my CLDR-Field $wed; my CLDR-Field $thu; my CLDR-Field $fri; my CLDR-Field $sat;
        my CLDR-Field $dayperiod; my CLDR-Field $hour; my CLDR-Field $minute; my CLDR-Field $second; my CLDR-Field $zone;

        loop {
            my \code = blob[$offset++];
            if    code ==  1 { $era              = CLDR-Field.new2: blob, $offset }
            elsif code ==  2 { $year             = CLDR-Field.new2: blob, $offset }
            elsif code ==  3 { $quarter          = CLDR-Field.new2: blob, $offset }
            elsif code ==  4 { $month            = CLDR-Field.new2: blob, $offset }
            elsif code ==  5 { $week             = CLDR-Field.new2: blob, $offset }
            elsif code ==  6 { $week-of-month    = CLDR-Field.new2: blob, $offset }
            elsif code ==  7 { $day              = CLDR-Field.new2: blob, $offset }
            elsif code ==  8 { $day-of-year      = CLDR-Field.new2: blob, $offset }
            elsif code ==  9 { $weekday          = CLDR-Field.new2: blob, $offset }
            elsif code == 10 { $weekday-of-month = CLDR-Field.new2: blob, $offset }
            elsif code == 11 { $sun              = CLDR-Field.new2: blob, $offset }
            elsif code == 12 { $mon              = CLDR-Field.new2: blob, $offset }
            elsif code == 13 { $tue              = CLDR-Field.new2: blob, $offset }
            elsif code == 14 { $wed              = CLDR-Field.new2: blob, $offset }
            elsif code == 15 { $thu              = CLDR-Field.new2: blob, $offset }
            elsif code == 16 { $fri              = CLDR-Field.new2: blob, $offset }
            elsif code == 17 { $sat              = CLDR-Field.new2: blob, $offset }
            elsif code == 18 { $dayperiod        = CLDR-Field.new2: blob, $offset }
            elsif code == 19 { $hour             = CLDR-Field.new2: blob, $offset }
            elsif code == 20 { $minute           = CLDR-Field.new2: blob, $offset }
            elsif code == 21 { $second           = CLDR-Field.new2: blob, $offset }
            elsif code == 22 { $zone             = CLDR-Field.new2: blob, $offset }
            elsif code == 0 { last                                                 }
            else            { die "Unknown element {code} found when decoding Fields element" }
        }
        self.bless: :$era, :$year, :$quarter, :$month, :$week, :$week-of-month,
                    :$day, :$day-of-year, :$weekday, :$weekday-of-month,
                    :$sun, :$mon, :$tue, :$wed, :$thu, :$fri, :$sat,
                    :$dayperiod, :$hour, :$minute, :$second, :$zone;
    }

    ##`<<<<< GENERATOR: This method should only be uncommented out by the parsing script
    method encode(%hash) {
        my $result = Buf[uint8].new;
        for %hash.kv -> $key, %value {
            given $key {
                when 'era'            { $result.append:  1; $result ~= CLDR-Field.encode(%value) }
                when 'year'           { $result.append:  2; $result ~= CLDR-Field.encode(%value) }
                when 'quarter'        { $result.append:  3; $result ~= CLDR-Field.encode(%value) }
                when 'month'          { $result.append:  4; $result ~= CLDR-Field.encode(%value) }
                when 'week'           { $result.append:  5; $result ~= CLDR-Field.encode(%value) }
                when 'weekOfMonth'    { $result.append:  6; $result ~= CLDR-Field.encode(%value) }
                when 'day'            { $result.append:  7; $result ~= CLDR-Field.encode(%value) }
                when 'dayOfYear'      { $result.append:  8; $result ~= CLDR-Field.encode(%value) }
                when 'weekday'        { $result.append:  9; $result ~= CLDR-Field.encode(%value) }
                when 'weekdayOfMonth' { $result.append: 10; $result ~= CLDR-Field.encode(%value) }
                when 'sun'            { $result.append: 11; $result ~= CLDR-Field.encode(%value) }
                when 'mon'            { $result.append: 12; $result ~= CLDR-Field.encode(%value) }
                when 'tue'            { $result.append: 13; $result ~= CLDR-Field.encode(%value) }
                when 'wed'            { $result.append: 14; $result ~= CLDR-Field.encode(%value) }
                when 'thu'            { $result.append: 15; $result ~= CLDR-Field.encode(%value) }
                when 'fri'            { $result.append: 16; $result ~= CLDR-Field.encode(%value) }
                when 'sat'            { $result.append: 17; $result ~= CLDR-Field.encode(%value) }
                when 'dayperiod'      { $result.append: 18; $result ~= CLDR-Field.encode(%value) }
                when 'hour'           { $result.append: 19; $result ~= CLDR-Field.encode(%value) }
                when 'minute'         { $result.append: 20; $result ~= CLDR-Field.encode(%value) }
                when 'second'         { $result.append: 21; $result ~= CLDR-Field.encode(%value) }
                when 'zone'           { $result.append: 22; $result ~= CLDR-Field.encode(%value) }
                default               { die "Unknown value passed to CLDR-Fields encoder" }
            }
        }
        return $result.append: 0
    }
    #>>>>># GENERATOR

}


class CLDR-Dates is CLDR-Item is export {
    has                    $!parent;
    has CLDR-Calendars     $.calendars;
    has CLDR-Fields          $.fields;
    has CLDR-TimezoneNames $.timezone-names;
    method new($parent?) {
        self.bless!bind-init: $parent;
    }
    submethod !bind-init($parent) {
        $!parent = $parent;
        self.Hash::BIND-KEY: 'calendars', $!calendars;
        self.Hash::BIND-KEY: 'fields', $!fields;
        self.Hash::BIND-KEY: 'timezone-names', $!timezone-names;
        self.Hash::BIND-KEY: 'timeZoneNames', $!timezone-names;
        self;
    }

    method ADD-TO-DATABASE (@branch, $offset = @branch - 1) {
        my $key = @branch[$offset];
        unless self.Hash::AT-KEY($key) {
            given $key {
                when 'calendars'      { $!calendars      = CLDR-Calendars.new     }
                when 'fields'         { $!fields         = CLDR-Item.new          }
                when 'timeZoneNames'  { $!timezone-names = CLDR-TimezoneNames.new }
                when 'timezone-names' { $!timezone-names = CLDR-TimezoneNames.new }
                default { self.Hash::ASSIGN-KEY: $key, CLDR-Item.new }
            }
        }

        self.Hash::AT-KEY($key).ADD-TO-DATABASE: @branch, $offset - 1
    }

    method new2(\blob, $offset is raw) {
        my CLDR-Calendars $calendars;
        my CLDR-Fields $fields;
        my CLDR-TimezoneNames $timezone-names;

        loop {
            my \code = blob[$offset++];
            if    code == 1 { $calendars      = CLDR-Calendars.new2:     blob, $offset       }
            elsif code == 2 { $fields         = CLDR-Fields.new2:        blob, $offset       }
            elsif code == 3 { $timezone-names = CLDR-TimezoneNames.new2: blob, $offset       }
            elsif code == 0 { last                                                           }
            else            { die "Unknown element {code} found when decoding Dates element" }
        }
        self.bless: :$calendars, :$fields, :$timezone-names;
    }

    ##`<<<<< # GENERATOR: This method should only be uncommented out by the parsing script
    method encode(%hash) {
        my $result = Buf[uint8].new;
        for %hash.kv -> $key, %value {
            given $key {
                #when 'calendars'     { $result.append: 1, CLDR-Calendars.encode(    %value) }
                when 'fields'        { $result.append: 2; $result ~= CLDR-Fields.encode(       %value) }
                #when 'timeZoneNames' { $result.append: 3, CLDR-TimezoneNames.encode(%value) }
                #default              { die "Unknown value passed to CLDR-Dates encoder"     }
            }
        }
        return $result.append: 0
    }
    #>>>>> # GENERATOR
}