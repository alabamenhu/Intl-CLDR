#unit module CLDR;
#use lib '../../';
use Intl::CLDR::Immutability;
use Intl::CLDR::Classes::Base;
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

sub cldr-data-for-lang($tag) is export {
  # Inmediately return premade if it exists
  return %data{$tag} if %data{$tag}:exists;
  say "Requesting main CLDR data for $tag";

  # TODO Some better logic needs to be placed here for peeling off subtags.  That may best go into
  # the BCP47 module instead (for example, if given en-Latn-UK only en will be loaded, but Latn is
  # assumed for en.)
  my @subtags = $tag.split('-');
  say "  Subtags: ", @subtags;
  while @subtags {
    my $language = @subtags.join('-');
    last if %data{$language}:exists;
    try {
      quietly { # The .extension test will generate a warning
        if %?RESOURCES{"languages/{$language}.data"}.extension { # this is the quick way to test to see if the file exists
          %data{$language} := load-data($language);
          last;
        }
      }
    }
    @subtags.pop;
  }
  # If no subtags were left, there is no CLDR data for the language,
  # so we set the resolved language to the default 'root'
  my $language = @subtags ?? @subtags.join('-') !! 'root';

  %data{$tag} := %data{$language} if $tag ne $language;
  %data{$tag}
}

sub load-data($tag) {
  say "CLDR: Loading data for $tag";

  my \sep   = 31.chr;
  my \sep2  = 30.chr;

  my %h := CLDR-Language.new;

  for %?RESOURCES{"languages/{$tag}.data"}.lines {
    %h.ADD-TO-DATABASE: $_.split(sep);
  }
  try { quietly {
    my @aliases = %?RESOURCES{"languages/aliases/{$tag}.data"}.lines;
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
