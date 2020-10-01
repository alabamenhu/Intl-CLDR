unit module Calendar;
use Intl::CLDR::Immutability;

=begin pod
Each calendar class follows the same format.

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

class CLDR-DayPeriodWidth       is CLDR-Item is export {                                                  }
class CLDR-DayPeriodContext     is CLDR-Item is export { method NEW-ITEM(|) { CLDR-DayPeriodWidth.new   } }
class CLDR-DayPeriods           is CLDR-Item is export { method NEW-ITEM(|) { CLDR-DayPeriodContext.new } } # handle last resort here, goes to AM / PM

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
        when 'narrow'      { $!narrow      = CLDR-DayWidth.new: self }
        when 'abbreviated' { $!abbreviated = CLDR-DayWidth.new: self }
        when 'wide'        { $!wide        = CLDR-DayWidth.new: self }
        default            { self.Hash::ASSIGN-KEY: $key, CLDR-Item.new }
      }
    }

    self.Hash::AT-KEY($key).ADD-TO-DATABASE: @branch, $offset - 1
  }
  method NEW-ITEM(|) { CLDR-DayWidth.new         }
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
        when 'stand-alone' { $!stand-alone = CLDR-DayContext.new }
        when 'format'      { $!format      = CLDR-DayContext.new }
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
        when 'narrow'      { $!narrow      = CLDR-MonthWidth.new }
        when 'abbreviated' { $!abbreviated = CLDR-MonthWidth.new }
        when 'wide'        { $!wide        = CLDR-MonthWidth.new }
        default            { self.Hash::ASSIGN-KEY: $key, CLDR-Item.new }
      }
    }
    self.Hash::AT-KEY($key).ADD-TO-DATABASE: @branch, $offset - 1
  }

  method NEW-ITEM(|) { CLDR-MonthWidth.new       } }

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
        when 'stand-alone' { $!stand-alone     = CLDR-MonthContext.new          }
        when 'format'      { $!format          = CLDR-MonthContext.new          }
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
  method AT-KEY(*@keys) { self.CLDR-Item::AT-KEY(|@keys)                                  } }

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
class CLDR-QuarterContext       is CLDR-Item is export {
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
        when 'narrow'      { $!narrow      = CLDR-QuarterWidth.new }
        when 'abbreviated' { $!abbreviated = CLDR-QuarterWidth.new }
        when 'wide'        { $!wide        = CLDR-QuarterWidth.new }
        default            { self.Hash::ASSIGN-KEY: $key, CLDR-Item.new }
      }
    }
    self.Hash::AT-KEY($key).ADD-TO-DATABASE: @branch, $offset - 1
  }

  method NEW-ITEM(|) { CLDR-MonthWidth.new       }
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
        when 'stand-alone' { $!stand-alone     = CLDR-QuarterContext.new          }
        when 'format'      { $!format          = CLDR-QuarterContext.new          }
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
  has $!parent;

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
  has $!parent;
  has $.narrow;
  has $.abbreviated;
  has $.wide;

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
        when 'narrow'      { $!narrow      = CLDR-QuarterWidth.new }
        when 'abbreviated' { $!abbreviated = CLDR-QuarterWidth.new }
        when 'wide'        { $!wide        = CLDR-QuarterWidth.new }
        default            { self.Hash::ASSIGN-KEY: $key, CLDR-Item.new }
      }
    }
    self.Hash::AT-KEY($key).ADD-TO-DATABASE: @branch, $offset - 1
  }

  method NEW-ITEM(|) { CLDR-EraWidth.new }
  #my %lr-eras     := BEGIN { my %h := CLDR-EraWidth.new;     %h.ADD-TO-DATABASE(0, 'BC'); %h.ADD-TO-DATABASE(1, 'AD');      %h};
  #method AT-KEY(|c)     { self.CLDR-Item::AT-KEY(c) // %lr-eras                                         } }
}
class CLDR-DateFormatLength     is CLDR-Item is export {                                                  }
class CLDR-TimeFormatLength     is CLDR-Item is export {                                                  }
class CLDR-DateTimeFormatLength is CLDR-Item is export {                                                  }
class CLDR-IntervalFormat       is CLDR-Item is export {                                                  }
class CLDR-AvailableFormats     is CLDR-Item is export {                                                  }
class CLDR-AppendItems          is CLDR-Item is export {                                                  }
class CLDR-DateFormats          is CLDR-Item is export { method NEW-ITEM(|) { CLDR-DateFormatLength.new } }
class CLDR-TimeFormats          is CLDR-Item is export { method NEW-ITEM(|) { CLDR-TimeFormatLength.new } }
class CLDR-DateTimeFormats      is CLDR-Item is export { method NEW-ITEM(|) { CLDR-DateTimeFormatLength.new } }
class CLDR-IntervalFormats      is CLDR-Item is export { method NEW-ITEM(|) { CLDR-IntervalFormat.new   } }

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
    #self.Hash::ASSIGN-KEY(@branch[1], @branch[0])
    #        andthen return if $offset == 1;

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
  has               $!parent;    #= The object parent (a languages object)
  # The following calendars are currently included in CLDR.  Expand as necessary
  has CLDR-Calendar $.buddhist;  #= Buddhist calendar data
  has CLDR-Calendar $.chinese;   #= Chinese calendar data
  has CLDR-Calendar $.coptic;    #= Coptic calendar data
  has CLDR-Calendar $.ethiopic;  #= Ethiopic calendar data
  has CLDR-Calendar $.generic;   #= Generic, numbers-only calendar data
  has CLDR-Calendar $.gregorian; #= Gregorian (civil) calendar data
  has CLDR-Calendar $.hebrew;    #= Hebrew calendar data
  has CLDR-Calendar $.indian;    #= Indian calendar data
  has CLDR-Calendar $.islamic;   #= Islamic calendar data
  has CLDR-Calendar $.japanese;  #= Japanese calendar data
  has CLDR-Calendar $.persian;   #= Persian calendar data
  has CLDR-Calendar $.roc;       #= Taiwanese calendar data

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
