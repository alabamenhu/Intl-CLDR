use Test;

grammar Grammar {
    use Intl::Token::Punct;
    # The test uses wildcards on either side to check that we don't overconsume
    token TOP (|c) { .*? <local-punct(c)> .* }
}
class Action {
    method TOP ($/) { make $<local-punct>.Str }
}

is Grammar.parse("123!456", :actions(Action), :args(("en",))).made, '!';
is Grammar.parse("123?456", :actions(Action), :args(("en",))).made, '?';
is Grammar.parse('123"456', :actions(Action), :args(("en",))).made, '"';
is Grammar.parse('123a456', :actions(Action), :args(("en",))).made, Nil;

done-testing();