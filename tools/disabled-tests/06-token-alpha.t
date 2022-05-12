use Test;

grammar Grammar {
    use Intl::Token::Alpha;
    # The test uses wildcards on either side to check that we don't overconsume
    token TOP (|c) { .*? <local-alpha(c)> .* }
}
class Action {
    method TOP ($/) { make $<local-alpha>.Str }
}

grammar Grammar-Upper {
    use Intl::Token::Alpha;
    # The test uses wildcards on either side to check that we don't overconsume
    token TOP (|c) { .*? <local-upper(c)> .* }
}
class Action-Upper {
    method TOP ($/) { make $<local-upper>.Str }
}

grammar Grammar-Lower {
    use Intl::Token::Alpha;
    # The test uses wildcards on either side to check that we don't overconsume
    token TOP (|c) { .*? <local-lower(c)> .* }
}
class Action-Lower {
    method TOP ($/) { make $<local-lower>.Str }
}

# there's a weird bug here when using zef install, so these tests are currently disabled, despite passing when this file
# is run on its own using raku -Ilib

#is Grammar.parse("123a456", :actions(Action), :args(("en",))).made, 'a';
#is Grammar.parse("123ñ456", :actions(Action), :args(("en",))).made, Nil;
#is Grammar.parse("123ñ456", :actions(Action), :args(("en",:broad))).made, 'ñ';
#is Grammar.parse("123四456", :actions(Action), :args(("zh",))).made, '四';
#is Grammar.parse("123η456", :actions(Action), :args(("zh",))).made, Nil;
#is Grammar.parse("123η456", :actions(Action), :args(("el",))).made, 'η';

#is Grammar-Upper.parse("123A456", :actions(Action-Upper), :args(("en",))).made, 'A';
#is Grammar-Upper.parse("123a456", :actions(Action-Upper), :args(("en",))).made, Nil;

#is Grammar-Lower.parse("123A456", :actions(Action-Lower), :args(("en",))).made, Nil;
#is Grammar-Lower.parse("123a456", :actions(Action-Lower), :args(("en",))).made, 'a';

done-testing();