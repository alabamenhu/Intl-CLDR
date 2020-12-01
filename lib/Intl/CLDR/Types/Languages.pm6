unit class CLDR-Languages is Associative;

use CLDR-Language;
has CLDR-Language %!languages;

method EXISTS-KEY (\key) {
    %!languages{key}:exists
}

method AT-KEY (\tag) {
    .return with %!languages{tag};

    # TODO Some better logic needs to be placed here for peeling off subtags.  That may best go into
    # the LanguageTag module instead (for example, if given en-Latn-UK only en will be loaded, but Latn is
    # assumed for en.)
    #
    # For future optimizations here, it's worth noting that no CLDR data has a tag other than
    # language/script/region, so we can ignore probably pay attention to only the first three safely.
    my @subtags = tag.split('-');

    while @subtags {
        my $language = @subtags.join('-');
        last with %!languages{$language};
        try quietly { # The .extension test will generate a warning
            if %?RESOURCES{"languages2/{$language}.data"}.extension { # this is the quick way to test to see if the file exists
                %!languages{$language} := load-data($language);
                last;
            }

        }
        @subtags.pop;
    }

    # If no subtags were left after peeling, there is no CLDR data for the language.
    # The data for 'root' is used instead.  Sad days.
    my $language = @subtags.join('-') || 'root';

    # If the loaded data doesn't match the request tag, bind the two together
    # so that future requests can be made instantaneously.
    %!languages{tag} := %!languages{$language} if tag ne $language;

    %!languages{tag}
}

# This sub assumes that we've validated the existence of the data.
sub load-data(\tag --> CLDR-Language) {
    use Intl::CLDR::Util::StrDecode;

    my $string-data = %?RESOURCES{"languages-binary/{tag}.strings"}.slurp;
    my $tree-data   = %?RESOURCES{"languages-binary/{tag}.data"}.slurp;

    StrDecode::prepare($string-data);
    my uint64 $offset = 0; # must be on a separate line so it can be rw
    CLDR-Languages.new: $tree-data, $offset, self;
}
