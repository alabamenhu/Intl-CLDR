unit class CLDR is repr('Uninstantiable');

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

has $.supplement;

has CLDR-Languages;



# This forces loading the first one
BEGIN sink CLDR-Languages<root>;