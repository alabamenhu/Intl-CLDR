unit module Classes;

class SymbolSet is export {
  has str $.decimal;
  has str $.group;
  has str $.list;
  has str $.percent-sign;
  has str $.plus-sign;
  has str $.minus-sign;
  has str $.exponential;
  has str $.superscripting-exponent;
  has str $.per-mille;
  has str $.infinity;
  has str $.nan;
  has str $.time-separator;
  multi method new (Str $text) { samewith $text.split(31.chr) }
  multi method new (@s) {
    self.bless(
      :decimal(@s[0]),
      :group(@s[1]),
      :list(@s[2]),
      :percent-sign(@s[3]),
      :minus-sign(@s[4]),
      :plus-sign(@s[5]),
      :exponential(@s[6]),
      :superscripting-exponent(@s[7]),
      :per-mille(@s[8]),
      :infinity(@s[9]),
      :nan(@s[10]),
      :time-separator(@s[11])
    )
  }

  method symbols   {
    return Map.new(
    '.' => $!decimal,   '-' => $!minus-sign,   'E' => $!exponential,
    '+' => $!plus-sign, '%' => $!percent-sign, '‰' => $!per-mille,
    ',' => $!group,     '¤' => '¤', # This technically shouldn't be here, TODO rework to remove
    '∞' => $!infinity,  ':' => $!time-separator, 'nan' => $!nan,
    "×" => $!superscripting-exponent
    )
  }
}

class FormatPattern {
    has Int  $.maximum-integer-digits;
    has Int  $.maximum-fraction-digits;
    has Int  $.maximum-significant-digits;
    has Int  $.minimum-integer-digits;
    has Int  $.minimum-fraction-digits;
    has Int  $.minimum-significant-digits;
    has Int  $.minimum-exponent-digits;
    has str  $.pad-character;
    has Int  $.grouping-size;
    has Int  $.secondary-grouping-size;
    has Int  $.fraction-grouping-size;
    has Int  $.prefix;
    has Int  $.suffix;
    has Bool $.use-plus-sign;
}

class LazyFormat is export {
  has Str $.pattern;
  has $!formatted = False;
  has %!negative;
  has %!positive;
  method new (Str $pattern) { self.bless(:$pattern) }
  method format {
    unless $!formatted {
      use Intl::Numbers::PatternParser;

      $!formatted = True;
      my %format = parse-pattern $!pattern;
      %!positive = %format<positive>;
      %!negative = %format<negative>;
    }

    #return %(positive => %!positive.deepmap(*.clone), negative => %!negative.deepmap(*.clone));
    return %(positive => %!positive.clone, negative => %!negative.clone);
  }
}
