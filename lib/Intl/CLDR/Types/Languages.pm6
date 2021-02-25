unit class CLDR::Languages;
    also does Associative;

use Intl::CLDR::Types::Language;

has CLDR::Language %!languages;

method EXISTS-KEY(\key) {
    return True;
    # we should always return at least root
}

method AT-KEY (\key) {
    # Immediately return if we have it already
    .return with %!languages{key};

    # Else begin searching for it
    my @subtags = key.Str.split('-');

    # TODO Some better logic needs to be placed here for peeling off subtags.  That may best go into
    # the LanguageTag module instead (for example, if given en-Latn-UK only en will be loaded, but Latn is
    # assumed for en.)
    #
    # For future optimizations here, it's worth noting that no CLDR data has a tag other than
    # language/script/region, so we can ignore probably pay attention to only the first three safely.
    while @subtags {
        my $language = @subtags.join('-');
        last with %!languages{$language};
        try {
            quietly { # The .extension test will generate a warning
                if %?RESOURCES{"languages-binary/{ $language }.data"}.extension {
                    # Quick check for file existence in resources
                    %!languages{$language} := load-data $language;
                    last;
                }
            }
        }
        @subtags.pop;
    }

    # If no subtags were left after peeling, there is no CLDR data for the language.
    # The data for 'root' is used instead.  Sad days.
    my $language = @subtags ?? @subtags.join('-') !! 'root';
    if $language eq 'root' {
        %!languages<root> = load-data('root') unless %!languages<root>:exists
    }

    # If the loaded data doesn't match the request tag, bind the two together
    # so that future requests can be made instantaneously.
    %!languages{key} := %!languages{$language} if key ne $language;

    %!languages{key}
}

# This sub assumes that we've validated the existence of the data.
sub load-data($tag) {
    use Intl::CLDR::Util::StrDecode;

    my str @strs = %?RESOURCES{"languages-binary/" ~ $tag ~ ".strings"}.split(31.chr);
    my     \blob = %?RESOURCES{"languages-binary/" ~ $tag ~ ".data"}.slurp( :bin );

    return CLDR::Language.new: blob, @strs, :data-file(%?RESOURCES{"languages-binary/" ~ $tag ~ ".data"});
}