unit module Intl::CLDR::Token::Alpha;

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
    token single { <escape> | . }
    token escape { \\u <( [0..9a..fA..F] )> }
}

class ExemplarCharactersActions {
    method TOP ($/) {
        my @text;
        @text.append($_) for $<char-seq>>>.made;
        make @text.unique
    }
    method char-seq ($/) {
        make $<range>.made  with $<range>;
        make $<multi>.made  with $<multi>;
        make $<single>.made with $<single>;
    }
    method multi  ($/) { make $<single>.join.list }
    method escape ($/) { make $/.parse-base(16).chr.list }
    method single ($/) {
        with $<escape> { make $<escape>.made }
        else           { make $/.Str.list    }
    }
    method range ($/) { make ($<start>.made.head .. $<end>.made.head).list }
}

sub get-local-letters ($case) {
  # avoid costly repeated lookups/calculations
  state %cache-standard;
  state %cache-auxiliary;

  .return
    with ($*broad
      ?? %cache-auxiliary{$*locale}{$case}
      !! %cache-standard{ $*locale}{$case});

  use Intl::CLDR;
  my @subtags = $*locale.split('-');
  my $alt-locale;
  my $exemplars;

  while @subtags {
    $alt-locale = @subtags.join;
    last if $exemplars = cldr-data-for-lang($alt-locale)<characters><exemplarCharacters>;
    pop @subtags;
  }

  $exemplars = cldr-data-for-lang('root')<characters><exemplarCharacters> unless @subtags;

  # There is definitely a more efficient way -- wanted to get this coded up quickly for CiC 2020

  my  @standard-lower = ExemplarCharacters.parse($exemplars<standard>,  :actions(ExemplarCharactersActions)).made;
  my @auxiliary-lower = ExemplarCharacters.parse($exemplars<auxiliary>, :actions(ExemplarCharactersActions)).made;
     @auxiliary-lower.append: @standard-lower;

  my    @standard-upper = @standard-lower.map: *.?uc;
  my   @auxiliary-upper = @auxiliary-lower.map: *.?uc;

  %cache-standard{ $alt-locale}<lower> := @standard-lower;
  %cache-standard{ $alt-locale}<upper> := @standard-upper;
  %cache-standard{ $alt-locale}<alpha> := Array.new: |@standard-lower, |@standard-upper;
  %cache-auxiliary{$alt-locale}<lower> := @auxiliary-lower;
  %cache-auxiliary{$alt-locale}<upper> := @auxiliary-upper;
  %cache-auxiliary{$alt-locale}<alpha> := Array.new: |@auxiliary-lower, |@auxiliary-upper;

  %cache-standard{ $*locale} := %cache-standard{ $alt-locale};
  %cache-auxiliary{$*locale} := %cache-auxiliary{$alt-locale};

  $*broad
     ?? %cache-auxiliary{$*locale}{$case}
     !! %cache-standard{ $*locale}{$case}
}

my token local-alpha (Str() $*locale = "en", :$*broad = False) is export {
    { $*ERR.say: $*locale }
    :my @letters := get-local-letters('alpha');
    @letters
}

my token local-upper (Str() $*locale = "en", :$*broad = False) is export {
    :my @letters := get-local-letters('upper');
    @letters
}

my token local-lower (Str() $*locale = "en", :$*broad = False) is export {
    :my @letters := get-local-letters('lower');
    @letters
}
