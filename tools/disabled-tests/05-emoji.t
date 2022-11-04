use Test;
use Intl::CLDR;
my $a = cldr-data-for-lang('en');
say $a;
say $a.characterLabels;
done-testing;
