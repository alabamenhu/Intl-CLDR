use lib '../../../';
use Intl::CLDR;

my %calendar-data;
   %calendar-data<root> := BEGIN { cldr-data-for-lang("root")<calendars>};

grammar DateTimePattern {
        token TOP                  {     <element>+     }
  proto token element              {         *          }
        token element:sym<literal> {      <text>+       }
        token element:sym<replace> { (<[a..zA..Z]>) $0* }
  proto token text                 {         *          }
        token text:sym<apostrophe> {        \'\'        }
        token text:sym<literal>    {   <-[a..zA..Z']>+  }
        token text:sym<quoted>     {         \'           # apostrophes only allowed
                                    ( <-[']>+ || \'\' )+  # if doubled, action reduces it
                                             \'         } # down to one
}

class DateTimePatternAction {
  method TOP                  ($/) { make $<element>.map: *.made }
  method element:sym<literal> ($/) { make %(type => 'literal', text => $<text>.map(*.made).join) }
  method element:sym<replace> ($/) { make %(type => 'replace', style => $/.Str.chars, code => $0)}
  method text:sym<apostrophe> ($/) { make "'" }
  method text:sym<literal>    ($/) { make $/.Str }
  method text:sym<quoted>     ($/) { make $0.map({ $_.Str eq "''" ?? "'" !! $_.Str }).join };
}

my @days = <null sun mon tue wed thu fri sat>;
sub time-pattern-replace ($datetime, @pattern, $language, $calendar) {
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
      # when 'z',  1..3 { short non location, fall back to O }
      # when 'z',     4 { short non location, fall back to OOOO }
      # when 'Z',  1..3 { short non location, fall back to xxxx }
      # when 'Z',     4 { short non location, fall back to OOOO }
      # when 'Z',     5 { short non location, fall back to XXXXX }
        default { say "Unknown or unimplemented replacement value {$_[0]} (type {$_[1]})" }
      }) // '' # and if anything bombs, nothing TODO use the last-resort values (normally numeric)
    }
  }
}

sub language($language) {
  ##say "Getting calendar data for $language ", %calendar-data{$language}:exists ?? '(loaded)' !! '(unloaded)';
  unless %calendar-data{$language}:exists {
    %calendar-data{$language} := cldr-data-for-lang($language)<calendars>;
  }
  %calendar-data{$language}
}

sub format-time ($time, :$calendar = 'gregorian', :$length = 'medium', :$alt = 'standard') {
  say %calendar-data{$calendar}<timeFormats>{$length};
}
