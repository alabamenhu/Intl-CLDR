unit class CLDR-Database;

use Intl::CLDR::Types::Languages;

has CLDR-Languages  $.languages  = CLDR-Languages.new;
has Str $.supplement = "supplement!";