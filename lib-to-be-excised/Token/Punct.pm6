unit module Intl::CLDR::Token::Punct;

# This is bad copy copy from Alpha.pm6, and should be tossed into another submodule
grammar ExemplarCharacters {
    rule TOP { '[' <char-seq>+ ']' }
    rule char-seq {
        | <range>
        | <multi>
        | <single>
    }
    rule range {
        $<start>=<single>
        '-'
        $<end>=<single>
    }
    rule multi   { '{' <single>+ '}' }
    token single { <escape> | [\\]? $<literal>=[.] }
    proto token escape { * }
    token escape:hex  { \\u <( [0..9a..fA..F] )> }
    token escape:html { \\? '&' $<code>=[<.alpha>+] ';' }
}

class ExemplarCharactersActions {
    method TOP ($/) {
        my @text;
        @text.append($_) for $<char-seq>>>.made;
        @text.append: @text>>.uc;
        make @text.unique
    }
    method char-seq ($/) {
        make $<range>.made  with $<range>;
        make $<multi>.made  with $<multi>;
        make $<single>.made with $<single>;
    }
    method multi  ($/) { make $<single>.join.list }
    method escape:hex  ($/) { make $/.parse-base(16).chr.list }
    method escape:html ($/) {
        my $letter = do given $<code> {
            when 'amp' { '&' }
            when 'quot' { '"' }
            default     { say "Language loaded with weird exemplar character escape sequence: ", ~$<code> }
        }
        make $letter.list
    }
    method single ($/) {
        with $<escape> { make $<escape>.made }
        else           { make $<literal>.Str.list    }
    }
    method range ($/) { make ($<start>.made.head .. $<end>.made.head).list }
}

sub get-local-punct {
    # avoid costly repeated lookups/calculations
    state %cache;

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

my token local-punct (Str() $*locale = "en") is export {
    :my @punct := get-local-punct;
    @punct
}
