use Intl::CLDR::Immutability;
unit class CLDR is repr('Uninstantiable') is Associative;

=begin pod

=head1 The CLDR Database

The CLDR database for Raku is a lazy-loading database with options to give choice between
flexibility and speed.  To use

    use CLDR;
    CLDR.languages{$language-code};

The object returned will be C<CLDR-Language> that contains all of the information for that
language.  Every item in the CLDR database is an object with two means of access: a hashy access
via C<{'foo'}>, and an attribute access.  The latter is faster, but requires the awkward C<"$foo"()>
manner of access if you want to interpolate something.  Items that are inherently positional offer
both hashy and listy access (but do not offer attribute access, since numbers are not valid identifier).
Thus the following are equivalent:

    my $spanish = cldr-data-for-lang 'es';

    $spanish.calendars.months.stand-alone.wide[2];
    $spanish<calendars><months><stand-alone><wide><2>;
    $spanish<calendars><months><stand-alone><wide>[2];
    $spanish{'calendars'}{'months'}{'stand-alone'}{'wide'}{'2'};

Module authors are strongly encouraged to use attribute access whenever possible because of its efficiency,
and for both simplicity (and increased efficiency), binding to subelements.

=end pod

use Intl::CLDR::Types::Language;
my $supplement;
my CLDR-Language %languages;

method FALLBACK ($method){
    self.AT-KEY($method)
}

method EXISTS-KEY(\key) {
    return True;
    # we should always return at least root
}

method AT-KEY(\key) {
    # Immediately return if we have it already
    .return with %languages{key};

    # Else begin searching for it
    my @subtags = key.split('-');

    # TODO Some better logic needs to be placed here for peeling off subtags.  That may best go into
    # the LanguageTag module instead (for example, if given en-Latn-UK only en will be loaded, but Latn is
    # assumed for en.)
    #
    # For future optimizations here, it's worth noting that no CLDR data has a tag other than
    # language/script/region, so we can ignore probably pay attention to only the first three safely.
    while @subtags {
        my $language = @subtags.join('-');
        last with %languages{$language};
        try {
            quietly { # The .extension test will generate a warning
                if %?RESOURCES{"languages-binary/{ $language }.data"}.extension {
                    # Quick check for file existence in resources
                    %languages{$language} := load-data $language;
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
        %languages<root> = load-data('root') unless %languages<root>:exists
    }

    # If the loaded data doesn't match the request tag, bind the two together
    # so that future requests can be made instantaneously.
    %languages{key} := %languages{$language} if key ne $language;

    %languages{key}
}


# This sub assumes that we've validated the existence of the data.
sub load-data($tag) {
    use Intl::CLDR::Util::StrDecode;

    my \strs = %?RESOURCES{"languages-binary/{ $tag }.strings"}.slurp;
    my \blob = %?RESOURCES{"languages-binary/{ $tag }.data"}.slurp(:bin);

    StrDecode::prepare(strs);

    my uint64 $offset = 0;
    # Can't be inlined
    return CLDR-Language.new: blob, $offset;
}