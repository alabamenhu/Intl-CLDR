unit module Classes;
use Intl::CLDR::Numbers::PatternParser;

class SymbolSet is export {
  has Str $.decimal;
  has Str $.group;
  has Str $.list;
  has Str $.percent-sign;
  has Str $.plus-sign;
  has Str $.minus-sign;
  has Str $.exponential;
  has Str $.superscripting-exponent;
  has Str $.per-mille;
  has Str $.infinity;
  has Str $.nan;
  has Str $.time-separator;
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
    return %(
    '.' => $!decimal,   '-' => $!minus-sign,   'E' => $!exponential,
    '+' => $!plus-sign, '%' => $!percent-sign, '‰' => $!per-mille,
    ',' => $!group,     '¤' => '¤', # This technically shouldn't be here, TODO rework to remove
    '∞' => $!infinity,  ':' => $!time-separator, 'nan' => $!nan,
    "×" => $!superscripting-exponent
    )
  }
}

class LazyFormat is export {
  has Str $.pattern;
  has $!formatted = False;
  has %!negative;
  has %!positive;
  method new (Str $pattern) { self.bless(:$pattern) }
  method format {
    unless $!formatted {
      $!formatted = True;
      my %format = parse-pattern($.pattern);
      %!positive = %format<positive>;
      %!negative = %format<negative>;
    }
    return %(positive => %!positive.deepmap(*.clone), negative => %!negative.deepmap(*.clone));
  }
}
