use Test;

grammar Grammar {
  use Intl::Token::Number;
  # The test uses wildcards on either side to check that we don't
  # overconsume
  token TOP ($lang) { .*? <local-number($lang)> .* }
}
class Action {
  method TOP ($/) { make +$<local-number> }
}

is Grammar.parse("aaa1aaa",           :actions(Action), :args(("en",))).made, 1;
is Grammar.parse("aaa1,000aaa",       :actions(Action), :args(("en",))).made, 1000;
is Grammar.parse("aaa1.000aaa",       :actions(Action), :args(("en",))).made, 1;
is Grammar.parse("aaa1,000aaa",       :actions(Action), :args(("es",))).made, 1;
is Grammar.parse("aaa1.000aaa",       :actions(Action), :args(("es",))).made, 1000;
is Grammar.parse("aaa0,1234E5aaa",    :actions(Action), :args(("fr",))).made, 12340;
is Grammar.parse("aaa0,1234 E 5aaa",  :actions(Action), :args(("fr",))).made, 12340;
is Grammar.parse("aaa0,1234 E +5aaa", :actions(Action), :args(("fr",))).made, 12340;
is Grammar.parse("aaa0,1234 E -5aaa", :actions(Action), :args(("fr",))).made, 0.000001234;
is Grammar.parse("aaa99%aaa",         :actions(Action), :args(("de",))).made, 0.99;
is Grammar.parse("aaa99   %aaa",      :actions(Action), :args(("de",))).made, 0.99;
is Grammar.parse("ببب٢٨ببب",          :actions(Action), :args(("ar",))).made, 28;

my $text = "Houston is the most populous city in the U.S. state of Texas, fourth most populous city in the United States,
            most populous city in the Southern United States, as well as the sixth most populous in North America,
            with an estimated 2019 population of 2,320,268. Located in Southeast Texas near Galveston Bay and the Gulf
            of Mexico, it is the seat of Harris County and the principal city of the Greater Houston metropolitan area,
            which is the fifth most populous metropolitan statistical area in the United States and the second most
            populous in Texas after the Dallas-Fort Worth metroplex, with a population of 6,997,384 in 2018.

            Comprising a total area of 637.4 square miles (1,651 km2), Houston is the eighth most expansive city in the
            United States (including consolidated city-counties). It is the largest city in the United States by total
            area, whose government is not consolidated with that of a county, parish or borough. Though primarily in
            Harris County, small portions of the city extend into Fort Bend and Montgomery counties, bordering other
            principal communities of Greater Houston such as Sugar Land and The Woodlands.

            Houston's characteristic subtropical humidity often results in a higher apparent temperature, and summer
            mornings average over 90% relative humidity"; # Source. Wikipedia article, except the last line

#use Intl::Token::Number;
#my $total = 0;
#$text ~~ m:g/<local-number: 'en'>/;
#for $<> -> $/ {
#    print "$total + $<local-number>";
#    $total += $<local-number>
#}
#is $total, 9323980.3;

done-testing();