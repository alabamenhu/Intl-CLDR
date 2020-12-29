unit module Plurals;
use Intl::CLDR::Plurals::Classes;
use Intl::LanguageTag;

my %checkers = {
  my %data = ();
  #for "../../../resources/PluralLogic.data".IO.lines -> $line {
  for %?RESOURCES<PluralLogic.data>.lines -> $line {
    my @elements = $line.split(":",3);
    my @languages = @elements[0].split(",");
    my $type = @elements[1] eq 'c' ?? 'cardinal' !! 'ordinal';
    my $checker = Plural.parse(@elements[2], :actions(PluralAction)).made;
    %data{$_}{$type}.push($checker) for @languages;
  }
  %data;
}


multi sub plural-count($number, Str        $lang, :$type = 'cardinal') is export {
  samewith $number, LanguageTag.new($lang), :$type
}
multi sub plural-count($number, LanguageTag $tag, :$type = 'cardinal') is export {
  # More robust handling necessary, theoretically, as some languages (*cough
  # Portuguese cough*) have country codes also included.  Hard code it?
  if my $num = NumExt.new($number) {
    if my @counts = |%checkers{$tag.language.code}{$type} {
      for @counts -> $count {
        next unless my $successful-result = $count.check($num);
        return $successful-result;
      }
      return 'other'; # If nothing matches, the final answer is "other" (which
                      # is not explicitly tested for in any language)
    }
    return 'other'; # Either the language does not have number concordance or
                    # it has not been catalogued, either way, default is 'other'
  }
  return False; # Not a number
}
