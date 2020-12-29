unit module Lists;
use Intl::BCP47;
use Intl::UserLanguage;

# The data imported by this module is created using the parse-list-formatting
# script that works on the main folder found from the CLDR.  For more
# information, see that particular file.

our %data = {
  my %collection;

  #for '../../../resources/ListFormatting.data'.IO.lines -> $line {
  for %?RESOURCES<ListFormatting.data>.lines -> $line {
    my @elements = $line.split(":", 4);
    %collection{@elements[0]}{@elements[1]}{@elements[2]} = @elements[3];
  }
  %collection;
}

multi sub format-list(@items is copy, :$language, :$type = "and") is export {
  samewith @items, :languages($language,), :$type;
}
multi sub format-list(@items is copy, Str :$languages, :$type = "and") is export {
  samewith @items, :languages($languages,), :$type;
}

# in case anything is not defined, this is the order to use:
my %try-order = (
  standard-narrow => <standard-narrow standard-short      and>,
      unit-narrow => <    unit-narrow     unit-short unit and>,
        or-narrow => <      or-narrow       or-short       or>,
   standard-short => <                standard-short      and>,
       unit-short => <                    unit-short unit and>,
         or-short => <                      or-short       or>,
             unit => <                               unit and>,
         standard => <                                    and>, # guaranteed
              and => <                                    and>, # guaranteed
               or => <                                     or>, # guaranteed
);

multi sub format-list(@items is copy, :@languages is copy = user-languages, :$type = "and") is export {
  $type = 'and' unless $type eq <and standard-short standard-narrow or
                                 or-short or-narrow unit unit-narrow
                                 unit-short>.any;

  @languages.push("en"); # The default if nothing else is found.
  my $language = '';

  # Determine the best language.  Begin with each language tag as passed, but
  # slowly reduce it downwards until one has a match.
  LanguageLoop:
  for @languages -> $language-tag {
    my @subtags = $language-tag.split('-');
    while @subtags {
      if %data{@subtags.join('-')}:exists {
        $language = @subtags.join('-');
        last LanguageLoop;
      }
      @subtags.pop;
    }
  }

  # Find the formatting type.  "and" and "or" are defined in the root, so
  # every language will have them guaranteed defined.  From there, it's just
  # a question of which is the optimal choice (basically, narrow -> short ->
  # normal, although unit can last case to and.)

  my %formatter;
  for %try-order{$type} {
    last if %formatter := %data{$language}{$type}
  }

  # Join based on the number.  Nothing returns nothing, single returns that
  # item unchanged.  Two uses the special pair formatter, and then three+
  # combines the first two and last two then reduces the list down using the
  # middle function.
  given @items {
    when  0 { return ''           }
    when  1 { return @items.first }
    when  2 {
      return @items.head ~ %formatter<2> ~ @items.tail
    }
    default {
      my $tail = @items.pop;
      @items.push(   @items.pop   ~ %formatter<end>     ~ $tail);
      @items.unshift(@items.shift ~ %formatter<start> ~ @items.shift);
      @items.unshift(@items.shift ~ %formatter<start> ~ @items.shift) while @items > 1;
      return @items.first;
    }
  }
}
