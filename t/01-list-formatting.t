use Test;
use Intl::CLDR::Lists;

my @list = <apple orange banana>;

is format-list(@list, :languages<en>             ), "apple, orange, and banana";
is format-list(@list, :languages<en>, :type<or>  ), "apple, orange, or banana";
is format-list(@list, :languages<en>, :type<unit>), "apple, orange, banana";

done-testing();
