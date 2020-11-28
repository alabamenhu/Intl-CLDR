use Test;
use Intl::Numbers;


is format-number(123456789, :language<en>), "123,456,789";
#say format-number 123456789, :language<es>;
say format-number 123456789, :language<es>, :system<arab>, :type<percent>;
say format-number 123456789, :language<sd>;
done-testing();
