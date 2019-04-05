use Test;
use Intl::CLDR::Plurals;

is plural-count(0,"en"), "other";
is plural-count(1,"en"), "one";
is plural-count(2,"en"), "other";
is plural-count(0,"pt"), "one";
#is plural-count(1,"en",:type<ordinal>), "one";
#is plural-count(2,"en",:type<ordinal>), "two";
#is plural-count(3,"en",:type<ordinal>), "few";
#is plural-count(4,"en",:type<ordinal>), "other";

done-testing();
