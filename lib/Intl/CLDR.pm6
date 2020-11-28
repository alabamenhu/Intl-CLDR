unit module CLDR;
use Intl::CLDR::Classes::Base;

=begin pod

=head1 The CLDR Database

The CLDR database for Raku is a lazy-loading database with options to give choice between
flexibility and speed.  To use

    use CLDR;
    cldr-data-for-lang $language-code;

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

=head2 Immutability

CLDR items are generally immutable, and will generate a run-time error if you attempt to modify them.
In the future, a mutable version will be provided upon access via C<.clone>.

If you really need to edit the database, you may only add elements by using C<.ADD-TO-DATABASE(@,$)>.
You should not ever need to do this, though.  If you feel like you really need to, peruse the code
to figure out how it works, and also contact me so I can try to accommodate whatever you are trying
to do to see if there might be a better way to support it.

=head2  Fallbacks

The CLDR specifies particular types of fallbacks, but the rules are fairly complex so they are handled
automatically for you.  Fallbacks are (currently) calculated at runtime, with the fallback choices
bound to the originally requested item so that subsequent access is faster.  Future versions may
pre-calculate such fallbacks.

=end pod


#sub EXPORT (*@args) {
#
#
#}

# To mirror Go's implementation: https://godoc.org/golang.org/x/text/unicode/cldr
#
# This module is where all CLDR data should be stored.
# Data is created with the resources/parse-main-file.p6 script.
# Data for root (which is probably the most complex with aliasing)
#   is loaded in the BEGIN block.
# All other languages are loaded upon request.
# These separators are used to avoid clashing with any

# This hash is not protected
my %data; # := CLDR-Item.new;

sub cldr-data-for-lang(Str() $tag) is export {

  # Inmediately return if it already has been loaded or requested
  .return with %data{$tag};

  # TODO Some better logic needs to be placed here for peeling off subtags.  That may best go into
  # the LanguageTag module instead (for example, if given en-Latn-UK only en will be loaded, but Latn is
  # assumed for en.)
  #
  # For future optimizations here, it's worth noting that no CLDR data has a tag other than
  # language/script/region, so we can ignore probably pay attention to only the first three safely.
  my @subtags = $tag.split('-');

  while @subtags {
    my $language = @subtags.join('-');
    last with %data{$language};
    try {
      quietly { # The .extension test will generate a warning
        if %?RESOURCES{"languages2/{$language}.data"}.extension { # this is the quick way to test to see if the file exists
          %data{$language} := load-data($language);
          last;
        }
      }
    }
    @subtags.pop;
  }

  # If no subtags were left after peeling, there is no CLDR data for the language.
  # The data for 'root' is used instead.  Sad days.
  my $language = @subtags.join('-') || 'root';

  # If the loaded data doesn't match the request tag, bind the two together 
  # so that future requests can be made instantaneously.
  %data{$tag} := %data{$language} if $tag ne $language;

  %data{$tag}
}

# This sub assumes that we've validated the existence of the data.
sub load-data($tag) {
  my \sep   = 31.chr;
  my \sep2  = 30.chr;

  my %h := CLDR-Language.new;

  for %?RESOURCES{"languages2/{$tag}.data"}.lines {
     %h.ADD-TO-DATABASE: $_.split(sep);         # Must be SmallEndian when split
  }

  # Once again, try and quietly are necessary here to avoid error and/or visible
  # warning if there are no aliases for the language.
  try { quietly {
    my @aliases = %?RESOURCES{"languages2/aliases/{$tag}.data"}.lines;
    my $test-count = 0;

    while @aliases {

      my ($from, $to) = @aliases.head.split(sep2);

      # For finding failed aliases
      # say "  Aliasing: ", $from.split(sep).join( ', ' ), ' --> ', $to.split(sep).join( ', ' );
      if my $source = %h.AT-KEY-CHAIN($to.split: sep) {
        %h.ALIAS-DATABASE-ITEM: $source, $from.split(sep);
        @aliases.shift;
        $test-count = 0;
      } else {
        last if $test-count = @aliases; # In some cases, (ast's hebrew calendar), the alias generation
                                        # will fail.  This is a temporary quick fix.
        @aliases.push: @aliases.shift;
      }
    }

  }} # quietly / try

  return %h;
}

%data<root> := BEGIN { load-data('root') };
