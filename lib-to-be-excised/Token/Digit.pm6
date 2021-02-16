unit module Intl::CLDR::Token::Digit;

sub get-local-digits {
    # avoid costly repeated lookups/calculations
    state %cache;
    state %cache-broad;

    .return with %cache{$*locale};

    use Intl::CLDR;
    my @subtags = $*locale.split('-');
    my $alt-locale;
    my $exemplars;

    while @subtags {
        $alt-locale = @subtags.join;
        last if $exemplars = cldr-data-for-lang($alt-locale)<characters><exemplarCharacters><punctuation>;
        pop @subtags;
    }

    $exemplars = cldr-data-for-lang('root')<characters><exemplarCharacters><punctuation> unless @subtags;

    say $exemplars;
    say ExemplarCharacters.parse('[ a b c ]');
    say ExemplarCharacters.parse($exemplars);
    say ExemplarCharacters.parse($exemplars, :actions(ExemplarCharactersActions)).made;

    my @punct = ExemplarCharacters.parse($exemplars, :actions(ExemplarCharactersActions)).made;

    %cache{$alt-locale} := @punct;

    %cache{$*locale} := %cache{$alt-locale};
}

my token local-punct (Str() $*locale = "en", :$*broad ) is export {
    :my @digits := get-local-digits;
    @digits
}
