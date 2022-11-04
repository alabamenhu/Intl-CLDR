#| The data for a calendar system (Gregorian, etc) in a language.
unit class CLDR::Calendar;
    use       Intl::CLDR::Core;
    also does CLDR::Item;

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

has CLDR::Months            $.months;
has CLDR::MonthPatterns     $.month-patterns    is aliased-by<monthPatterns>; # Currently used only for Chinese-based calendars, but can also be used by Hindi
has CLDR::Quarters          $.quarters;
has CLDR::Days              $.days;
has CLDR::DayPeriods        $.day-periods       is aliased-by<dayPeriods>;
has CLDR::Eras              $.eras;
has CLDR::CyclicNameSets    $.cyclic-name-sets  is aliased-by<cyclicNameSets>; # Various cycles, used in Chinese-based calendars
has CLDR::DateFormats       $.date-formats      is aliased-by<dateFormats>;
has CLDR::TimeFormats       $.time-formats      is aliased-by<timeFormats>;
has CLDR::DateTimeFormats   $.datetime-formats  is aliased-by<dateTimeFormats>;
has CLDR::AvailableFormats  $.available-formats is aliased-by<availableFormats>; # TODO: currently in date-time formats
has CLDR::IntervalFormats   $.interval-formats  is aliased-by<intervalFormats>;

method new(\blob, uint64 $offset is rw --> ::?CLASS) {
    self.bless:
        months           => CLDR::Months.new(          blob, $offset),
        month-patterns   => CLDR::MonthPatterns.new(   blob, $offset),
        quarters         => CLDR::Quarters.new(        blob, $offset),
        days             => CLDR::Days.new(            blob, $offset),
        day-periods      => CLDR::DayPeriods.new(      blob, $offset),
        eras             => CLDR::Eras.new(            blob, $offset),
        cyclic-name-sets => CLDR::CyclicNameSets.new(  blob, $offset),
        date-formats     => CLDR::DateFormats.new(     blob, $offset),
        time-formats     => CLDR::TimeFormats.new(     blob, $offset),
        datetime-formats => CLDR::DateTimeFormats.new( blob, $offset),
}

#`<<<<<# GENERATOR: Use toggle-generators.raku to [dis|en]able this code.
method encode(%*calendar) {

    # Not all elements may be present.  Specifically, not all calendars
    # include a cyclicNameSet or a monthPatterns element, but the other
    # elements should be expected for each calendar.
    my $result = buf8.new;

    $result ~= CLDR::Months.encode(        %*calendar<months>            // Hash);
    $result ~= CLDR::MonthPatterns.encode( %*calendar<monthPatterns>     // Hash);
    $result ~= CLDR::Quarters.encode(      %*calendar<quarters>          // Hash);
    $result ~= CLDR::Days.encode(          %*calendar<days>              // Hash);
    $result ~= CLDR::DayPeriods.encode(    %*calendar<dayPeriods>        // Hash);
    $result ~= CLDR::Eras.encode(          %*calendar<eras>              // Hash);
    $result ~= CLDR::CyclicNameSets.encode(%*calendar<cyclicNameSets>    // Hash);
    $result ~= CLDR::DateFormats.encode(   %*calendar<dateFormats>       // Hash);
    $result ~= CLDR::TimeFormats.encode(   %*calendar<timeFormats>       // Hash);
    $result ~= CLDR::DateTimeFormats.encode( %*calendar<dateTimeFormats> // Hash);

    $result;
}
method parse(\base, \xml) {
    use Intl::CLDR::Util::XML-Helper;
    CLDR::Months.parse:          (base<months>           //= Hash.new), $_ with xml.&elem('months');
    CLDR::MonthPatterns.parse:   (base<monthPatterns>    //= Hash.new), $_ with xml.&elem('monthPatterns');
    CLDR::Quarters.parse:        (base<quarters>         //= Hash.new), $_ with xml.&elem('quarters');
    CLDR::Days.parse:            (base<days>             //= Hash.new), $_ with xml.&elem('days');
    CLDR::DayPeriods.parse:      (base<dayPeriods>       //= Hash.new), $_ with xml.&elem('dayPeriods');
    CLDR::Eras.parse:            (base<eras>             //= Hash.new), $_ with xml.&elem('eras');
    CLDR::CyclicNameSets.parse:  (base<cyclicNameSets>   //= Hash.new), $_ with xml.&elem('cyclicNameSets');
    CLDR::DateFormats.parse:     (base<dateFormats>      //= Hash.new), $_ with xml.&elem('dateFormats');
    CLDR::TimeFormats.parse:     (base<timeFormats>      //= Hash.new), $_ with xml.&elem('timeFormats');
    CLDR::DateTimeFormats.parse: (base<dateTimeFormats>  //= Hash.new), $_ with xml.&elem('dateTimeFormats');
}
>>>>># GENERATOR