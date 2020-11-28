use Intl::CLDR::Immutability;

#| An ordered list of month names for a given width (1-indexed).
unit class CLDR-Calendar is CLDR-Ordered is CLDR-Item;

use Intl::CLDR::Types::Months;
use Intl::CLDR::Types::MonthPatterns;  # TODO parse in main script, only for Hindu/Chinese lunar calendars
use Intl::CLDR::Types::Quarters;
use Intl::CLDR::Types::Days;
use Intl::CLDR::Types::DayPeriods;
use Intl::CLDR::Types::CyclicNameSets;  # TODO parse in main script https://www.unicode.org/reports/tr35/tr35-dates.html#monthPatterns_cyclicNameSets
use Intl::CLDR::Types::Eras;
use Intl::CLDR::Types::DateFormats;
use Intl::CLDR::Types::TimeFormats;
use Intl::CLDR::Types::DateTimeFormats;
use Intl::CLDR::Types::AvailableFormats;
use Intl::CLDR::Types::IntervalFormats;

has $!parent;                                  #= The parent (a collection of calendars)
has CLDR-Months           $.months;
has CLDR-MonthPatterns    $.month-patterns; # Currently used only for Chinese-based calendars, but can also be used by Hindi
has CLDR-Quarters         $.quarters;
has CLDR-Days             $.days;
has CLDR-DayPeriods       $.day-periods;
has CLDR-Eras             $.eras;
has CLDR-CyclicNameSets   $.cyclic-name-sets; # Various cycles, used in Chinese-based calendars
has CLDR-DateFormats      $.date-formats;
has CLDR-TimeFormats      $.time-formats;
has CLDR-DateTimeFormats  $.datetime-formats;
has CLDR-AvailableFormats $.available-formats;
has CLDR-IntervalFormats  $.interval-formats;


method new(|c) {
    self.bless!bind-init: |c;
}

submethod !bind-init(\blob, uint64 $offset is rw, \parent) {
    $!parent := parent;

    self.Hash::BIND-KEY: 'months',            $!months;
    self.Hash::BIND-KEY: 'month-patterns',    $!month-patterns;
    self.Hash::BIND-KEY: 'monthPatterns',     $!month-patterns;
    self.Hash::BIND-KEY: 'quarters',          $!quarters;
    self.Hash::BIND-KEY: 'days',              $!days;
    self.Hash::BIND-KEY: 'day-periods',       $!day-periods;
    self.Hash::BIND-KEY: 'dayPeriods',        $!day-periods;
    self.Hash::BIND-KEY: 'eras',              $!eras;
    self.Hash::BIND-KEY: 'cyclic-name-sets',  $!cyclic-name-sets;
    self.Hash::BIND-KEY: 'cyclicNameSets',    $!cyclic-name-sets;
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

    $!months           = CLDR-Months.new:         blob, $offset, self;
    $!month-patterns   = CLDR-MonthPatterns.new:  blob, $offset, self;
    $!quarters         = CLDR-Quarters.new:       blob, $offset, self;
    $!days             = CLDR-Days.new:           blob, $offset, self;
    $!day-periods      = CLDR-DayPeriods.new:     blob, $offset, self;
    $!eras             = CLDR-Eras.new:           blob, $offset, self;
    $!cyclic-name-sets = CLDR-CyclicNameSets.new: blob, $offset, self;
    $!date-formats     = CLDR-DateFormats.new:    blob, $offset, self;
    $!time-formats     = CLDR-TimeFormats.new:    blob, $offset, self;
    #$!datetime-formats     = CLDR-DateTimeFormats.new:    blob, $offset, self;

    self
}


##`<<<<< # GENERATOR: This method should only be uncommented out by the parsing script
method encode(%*calendar) {

    # Not all elements may be present.  Specifically, not all calendars
    # include a cyclicNameSet or a monthPatterns element, but the other
    # elements should be expected for each calendar.
    my $result = buf8.new;

    $result ~= CLDR-Months.encode(        %*calendar<months>            // Hash);
    $result ~= CLDR-MonthPatterns.encode( %*calendar<monthPatterns>     // Hash);
    $result ~= CLDR-Quarters.encode(      %*calendar<quarters>          // Hash);
    $result ~= CLDR-Days.encode(          %*calendar<days>              // Hash);
    $result ~= CLDR-DayPeriods.encode(    %*calendar<dayPeriods>        // Hash);
    $result ~= CLDR-Eras.encode(          %*calendar<eras>              // Hash);
    $result ~= CLDR-CyclicNameSets.encode(%*calendar<cyclicNameSets>    // Hash);
    $result ~= CLDR-DateFormats.encode(   %*calendar<dateFormats>       // Hash);
    $result ~= CLDR-TimeFormats.encode(   %*calendar<timeFormats>       // Hash);
        #`[    CLDR-DateTimeFormats.encode( %*calendar<dateTimeFormats>);
    ]
    $result;
}

#>>>>> # GENERATOR
