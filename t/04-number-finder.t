use Test;

grammar Grammar {
  use Intl::CLDR::Numbers::Finder;
  # The test uses wildcards on either side to check that we don't
  # overconsume
  token TOP ($lang) { .*? <local-number($lang)> .* }
}
class Action {
  use Intl::CLDR::Numbers::Finder;
  also does Local-Numbers;
  method TOP ($/) { make $<local-number>.made }
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


done-testing();