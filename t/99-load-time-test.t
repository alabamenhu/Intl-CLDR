use Intl::CLDR;
use Test;

done-testing;
exit;

my $time = now;
say CLDR<en>.dates.calendars.gregorian.months.stand-alone.wide[11];
say CLDR<ast>.dates.calendars.gregorian.months.stand-alone.wide[11];
say CLDR<ar>.dates.calendars.gregorian.months.stand-alone.wide[11];
say CLDR<ru>.dates.calendars.gregorian.months.stand-alone.wide[11];
say CLDR<zh>.dates.calendars.gregorian.months.stand-alone.wide[11];
#say CLDR<en>.dates.calendars.gregorian.months.stand-alone.wide[11];
say now - $time;

# Speed data:
# Eager @language 0.87515888 0.89941539 0.86026274 0.87775793 0.8947327  0.896006  0.87897457 0.8824534 0.88547485 0.86474689
# Lazy @language  0.487586   0.48318293 0.4949672  0.485313   0.52458301 0.5056607 0.49984916 0.4980735 0.4963816  0.5084875
#
#


$time = now;
say CLDR<en>.dates.calendars.gregorian.months.stand-alone.wide[11];
say CLDR<ast>.dates.calendars.gregorian.months.stand-alone.wide[11];
say CLDR<ar>.dates.calendars.gregorian.months.stand-alone.wide[11];
say CLDR<ru>.dates.calendars.gregorian.months.stand-alone.wide[11];
say CLDR<zh>.dates.calendars.gregorian.months.stand-alone.wide[11];
#say CLDR<en>.dates.calendars.gregorian.months.stand-alone.wide[11];
say now - $time;

# Speed data:
# Eager @language 0.0003076 0.000297  0.00032552 0.00032676 0.000297  0.0002976  0.0003199   0.0003535 0.0003071  0.000342
# Lazy @language  0.0003798 0.0004655 0.00043866 0.000378   0.0003691 0.00038276 0.000360024 0.0003852 0.00038173 0.00043363
#
#

my $en = CLDR<en>;
my $ast = CLDR<ast>;
my $ru = CLDR<ru>;
my $ar = CLDR<ar>;
my $zh = CLDR<zh>;

$time = now;
say $en.dates.calendars.gregorian.months.stand-alone.wide[11];
say $ast.dates.calendars.gregorian.months.stand-alone.wide[11];
say $ar.dates.calendars.gregorian.months.stand-alone.wide[11];
say $ru.dates.calendars.gregorian.months.stand-alone.wide[11];
say $zh.dates.calendars.gregorian.months.stand-alone.wide[11];
#say CLDR<en>.dates.calendars.gregorian.months.stand-alone.wide[11];
say now - $time;

$time = now;
say CLDR<en>.numbers.symbols.latin.exponential;
say CLDR<ast>.numbers.symbols.latin.exponential;
say CLDR<ar>.numbers.symbols.latin.exponential;
say CLDR<ru>.numbers.symbols.latin.exponential;
say CLDR<zh>.numbers.symbols.latin.exponential;
#say CLDR<en>.dates.calendars.gregorian.months.stand-alone.wide[11];
say now - $time;

$time = now;
say CLDR<en>.numbers.symbols.latin.exponential;
say CLDR<ast>.numbers.symbols.latin.exponential;
say CLDR<ar>.numbers.symbols.latin.exponential;
say CLDR<ru>.numbers.symbols.latin.exponential;
say CLDR<zh>.numbers.symbols.latin.exponential;
#say CLDR<en>.dates.calendars.gregorian.months.stand-alone.wide[11];
say now - $time;
