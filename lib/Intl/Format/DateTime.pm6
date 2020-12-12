use Intl::CLDR;

grammar DateTimePattern { ... }
class DateTimePatternAction { ... }
sub julian-day {...}
my %calendar-data;
   %calendar-data<root> := BEGIN { cldr<root>.dates.calendars };
# This data and associated method definitely belong somewhere else
# But since the formatter is the only one that's using it at the moment... I'm lazy
my %tz-meta := BEGIN do {
    my %tz-meta;
    for "resources/Metazones.data".IO.slurp.lines {
        constant DELIMITER = ',';
        my @elements = .split(DELIMITER);
        my $tz = @elements.shift;
        my @forms;
        while @elements {
            @forms.push(List.new(.shift, .shift, .shift)) with @elements;
        }
        %tz-meta{$tz} := @forms;
    }
    %tz-meta
}
sub get-meta-timezone(Str $olson, DateTime $dt = DateTime.new(now)) {
    with %tz-meta{$olson} -> @meta-list {
        my $posix = $dt.posix;
        for @meta-list -> ($name, $start, $end) {
            return $name if $start ≤ $posix < $end;
        }
    }
    $olson # Default to kicking it back.  Or should we throw?
}


my \days = <null sun mon tue wed thu fri sat>;
# Each formatter receives three positional arguments: a calendar, a datetime, and a timezone
# The calendar and timezones are references to CLDR entries, and do not represent identifiers.
# As of 2020 August, $^vars are substantially faster than using explicit signatures (-> $var) or dynamic
# variables, even though it requires sinking the unused variables;
#
# After a major release, it's advisable to check to see if something may have changed.
my %formatters := Map.new:
        # The 'a' series indicate the time of day.  1..3 are identical at the moment
        'a',      { sink $^tz; $^c.day-periods.format.abbreviated{ $^dt.hour < 12 ?? 'am' !! 'pm'} },
        'aa',     { sink $^tz; $^c.day-periods.format.abbreviated{ $^dt.hour < 12 ?? 'am' !! 'pm'} },
        'aaa',    { sink $^tz; $^c.day-periods.format.abbreviated{ $^dt.hour < 12 ?? 'am' !! 'pm'} },
        'aaaa',   { sink $^tz; $^c.day-periods.format.wide{        $^dt.hour < 12 ?? 'am' !! 'pm'} },
        'aaaaa',  { sink $^tz; $^c.day-periods.format.narrow{      $^dt.hour < 12 ?? 'am' !! 'pm'} },
        # The 'A' series indicates the milliseconds-in-day, with the quantity of As
        # indicating the minimum number of digits.  60·60·24·1000 = 86_400_000, so we should
        # plan on handling up to 8.  We must factor in DST as well, and there is no function
        # to do that… yet.
        'A' => { 'NYI' },
        # The 'b' series also indicates the time period of the day, but includes special indicators for noon and midnight.
        'b',      { sink $^tz; $^c.day-periods.format.abbreviated{ $^dt.hour == 0 && $^dt.minute == 0 ?? 'midnight' !! $^dt.hour == 12 && $^dt.minute == 0 ?? 'noon' !! $^dt.hour < 12 ?? 'am' !! 'pm' } },
        'bb',     { sink $^tz; $^c.day-periods.format.abbreviated{ $^dt.hour == 0 && $^dt.minute == 0 ?? 'midnight' !! $^dt.hour == 12 && $^dt.minute == 0 ?? 'noon' !! $^dt.hour < 12 ?? 'am' !! 'pm' } },
        'bbb',    { sink $^tz; $^c.day-periods.format.abbreviated{ $^dt.hour == 0 && $^dt.minute == 0 ?? 'midnight' !! $^dt.hour == 12 && $^dt.minute == 0 ?? 'noon' !! $^dt.hour < 12 ?? 'am' !! 'pm' } },
        'bbbb',   { sink $^tz; $^c.day-periods.format.wide{        $^dt.hour == 0 && $^dt.minute == 0 ?? 'midnight' !! $^dt.hour == 12 && $^dt.minute == 0 ?? 'noon' !! $^dt.hour < 12 ?? 'am' !! 'pm' } },
        'bbbbb',  { sink $^tz; $^c.day-periods.format.narrow{      $^dt.hour == 0 && $^dt.minute == 0 ?? 'midnight' !! $^dt.hour == 12 && $^dt.minute == 0 ?? 'noon' !! $^dt.hour < 12 ?? 'am' !! 'pm' } },
        # The 'B' series also indicates the time period of the day, but uses locale-specific periods
        'B',      { sink $^tz; $^c.day-periods.format.abbreviated{ #`[calculate period of day (e.g. 'morning2' for locale] } },
        'BB',     { sink $^tz; $^c.day-periods.format.abbreviated{ #`[calculate period of day (e.g. 'morning2' for locale] } },
        'BBB',    { sink $^tz; $^c.day-periods.format.abbreviated{ #`[calculate period of day (e.g. 'morning2' for locale] } },
        'BBBB',   { sink $^tz; $^c.day-periods.format.wide{        #`[calculate period of day (e.g. 'morning2' for locale] } },
        'BBBBB',  { sink $^tz; $^c.day-periods.format.narrow{      #`[calculate period of day (e.g. 'morning2' for locale] } },
        # The 'c' series gives us the day of the week.  Note that the day-of-week's number may change on locale.  In
        # English areas, Sunday is '1', but in Spanish areas, Sunday is '7'
        'c',      { sink $^tz; sink $^c;                              ~ $^dt.day-of-week   }, # TODO adjust for first day of week
        'cc',     { sink $^tz; sink $^c;                            0 ~ $^dt.day-of-week   }, # TODO adjust for first day of week
        'ccc',    { sink $^tz; $^c.days.stand-alone.abbreviated{days[$^dt.day-of-week]} },
        'cccc',   { sink $^tz; $^c.days.stand-alone.wide{       days[$^dt.day-of-week]} },
        'ccccc',  { sink $^tz; $^c.days.stand-alone.narrow{     days[$^dt.day-of-week]} },
        'cccccc', { sink $^tz; $^c.days.stand-alone.short{      days[$^dt.day-of-week]} },
        # The 'C' series indicates a numeric hour with, potentially, period of day.  It is not used in
        # direct pattern generation, rather in pattern selection.  As such, it need need not (and cannot, in fact)
        # be implemented here.
        #
        # The 'd' series is the day of the month, with or without padding if one digit:
        'd',      { sink $^tz; sink $^c;                               ~  $^dt.day },
        'dd',     { sink $^tz; sink $^c; ($^dt.day <  10 ?? '0' !! '') ~  $^dt.day },
        # The 'D' series is the day of the year, with or without padding
        'D',      { sink $^tz; sink $^c;                                                                              ~ $^dt.day-of-year },
        'DD',     { sink $^tz; sink $^c;                                         ($^dt.day-of-year < 10 ?? '0' !! '') ~ $^dt.day-of-year },
        'DDD',    { sink $^tz; sink $^c; ($^dt.day-of-year < 100 ?? '0' !! '') ~ ($^dt.day-of-year < 10 ?? '0' !! '') ~ $^dt.day-of-year },
        # The 'e' series gives us the day of the week and is the same as the 'c' series, except that it uses
        # formatted forms (needed for some languages).  Recall the day-of-week's number may change on locale.
        'e',      { sink $^tz; sink $^c;                         ~ $^dt.day-of-week   }, # TODO adjust for first day of week
        'ee',     { sink $^tz; sink $^c;                       0 ~ $^dt.day-of-week   }, # TODO adjust for first day of week
        'eee',    { sink $^tz; $^c.days.format.abbreviated{days[$^dt.day-of-week]} },
        'eeee',   { sink $^tz; $^c.days.format.wide{       days[$^dt.day-of-week]} },
        'eeeee',  { sink $^tz; $^c.days.format.narrow{     days[$^dt.day-of-week]} },
        'eeeeee', { sink $^tz; $^c.days.format.short{      days[$^dt.day-of-week]} },
        # The 'E' series is identical to the 'E' series, except that it doesn't allow for numerical forms.
        'E',      { sink $^tz; $^c.days.format.abbreviated{days[$^dt.day-of-week]} },
        'EE',     { sink $^tz; $^c.days.format.abbreviated{days[$^dt.day-of-week]} },
        'EEE',    { sink $^tz; $^c.days.format.abbreviated{days[$^dt.day-of-week]} },
        'EEEE',   { sink $^tz; $^c.days.format.wide{       days[$^dt.day-of-week]} },
        'EEEEE',  { sink $^tz; $^c.days.format.narrow{     days[$^dt.day-of-week]} },
        'EEEEEE', { sink $^tz; $^c.days.format.short{      days[$^dt.day-of-week]} },
        # There is presently no 'f' series.
        # The 'F' series has represents the 'day of week in month'.  Basically, the week number counting from
        # the first day of the month, rather than a Sunday.
        'F',      { sink $^tz; sink $^c; $^dt.day-of-month % 7},
        # The 'g' series is the modified Julian day, based on localtime at midnight, perhaps with zero-padding.
        # There is no specific maximum, but at present time, we're in the 2million, so we hedge our bets
        # for several additional: TODO check julian calculations
        'g',         { sink $^tz; sink $^c;          ~$^dt.&julian-day                                                     },
        'gg',        { sink $^tz; sink $^c; my $jd = ~$^dt.&julian-day; ($jd.chars < 2 ?? '0' x (2-$jd.chars) !! '') ~ $jd },
        'ggg',       { sink $^tz; sink $^c; my $jd = ~$^dt.&julian-day; ($jd.chars < 3 ?? '0' x (3-$jd.chars) !! '') ~ $jd },
        'gggg',      { sink $^tz; sink $^c; my $jd = ~$^dt.&julian-day; ($jd.chars < 4 ?? '0' x (4-$jd.chars) !! '') ~ $jd },
        'ggggg',     { sink $^tz; sink $^c; my $jd = ~$^dt.&julian-day; ($jd.chars < 5 ?? '0' x (5-$jd.chars) !! '') ~ $jd },
        'gggggg',    { sink $^tz; sink $^c; my $jd = ~$^dt.&julian-day; ($jd.chars < 6 ?? '0' x (6-$jd.chars) !! '') ~ $jd },
        'ggggggg',   { sink $^tz; sink $^c; my $jd = ~$^dt.&julian-day; ($jd.chars < 7 ?? '0' x (7-$jd.chars) !! '') ~ $jd },
        'gggggggg',  { sink $^tz; sink $^c; my $jd = ~$^dt.&julian-day; ($jd.chars < 8 ?? '0' x (8-$jd.chars) !! '') ~ $jd },
        'ggggggggg', { sink $^tz; sink $^c; my $jd = ~$^dt.&julian-day; ($jd.chars < 9 ?? '0' x (9-$jd.chars) !! '') ~ $jd },
        # The 'G' series calculates the era.
        # TODO: implement non-Gregorian calendars whose eras may be quite different (Japanese is a great test case)
        'G',      { sink $^tz; $^c.eras.abbreviation{ $^dt.year > 0 ?? 1 !! 0 } },                 # See above on non-gregorian
        'GG',     { sink $^tz; $^c.eras.abbreviation{ $^dt.year > 0 ?? 1 !! 0 } },                 # See above on non-gregorian
        'GGG',    { sink $^tz; $^c.eras.abbreviation{ $^dt.year > 0 ?? 1 !! 0 } },                 # See above on non-gregorian
        'GGGG',   { sink $^tz; $^c.eras.wide{         $^dt.year > 0 ?? 1 !! 0 } },                 # See above on non-gregorian
        'GGGGG',  { sink $^tz; $^c.eras.narrow{       $^dt.year > 0 ?? 1 !! 0 } },                 # See above on non-gregorian
        # The 'h' series indicates 12-hour clocks that are 1-indexed (1..12)
        'h',      { sink $^tz; sink $^c;                                             ~ (($^dt.hour+11) % 12 + 1) }, #  1-12
        'hh',     { sink $^tz; sink $^c; ($^dt.hour = 0|10|11|12|22|23 ?? '0' !! '') ~ (($^dt.hour+11) % 12 + 1) }, # 01-12
        # The 'H' series indicates 24 hour clocks that are 0-index (0..23)
        'H',      { sink $^tz; sink $^c;                               ~ $^dt.hour }, #  0-23
        'HH',     { sink $^tz; sink $^c; ($^dt.hour < 10 ?? '0' !! '') ~ $^dt.hour }, # 00-23
        # The 'i' and 'I' series are presently undefined
        # The 'j' and 'J' series are used in input skeletons, but not for pattern data (TR35)
        # The 'k' series indicates 24 hour clocks that are 1-index (1..24)
        'k',      { sink $^tz; sink $^c;                              ~ ($^dt.hour + 1) }, #  1-24
        'kk',     { sink $^tz; sink $^c; ($^dt.hour < 9 ?? '0' !! '') ~ ($^dt.hour + 1) }, # 01-24
        # The 'K' series indicates 12 hour clocks that are 0-index (0..11)
        'K',      { sink $^tz; sink $^c;                                    ~ ($^dt.hour % 12) }, #  0-11
        'KK',     { sink $^tz; sink $^c; ($^dt.hour % 12 < 10 ?? '0' !! '') ~ ($^dt.hour % 12) }, # 00-11
        # The 'l' series is deprecated and per TR35 is to be ignored
        'l',      { '' },
        # The 'L' series shows the stand-alone month name or number (e.g. when days are not shown)
        'L',      { sink $^tz; sink $^c;                                   $^dt.month   },
        'LL',     { sink $^tz; sink $^c;  ($^dt.month < 10 ?? '0' !! '') ~ $^dt.month   },
        'LLL',    { sink $^tz;      $^c.months.stand-alone.abbreviated{ $^dt.month } },
        'LLLL',   { sink $^tz;      $^c.months.stand-alone.wide{        $^dt.month } },
        'LLLLL',  { sink $^tz;      $^c.months.stand-alone.narrow{      $^dt.month } },
        # The 'm' series indicates the minutes, with or without padding
        'm',      { sink $^tz; sink $^c;                                  $^dt.minute  },
        'mm',     { sink $^tz; sink $^c; ($^dt.minute < 10 ?? '0' !! '') ~$^dt.minute  },
        # The 'M' series indicates the formatted month name/number (e.g. when days are shown)
        'M',      { sink $^tz; sink $^c;                                  $^dt.month   },
        'MM',     { sink $^tz; sink $^c; ($^dt.month < 10 ?? '0' !! '') ~ $^dt.month   },
        'MMM',    { sink $^tz;      $^c.months.format.abbreviated{     $^dt.month } }, # for 1|2 see L
        'MMMM',   { sink $^tz;      $^c.months.format.wide{            $^dt.month } },
        'MMMMM',  { sink $^tz;      $^c.months.format.narrow{          $^dt.month } },
        # The 'n' series is presently undefined
        # The 'N' series is presently undefined
        # The 'o' series is presently undefined
        # The 'O' series indicates timezone information as GMT offset, OO and OOO are unused/reserved
        # TODO: Ensure that fallbacks for zero-format work (they currently don't).
        'O',      { sink $^c;  gmt-inner(%^tz, $^dt.offset, 'short') },
        'OOOO',   { sink $^c;  gmt-inner(%^tz, $^dt.offset, 'long' ) },
        # The 'p' series is presently undefined
        # The 'P' series is presently undefined
        # The 'q' series is the quarter in stand-alone form (or numerical with/without padding)
        'q',        { sink $^tz;                                          ($^dt.month + 2) div 3   },
        'qq',       { sink $^tz;                                   '0' ~  ($^dt.month + 2) div 3   },
        'qqq',      { sink $^tz; $^c.quarters.stand-alone.abbreviated{ ($^dt.month + 2) div 3 } },
        'qqqq',     { sink $^tz; $^c.quarters.stand-alone.wide{        ($^dt.month + 2) div 3 } },
        'qqqqq',    { sink $^tz; $^c.quarters.stand-alone.narrow{      ($^dt.month + 2) div 3 } },
        # The 'q' series is the quarter in formatted form (or numerical with/without padding)
        'Q',        { sink $^tz;                                          ($^dt.month + 2) div 3   },
        'QQ',       { sink $^tz;                                   '0' ~  ($^dt.month + 2) div 3   },
        'QQQ',      { sink $^tz;      $^cquarters.format.abbreviated{ ($^dt.month + 2) div 3 } },
        'QQQQ',     { sink $^tz;      $^cquarters.format.wide{        ($^dt.month + 2) div 3 } },
        'QQQQQ',    { sink $^tz;      $^cquarters.format.narrow{      ($^dt.month + 2) div 3 } },
        # The 'r' series indicates the gregorian year in which the current year begins, with padding
        'r',       { sink $^tz; sink $^c; my $temp = $^dt.year.Str;                                              $temp  }, # TODO calculate for solar calendar years
        'rr',      { sink $^tz; sink $^c; my $temp = $^dt.year.Str; $temp.chars > 2 ?? $temp !! (0 x (2-$temp) ~ $temp) }, # TODO calculate for solar calendar years
        'rrr',     { sink $^tz; sink $^c; my $temp = $^dt.year.Str; $temp.chars > 3 ?? $temp !! (0 x (3-$temp) ~ $temp) }, # TODO calculate for solar calendar years
        'rrrr',    { sink $^tz; sink $^c; my $temp = $^dt.year.Str; $temp.chars > 4 ?? $temp !! (0 x (4-$temp) ~ $temp) }, # TODO calculate for solar calendar years
        'rrrrr',   { sink $^tz; sink $^c; my $temp = $^dt.year.Str; $temp.chars > 5 ?? $temp !! (0 x (5-$temp) ~ $temp) }, # TODO calculate for solar calendar years
        'rrrrrr',  { sink $^tz; sink $^c; my $temp = $^dt.year.Str; $temp.chars > 6 ?? $temp !! (0 x (6-$temp) ~ $temp) }, # TODO calculate for solar calendar years
        # The 'R' series is presently undefined
        # The 's' series indicates the seconds of the current minute, with or without padding
        's',       { sink $^tz; sink $^c;                                 ~ $^dt.second.floor },
        'ss',      { sink $^tz; sink $^c; ($^dt.second < 10 ?? '0' !! '') ~ $^dt.second.floor },
        # The 'S' series indicates fractional time, truncated, but with a specific number of digits
        'S',       { sink $^tz; sink $^c; my $S = $^dt.second - $^dt.second.floor; $S = $S.Str.substr(2, 1); $S ~ ('0' x (1 - $S.chars)) }, # fractional sections, * is fractional digits
        'SS',      { sink $^tz; sink $^c; my $S = $^dt.second - $^dt.second.floor; $S = $S.Str.substr(2, 2); $S ~ ('0' x (2 - $S.chars)) }, # fractional sections, * is fractional digits
        'SSS',     { sink $^tz; sink $^c; my $S = $^dt.second - $^dt.second.floor; $S = $S.Str.substr(2, 3); $S ~ ('0' x (3 - $S.chars)) }, # fractional sections, * is fractional digits
        'SSSS',    { sink $^tz; sink $^c; my $S = $^dt.second - $^dt.second.floor; $S = $S.Str.substr(2, 4); $S ~ ('0' x (4 - $S.chars)) }, # fractional sections, * is fractional digits
        'SSSSS',   { sink $^tz; sink $^c; my $S = $^dt.second - $^dt.second.floor; $S = $S.Str.substr(2, 5); $S ~ ('0' x (5 - $S.chars)) }, # fractional sections, * is fractional digits
        'SSSSSS',  { sink $^tz; sink $^c; my $S = $^dt.second - $^dt.second.floor; $S = $S.Str.substr(2, 6); $S ~ ('0' x (6 - $S.chars)) }, # fractional sections, * is fractional digits
        'SSSSSSS', { sink $^tz; sink $^c; my $S = $^dt.second - $^dt.second.floor; $S = $S.Str.substr(2, 7); $S ~ ('0' x (7 - $S.chars)) }, # fractional sections, * is fractional digits
        'SSSSSSSS',{ sink $^tz; sink $^c; my $S = $^dt.second - $^dt.second.floor; $S = $S.Str.substr(2, 8); $S ~ ('0' x (8 - $S.chars)) }, # fractional sections, * is fractional digits
        # The 't' series is presently undefined
        # The 'T' series is presently undefined
        # The 'u' series indicates the extended year numeric which is unique to each calendar system, with padding.
        # TODO: implement for other calendar systems.  Gregorian
        'u',       { sink $^tz; sink $^c; $^dt.year }, # I think this is right for Gregorian: julian 1 BC = 0; 2 BC = -1
        # The 'v' series is the generic non-location format (e.g. common use forms like "Eastern Time"). 'vv' and 'vvv' are undefinde
        # Both lengths fall back to 'VVVV', although the 'v' falls back further to short GMT
        'v',       { sink $^c; $^tz{$^dt.olson-id}<short>{$^dt.is-dst ?? 'daylight' !! 'standard'} // %formatters<VVVV>($^c, $^dt, $^tz) }, # TODO: handle further fall back to only be short GMT
        'vvvv',    { sink $^c, $^tz, $^dt },   # { long non location, fall back to VVVV }

# when 'V',     1 { short id, fall back to 'unk' }
# when 'V',     2 { long id }
# when 'V',     3 { exemplar city }
# when 'V',     4 { generic location }>>>
       'y',       { sink $^c, $^tz; $^dt.year },
       'yy',      { sink $^c, $^tz; $^dt.year.Str.substr(*-2,2) },
       'yyy',     { sink $^c, $^tz;; '0' x (3 - $^dt.year.Str.chars ) ~ $^dt.year },
       'yyyy',    { sink $^c, $^tz;; '0' x (4 - $^dt.year.Str.chars ) ~ $^dt.year },
       'yyyyy',   { sink $^c, $^tz;; '0' x (5 - $^dt.year.Str.chars ) ~ $^dt.year },
       #'Y',     1 { $datetime.week-year }
       #'YY',     2 { $datetime.week-year.Str.substr(*-2,2) }
       #'Y', * > 3 { '0' x ($_[1] - $datetime.week-year.Str.chars ) ~ $datetime.week-year }

;

my %pattern-cache;
sub get-pattern(Str() \str) {
    .return with %pattern-cache{str};
    %pattern-cache{str} := DateTimePattern.parse(str, :actions(DateTimePatternAction)).made;
}
sub pattern-replace($datetime, @pattern, $language, $calendar) {
    [~] do .isa(Str)
            ?? $_
            !! $_($calendar, $datetime, 'timezone' #`<< todo: replace with real timezone data>> )
    for @pattern
    #}
}










sub time-pattern-replace { ... }
grammar DateTimePattern { ... }

# subs needed for calculations
sub julian-day { ... }

sub format-datetime(
        DateTime() $datetime,       #= The datetime to be formatted
        :$language = user-language, #= The locale to use (defaults to B<user-language>)
        :$calendar = 'gregorian',   #= The calendar used (defaults to B<gregorian>, other calendars NYI)
        :$length = 'medium',        #= The formatting length (defaults to 'medium')
) is export {

    my \calendar = cldr{$language}.dates.calendars{$calendar};

    my \combo-pattern := calendar.datetime-formats{$length}.pattern; #{$length};
    my \time-pattern  := calendar.time-formats{$length}.pattern;
    my \date-pattern  := calendar.date-formats{$length}.pattern;

    my \date = pattern-replace
            $datetime,
            get-pattern(date-pattern),
            $language,
            calendar;
    my \time = pattern-replace
            $datetime,
            get-pattern(time-pattern),
            $language,
            calendar;

    combo-pattern.subst:
            / '{' (0|1) '}' /,               # {0} and {1} are the replacement tokens
            { ~$0 eq '0' ?? time !! date },  # 0 = time in CLDR formats
            :g;
}




grammar DateTimePattern {
        token TOP                  {     <element>+     }
  proto token element              {         *          }
        token element:sym<literal> {      <text>+       }
        token element:sym<replace> { (<[a..zA..Z]>) $0* }
  proto token text                 {         *          }
        token text:sym<apostrophe> {        \'\'        }
        token text:sym<literal>    {   <-[a..zA..Z']>+  }
        token text:sym<quoted>     {         \'           # apostrophes only allowed
                                    [ <-[']>+ || \'\' ]+  # if doubled, action reduces it
                                             \'         } # down to one
}

class DateTimePatternAction {
  method TOP                  ($/) { make $<element>.map(*.made)      }
  method element:sym<literal> ($/) { make $<text>.map(   *.made).join }
  method element:sym<replace> ($/) { make %formatters{$/}             }
  method text:sym<apostrophe> ($/) { make "'"                         }
  method text:sym<literal>    ($/) { make $/.Str                      }
  method text:sym<quoted>     ($/) { make $/.Str.substr(1, *-1).subst("''","'") };
}

# This
sub nominal-time-zone ($time) {
    state %timezone-list
}


my @days = <null sun mon tue wed thu fri sat>;

#`<<< Old code
sub time-pattern-replace-old ($datetime, @pattern, $language, $calendar) {
  # This implements ICU's DateFormatSymbols::initializeData  but also formats at the same time.
  # Right now I'm using a giant when block.  That's not very fast currently.
  # Focus is to have things accurate and readable first.

  # these are the possible capitalization values { "day-format-except-narrow", DateFormatSymbols::kCapContextUsageDayFormat },
  # these are the possible capitalization values { "day-narrow",     DateFormatSymbols::kCapContextUsageDayNarrow },
  # these are the possible capitalization values { "day-standalone-except-narrow", DateFormatSymbols::kCapContextUsageDayStandalone },
  # these are the possible capitalization values { "era-abbr",       DateFormatSymbols::kCapContextUsageEraAbbrev },
  # these are the possible capitalization values { "era-name",       DateFormatSymbols::kCapContextUsageEraWide },
  # these are the possible capitalization values { "era-narrow",     DateFormatSymbols::kCapContextUsageEraNarrow },
  # these are the possible capitalization values { "metazone-long",  DateFormatSymbols::kCapContextUsageMetazoneLong },
  # these are the possible capitalization values { "metazone-short", DateFormatSymbols::kCapContextUsageMetazoneShort },
  # these are the possible capitalization values { "month-format-except-narrow", DateFormatSymbols::kCapContextUsageMonthFormat },
  # these are the possible capitalization values { "month-narrow",   DateFormatSymbols::kCapContextUsageMonthNarrow },
  # these are the possible capitalization values { "month-standalone-except-narrow", DateFormatSymbols::kCapContextUsageMonthStandalone },
  # these are the possible capitalization values { "zone-long",      DateFormatSymbols::kCapContextUsageZoneLong },
  # these are the possible capitalization values { "zone-short",     DateFormatSymbols::kCapContextUsageZoneShort },

  my %c := language($language){$calendar};
  [~] do for @pattern {
    if .<type> eq 'literal' {
      .<text>
    } else { # type = 'replace'
      (given .<code>, .<style> {
        when 'a',     4 { %c<dayPeriods><format><wide>{        $datetime.hour < 12 ?? 'am' !! 'pm'} }
        when 'a',     5 { %c<dayPeriods><format><narrow>{      $datetime.hour < 12 ?? 'am' !! 'pm'} }
        when 'A',  1..3 { my $A = $datetime.hour * 3600 + $datetime.minute * 60 + $datetime.second; $A *= 1000; $A .= floor; '0' x ($_[1] - $A.Str.chars) ~ $A } # milliseconds OF DAY TODO calculate for DST jumps
        when 'a',  1..3 { %c<dayPeriods><format><abbreviated>{ $datetime.hour < 12 ?? 'am' !! 'pm'} }
        when 'b',     4 { %c<dayPeriods><format><wide>{        $datetime.hour == 0 && $datetime.minute == 0 ?? 'midnight' !! $datetime.hour == 12 && $datetime.minute == 0 ?? 'noon' !! $datetime.hour < 12 ?? 'am' !! 'pm' } }
        when 'b',     5 { %c<dayPeriods><format><narrow>{      $datetime.hour == 0 && $datetime.minute == 0 ?? 'midnight' !! $datetime.hour == 12 && $datetime.minute == 0 ?? 'noon' !! $datetime.hour < 12 ?? 'am' !! 'pm' } }
        when 'b',  1..3 { %c<dayPeriods><format><abbreviated>{ $datetime.hour == 0 && $datetime.minute == 0 ?? 'midnight' !! $datetime.hour == 12 && $datetime.minute == 0 ?? 'noon' !! $datetime.hour < 12 ?? 'am' !! 'pm' } }
#       when 'B',     4 { %c<dayPeriods><format><wide>{ CALCULATE DAY TIME PERIOD FOR LANGUAGE } }
#       when 'B',     4 { %c<dayPeriods><format><wide>{ CALCULATE DAY TIME PERIOD FOR LANGUAGE } }
#       when 'B',     4 { %c<dayPeriods><format><wide>{ CALCULATE DAY TIME PERIOD FOR LANGUAGE } }
        when 'c',     1 {   ~ $datetime.day-of-week } # TODO adjust for first day of week
        when 'c',     2 { 0 ~ $datetime.day-of-week } #TODO adjust for first day of week
        when 'c',     3 { %c<days><stand-alone><abbreviated>{@days[$datetime.day-of-week]} }
        when 'c',     4 { %c<days><stand-alone><wide>{   @days[$datetime.day-of-week]} }
        when 'c',     5 { %c<days><stand-alone><narrow>{ @days[$datetime.day-of-week]} }
        when 'c',     6 { %c<days><stand-alone><short>{  @days[$datetime.day-of-week]} }
        when 'd',     1 {                                    ~  $datetime.day }
        when 'd',     2 { ($datetime.day <  10 ?? '0' !! '') ~  $datetime.day }
        when 'D',     1 {                                                                                        ~ $datetime.day-of-year }
        when 'D',     2 {                                              ($datetime.day-of-year < 10 ?? '0' !! '') ~ $datetime.day-of-year }
        when 'D',     3 { ($datetime.day-of-year < 100 ?? '0' !! '') ~ ($datetime.day-of-year < 10 ?? '0' !! '') ~ $datetime.day-of-year }
        when 'E',  1..3 { %c<days><format><abbreviated>{ @days[$datetime.day-of-week]} }
        when 'E',     4 { %c<days><format><wide>{        @days[$datetime.day-of-week]} }
        when 'E',     5 { %c<days><format><narrow>{      @days[$datetime.day-of-week]} }
        when 'E',     5 { %c<days><format><short>{       @days[$datetime.day-of-week]} }
        when 'F',     5 { ~ $datetime.day-of-month }
      # when 'g',     * { calculate-modified-julian-day($datetime) + padding for nº of g's }
        when 'G',  1..3 { %c<eras><eraAbbr>{   $datetime.year > 0 ?? 1 !! 0 } } # TODO calculate other eras
        when 'G',  1..3 { %c<eras><eraWide>{   $datetime.year > 0 ?? 1 !! 0 } } # TODO calculate other eras
        when 'G',  1..3 { %c<eras><eraNarrow>{ $datetime.year > 0 ?? 1 !! 0 } } # TODO calculate other eras
        when 'h',     1 {                                                  ~ (($datetime.hour+11) % 12 + 1) } #  1-12
        when 'h',     2 { ($datetime.hour = 0|10|11|12|22|23 ?? '0' !! '') ~ (($datetime.hour+11) % 12 + 1) } # 01-12
        when 'H',     1 {                                    ~ $datetime.hour } #  0-23
        when 'H',     2 { ($datetime.hour < 10 ?? '0' !! '') ~ $datetime.hour } # 00-23
      # when 'j',     * { ; } # Per TR35, j is only used in input skeletons, and not used for pattern or skeleton data
      # when 'J',     * { ; } # Per TR35, J is only used in input skeletons, and not used for pattern or skeleton data
        when 'K',     1 {                                         ~ ($datetime.hour % 12) } #  0-11
        when 'K',     2 { ($datetime.hour % 12 < 10 ?? '0' !! '') ~ ($datetime.hour % 12) } # 00-11
        when 'k',     1 {                                   ~ ($datetime.hour + 1) } #  1-24
        when 'k',     2 { ($datetime.hour < 9 ?? '0' !! '') ~ ($datetime.hour + 1) } # 01-24
      # when 'l',     * { ; } # Per TR35, deprecated.  Previously used to indicate the leap month in Chinese calendars.  Now implemented in M/L
        when 'L',     1 {                                       $datetime.month   }
        when 'L',     2 { ($datetime.month < 10 ?? '0' !! '') ~ $datetime.month   }
        when 'L',     3 { %c<months><stand-alone><abbreviated>{ $datetime.month } }
        when 'L',     4 { %c<months><stand-alone><wide>{        $datetime.month } }
        when 'L',     5 { %c<months><stand-alone><narrow>{      $datetime.month } }
        when 'm',     1 {                                       $datetime.minute  }
        when 'm',     2 { ($datetime.minute < 10 ?? '0' !! '') ~$datetime.minute  }
        when 'M',     1 {                                       $datetime.month   }
        when 'M',     2 { ($datetime.month < 10 ?? '0' !! '') ~ $datetime.month   }
        when 'M',     3 {      %c<months><format><abbreviated>{ $datetime.month } } # for 1|2 see L
        when 'M',     4 {      %c<months><format><wide>{        $datetime.month } }
        when 'M',     5 {      %c<months><format><narrow>{      $datetime.month } }
      # when 'O',     1 / 4, localized time zone format
        when 'Q',     1 {                                         ($datetime.month + 2) div 3   }
        when 'Q',     2 {                                   '0' ~ ($datetime.month + 2) div 3   }
        when 'Q',     3 {      %c<quarters><format><abbreviated>{ ($datetime.month + 2) div 3 } }
        when 'Q',     4 {      %c<quarters><format><wide>{        ($datetime.month + 2) div 3 } }
        when 'Q',     5 {      %c<quarters><format><narrow>{      ($datetime.month + 2) div 3 } }
        when 'q',     1 {                                         ($datetime.month + 2) div 3   }
        when 'q',     2 {                                   '0' ~ ($datetime.month + 2) div 3   }
        when 'q',     3 { %c<quarters><stand-alone><abbreviated>{ ($datetime.month + 2) div 3 } }
        when 'q',     4 { %c<quarters><stand-alone><wide>{        ($datetime.month + 2) div 3 } }
        when 'q',     5 { %c<quarters><stand-alone><narrow>{      ($datetime.month + 2) div 3 } }
        when 'r',     * { '0' x ($_[1] - $datetime.year.Str.chars) ~ $datetime.year } # TODO calculate for solar calendar years
        when 's',     1 {                                      ~ $datetime.second.floor }
        when 's',     2 { ($datetime.second < 10 ?? '0' !! '') ~ $datetime.second.floor }
        when 'S',     * { my $S = $datetime.second - $datetime.second.floor; $S = $S.Str.substr(2, $_[1]); $S ~ ('0' x ($_[1] - $S.chars)) } # fractional sections, * is fractional digits
      # when 'u',     * extended year numeric, e.g. julian 1 BC = 0; 2 BC = -1
      # when 'v',     1 { short generic non-location, fall back to VVVV, or O }
      # when 'v',     4 { long non location, fall back to VVVV }
      # when 'V',     1 { short id, fall back to 'unk' }
      # when 'V',     2 { long id }
      # when 'V',     3 { exemplar city }
      # when 'V',     4 { generic location }
        when 'w',     1 {                                           ~ $datetime.week-number }
        when 'w',     2 { ($datetime.week-number < 10 ?? '0' !! '') ~ $datetime.week-number }
      # when 'W',     1 { calculate week of month, need first day of week }
      # when 'x',     * { various ISO formats }
      # when 'X',     * { generic location }
        when 'y',     1 { $datetime.year }
        when 'y',     2 { $datetime.year.Str.substr(*-2,2) }
        when 'y', * > 3 { '0' x ($_[1] - $datetime.year.Str.chars ) ~ $datetime.week-year }
        when 'Y',     1 { $datetime.week-year }
        when 'Y',     2 { $datetime.week-year.Str.substr(*-2,2) }
        when 'Y', * > 3 { '0' x ($_[1] - $datetime.week-year.Str.chars ) ~ $datetime.week-year }
        when 'z'|'Z'|'O', * { '' }
      # when 'z',  1..3 { short non location, fall back to O }
      # when 'z',     4 { short non location, fall back to OOOO }
      # when 'Z',  1..3 { short non location, fall back to xxxx }
      # when 'Z',     4 { short non location, fall back to OOOO }
      # when 'Z',     5 { short non location, fall back to XXXXX }
        default { say "Unknown or unimplemented replacement value {$_[0]} (type {$_[1]})"; Nil }
      }) // '' # and if anything bombs, nothing TODO use the last-resort values (normally numeric)
    }
  }
}
>>>

sub language(Str() $language) {
  ##say "Getting calendar data for $language ", %calendar-data{$language}:exists ?? '(loaded)' !! '(unloaded)';
  .return with %calendar-data{$language};

  # current language requested does not exist, so we track it down.
  my @subtags = $language.split: '-';
  my $calendar;
  my $alt-lang;
  while @subtags {
    $alt-lang = @subtags.join('-');
    last if $calendar := cldr{@subtags.join('-')}.dates.calendars;
    @subtags.pop;
  }
  %calendar-data{$alt-lang} := $calendar;
  %calendar-data{$language} := $calendar;
}

use Intl::UserLanguage;
sub format-time (DateTime() $time, :$language = user-language, :$calendar = 'gregorian', :$length = 'medium', :$alt = 'standard') is export {
  my $pattern =  language($language){$calendar}<timeFormats>{$length}{$alt};
  time-pattern-replace($time, DateTimePattern.parse($pattern, :actions(DateTimePatternAction)).made, $language, $calendar)
}

multi sub format-date(DateTime() $date, :$language = user-language, :$calendar = 'gregorian', :$length = 'medium', :$alt = 'standard') is export {
  my $pattern =  language($language){$calendar}<dateFormats>{$length}{$alt};
  time-pattern-replace($date, DateTimePattern.parse($pattern, :actions(DateTimePatternAction)).made, $language, $calendar)
}

multi sub format-date(Date $date, |c) {
    samewith DateTime.new(:$date), c
}





# CALCULATION SUBS
sub julian-day (DateTime \d) {
    (1461 * (d.year + 4800 + (d.month -14) div 12)) div 4
        + (367 * (d.month - 2 - 12 * ((d.month - 14) div 12))) div 12
        + (3 * ((d.year + 4900 + (d.month - 14) div 12) div 100)) div 4
        + d.day + 32075
 }
multi sub gmt-inner (\tz, \offset, \length) {
    # TODO: Check CLDR ticket #5382 to see if there is a separate short version.
    #
    # While the 'pattern' looks like a normal timepattern, based on the way that TR35
    # is written, it seems that in reality, we just treat HH:mm as a unique entity:
    #   Offset of  5h:      ±5
    #   Offset of  5h30m:   ±5:30
    #   Offset of 10h30m:  ±10:30
    #   Offset of 10h:     ±10
    # When it is "long", we should always show the full four digit form, and if seconds != 0, also those.
    # This is a relatively recent addition to the formatting standard, so things here may change, but
    # I also don't really see this one being used all that much either.

    return (tz<gmtZeroOffset> // 'GMT') if offset == 0;

    my ($second, $minute, $hour) = offset.abs.polymod: 60,60;
    my \pattern = tz<gmtFormat>.split(';').[offset > 0];

    if \length eq 'short' {
        pattern
            .subst('HH', $hour)
            .subst(':mm', offset % 60 == 0 ?? ":mm" !! '')   # quickfix to chop off minutes, may not be accurate
            .subst('mm', $minute < 10 ?? "0$minute" !! ~$minute)
    } else {
        pattern
            .subst('HH', $hour   < 10 ?? "0$hour"   !! ~$hour)
            .subst('mm', $minute < 10 ?? "0$minute" !! ~$minute)
           #.subst('ss', $minute < 10 ?? "0$second" !! ~$second) # we're supposed to magically know the format for this?
    }
}