use Test;
use lib '../lib';

subtest "Ge'ez numerals", {
  use Intl::CLDR::NumberSystems::Ge'ez;
  is ge'ez-numeral( 1), '፩';
  is ge'ez-numeral(10), '፲';
  is ge'ez-numeral(100), '፻';
  is ge'ez-numeral(1000), '፲፻';
  is ge'ez-numeral(10000), '፼';
  is ge'ez-numeral(100000), '፲፼';
  is ge'ez-numeral(1000000), '፻፼';
  is ge'ez-numeral(10000000), '፲፻፼';
  is ge'ez-numeral(100000000), '፼፼';
  is ge'ez-numeral(200000000), '፪፼፼';
  is ge'ez-numeral(63), '፷፫';
  is ge'ez-numeral(3683), '፴፮፻፹፫';
  is ge'ez-numeral(48253683), '፵፰፻፳፭፼፴፮፻፹፫';
}

subtest "Roman numerals", {
  use Intl::CLDR::NumberSystems::Roman;
  is roman-numeral(1), 'I';
  is roman-numeral(5), 'V';
  is roman-numeral(10), 'X';
  is roman-numeral(50), 'L';
  is roman-numeral(100), 'C';
  is roman-numeral(500), 'D';
  is roman-numeral(1000), 'M';
  is roman-numeral(44), 'XLIV';
  is roman-numeral(44, :additive<all>), 'XXXXIIII';
  is roman-numeral(44, :additive<small>), 'XLIIII';
  is roman-numeral(44, :additive<small>, :j), 'XLIIIJ';
  is roman-numeral(3, :j), 'IIJ';
  is roman-numeral(4000, :additive<all>), 'MMMM';
  #dies-ok roman-numeral(4000); # These currently actually cause the whole script to die
  #dies-ok roman-numeral(5000, :additive<all>);

}

done-testing();
