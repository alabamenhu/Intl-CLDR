use Test;
use Intl::CLDR;

say cldr<en>.characters.exemplar.standard;

#my $time = now;
#for <en ar ru zh ast ko el> -> $language {
#    say format-datetime $datetime, :$language
#}
#say "Without cache took {now - $time}";
#
#$time = now;
#for <en ar ru zh ast ko el> -> $language {
#    say format-datetime($datetime, :$language)
#}
#say "With cache took {now - $time}";
#
#$time = now;
#for <en ar ru zh ast ko el> -> $language {
#    say $datetime
#}
#say "Core DateTime took ", now - $time;

done-testing();