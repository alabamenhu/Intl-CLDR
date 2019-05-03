unit module Calendar;
use Intl::CLDR::Immutability;

my $epitaph = "Foo :(";
# Note that the fall backs are not optimized.  They should go ahead and bind results.

class CLDR-DayPeriodWidth       is CLDR-Item is export {                                                  }
class CLDR-DayPeriodContext     is CLDR-Item is export { method NEW-ITEM(|) { CLDR-DayPeriodWidth.new   } }
class CLDR-DayPeriods           is CLDR-Item is export { method NEW-ITEM(|) { CLDR-DayPeriodContext.new } } # handle last resort here, goes to AM / PM

class CLDR-DayWidth             is CLDR-Item is export {                                                  }
class CLDR-DayContext           is CLDR-Item is export { method NEW-ITEM(|) { CLDR-DayWidth.new         } }
class CLDR-Days                 is CLDR-Item is export { method NEW-ITEM(|) { CLDR-DayContext.new       }
  my %lr-days     := BEGIN { my %h := CLDR-DayWidth.new;     %h.ADD-TO-DATABASE($_, ~$_)                         for 0..7;  %h};
  method AT-KEY(*@keys) { self.CLDR-Item::AT-KEY(|@keys) // %lr-days                                    } }
class CLDR-MonthWidth           is CLDR-Item is export {                                                  }
class CLDR-MonthContext         is CLDR-Item is export { method NEW-ITEM(|) { CLDR-MonthWidth.new       } }
class CLDR-Months               is CLDR-Item is export { method NEW-ITEM(|) { CLDR-MonthContext.new     }
  my %lr-months   := BEGIN { my %h := CLDR-MonthWidth.new;   %h.ADD-TO-DATABASE($_, ($_ < 10 ?? '0' !! '') ~ $_) for 1..13; %h};
  method AT-KEY(*@keys) { self.CLDR-Item::AT-KEY(|@keys) // %lr-months                                  } }

class CLDR-QuarterWidth         is CLDR-Item is export {                                                  }
class CLDR-QuarterContext       is CLDR-Item is export { method NEW-ITEM(|) { CLDR-QuarterWidth.new     } }
class CLDR-Quarters             is CLDR-Item is export { method NEW-ITEM(|) { CLDR-QuarterContext.new   }
  my %lr-quarters := BEGIN { my %h := CLDR-QuarterWidth.new; %h.ADD-TO-DATABASE($_, ~$_)                         for 1..4;  %h};
  method AT-KEY(*@keys) { self.CLDR-Item::AT-KEY(|@keys) // %lr-quarters                                } }

class CLDR-EraWidth             is CLDR-Item is export {                                                  }
class CLDR-Eras                 is CLDR-Item is export { method NEW-ITEM(|) { CLDR-EraWidth.new         }
  my %lr-eras     := BEGIN { my %h := CLDR-EraWidth.new;     %h.ADD-TO-DATABASE(0, 'BC'); %h.ADD-TO-DATABASE(1, 'AD');      %h};
  method AT-KEY(|c)     { self.CLDR-Item::AT-KEY(c) // %lr-eras                                         } }

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


class CLDR-Calendar is CLDR-Item is export {
  multi method NEW-ITEM('months'          ) { CLDR-Months.new           }
  multi method NEW-ITEM('quarters'        ) { CLDR-Quarters.new         }
  multi method NEW-ITEM('days'            ) { CLDR-Days.new             }
  multi method NEW-ITEM('dayPeriods'      ) { CLDR-DayPeriods.new       }
  multi method NEW-ITEM('eras'            ) { CLDR-Eras.new             }
  multi method NEW-ITEM('dateFormats'     ) { CLDR-DateFormats.new      }
  multi method NEW-ITEM('timeFormats'     ) { CLDR-TimeFormats.new      }
  multi method NEW-ITEM('dateTimeFormats' ) { CLDR-DateTimeFormats.new  }
  multi method NEW-ITEM('availableFormats') { CLDR-AvailableFormats.new }
  multi method NEW-ITEM('intervalFormats' ) { CLDR-AvailableFormats.new }
  multi method NEW-ITEM(|                 ) { CLDR-Item.new             }
  #method gist { 'CLDR-Calendar:' ~ self.keys.join('-') }
}


class CLDR-Calendars is CLDR-Item is export {
  method NEW-ITEM(|) { CLDR-Calendar.new }
  # The fallback calendar is 'gregorian' but
  # TODO more complex selection logic, see DateFormatSymbols::initializeData @ dtfmtsym.cpp #2116-2155
  method AT-KEY(|c) { self.CLDR-Item::AT-KEY(c) // self.CLDR-Item::AT-KEY('gregorian') }
}
