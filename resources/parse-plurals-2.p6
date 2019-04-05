use XML;

grammar Plural {
  # Rules found at http://unicode.org/reports/tr35/tr35-numbers.html#Language_Plural_Rules
  rule  TOP             { <condition> <samples> }
  rule  condition       { <and>+ % 'or' }
  rule  and             { <relation>+ % 'and' }
  rule  relation        { <is-relation> || <in-relation> || <within-relation> }
  rule  is-relation     { <expr> 'is' ('not'?) 'in' <value> }
  rule  in-relation     { <expr> ('not in' || 'in' || '=' || '!=') <range-list> }
  rule  within-relation { <expr>  ('not')? 'within' <range-list> }
  rule  expr            { <operand> (('mod' | '%') <value>)? }
  token operand         { <[niftvw]> }
  rule  range-list      { (<range> || <value>)* % ',' }
  token range           { <value> '..' <value> }
  token value           { <[0..9]>+ }
  token decimal-value   { <value> ('.' <value>)? }
  rule  samples         { (('@integer') <sample-list>)? (('@decimal') <sample-list>)? }
  rule  sample-list     { <sample-range>+ % ',' (',' ('…'||'...'))? }
  rule  sample-range    { <decimal-value> ('~' <decimal-value>)? }
}



class NumExt {
  has $.original;
  has $.n; # absolute value
  has $.i; # integer digits of $.n
  has $.v; # count of visible fraction digits, with trailing zeros
  has $.w; # count of visible fraction digits, without trailing zeros
  has $.f; # visible fraction digits
  has $.t; # visible fractional digits without trailing zeros
  proto method new(|c) { * }
  multi method new(Numeric $original) { samewith $original.Str }
  multi method new(Str     $original) {
    $original ~~ /^
      ('-'?)         # negative marker [0]
      ('0'*)         # leading zeros [1]
      (<[0..9]>+)    # one or more integer values [2]
      [
        '.'          #   decimal pointer
        (<[0..9]>*?) #   any number of decimals [3]
        ('0'*)       #   with trailing zeros [4]
      ]?             # decimal group is optional
    $/;
    return False unless $/; # equivalent of death
    my $n = $original.abs;
    my $i = $2.Str.Int;
    my ($f, $t, $v, $w);
    if $3 { # the decimal matched
      $f = $3.Str ~ $4.Str;
      $t = $4.Str;
      $v = $f.chars;
      $w = $t.chars;
    } else { # no integer value
      ($f, $t, $v, $w) = 0 xx 4;
    }
    self.bless(:$original, :$n, :$i, :$f, :$t, :$v, :$w);
  }
}





class Logic::Condition {
  has @.options;
  method check(NumExt $x) { return ?@.options.any.check($x) }
}
class Logic::And {
  has @.relations;
  method check(NumExt $x) { return ?@.relations.all.check($x) }
}
class Logic::RelationIs {
  has $.expression;
  has $.not;
  has $.value;
  method check(NumExt $x) {
    my $expression-value = $.expression.evaluate($x);
    $.not
      ?? !$.value.equals($expression-value)
      !!  $.value.equals($expression-value)
  }
}
class Logic::RelationIn {
  has      $.expression;
  has Bool $.not;
  has      @.values;
  method check(NumExt $x) {
    my $expression-value = $.expression.evaluate($x);
    $.not
      ?? !?@.values.any.in-range($expression-value)
      !!  ?@.values.any.in-range($expression-value)
  }
}

class Logic::Expression {
  has $.operand;
  has $.mod = Nil;
  method evaluate($x) {
    if $.mod {
      return $.operand.value($x) mod $.mod;
    } else {
      return $.operand.value($x)
    }
  }
}
class Logic::Operand {
  has $.type;
  method value ($x) {
    given $.type {
      when 'n' { $x.n }
      when 'i' { $x.i }
      when 'v' { $x.v }
      when 'w' { $x.w }
      when 'f' { $x.f }
      when 't' { $x.t }
    }
  }
}
class Logic::SingleValue {
  has $.value;
  method equals(  $x) { $.value == $x }
  method in-range($x) { $.value == $x }
}
class Logic::RangeValue {
  has Range $.value;
  method equals(  $x) { $.value == $x }
  method in-range($x) { $x ∈ $.value}
}


class PluralActionObject { 
  method TOP ($/) {
    make $<condition>.made
  }
  method condition ($/) {
    make Logic::Condition.new(options => $<and>.map(*.made));
  }
  method and ($/) {
	  make Logic::And.new(relations => $<relation>.map(*.made));
  }
  method relation ($/) {
	  make $<is-relation>.made if $<is-relation>;
	  make $<in-relation>.made if $<in-relation>;
	  $<within-relation>.made;
  }
  method is-relation ($/) {
    make Logic::RelationIs.new(
      expression => $<expr>.made,
      not        => ($0.Str.starts-with('not')),
      value      => $<value>.made
    );
	  make $<expr>.made ~ ($0 eq 'is' ?? ' == ' !! ' != ') ~ $<value>.made
  }
  method in-relation ($/) {
    make Logic::RelationIn.new(
      expression => $<expr>.made,
      not        => ?($0.Str.starts-with: 'not'|'!='),
      values     => $<range-list>.made
    );
  }
  method within-relation ($/) {
	  # This is currently not used in any plural rules
	  # And thus is intentionally left unimplemented at present
	  die "-(not) within- has NOT been implemented for plural rules.  If not an error, implement."
  }
  method expr ($/) {
    make Logic::Expression.new( operand => $<operand>.made, mod => ($<value> ?? $<value>.Str.Int !! Nil ))
  }
  method operand ($/) {
     make Logic::Operand.new(type => $/.Str )
  }
  method range-list ($/) {
	  my @values = $0.grep({$_{"value"} :exists}).map(*<value>.made);
	  my @ranges = $0.grep({$_{"range"} :exists}).map(*<range>.made);
	  make (|@values, |@ranges);
  }
  method range ($/) { make Logic::RangeValue.new( value => $<value>[0].Str.Int..$<value>[1].Str.Int ) }
  method value ($/) { make Logic::SingleValue.new( value => $/.Str ) }
}

my $file = open "PluralLogic.data", :w;

# Careful, sometimes the language codes may have a _, TODO
my $cardinal-xml = open-xml("supplemental/plurals.xml");
my @plural-rules = $cardinal-xml
                    .getElementsByTagName('plurals')
                    .first
                    .getElementsByTagName('pluralRules');
for @plural-rules -> $rule-group {
  my @languages = $rule-group<locales>.words;
  say "Processing cardinal language data for ", @languages.join(", ");
  my @plural-categories = $rule-group.getElementsByTagName('pluralRule');
  for @plural-categories -> $category {
    my $count = $category<count>;
    unless $count eq "other" {
      my $logic = Plural.parse($category.nodes.first.Str, :actions(PluralActionObject)).made;
      $file.say(@languages.join(',') ~ ":c:" ~ $count ~ ":" ~ $category.nodes.first.Str);
    }
  }
}


my $ordinal-xml = open-xml("supplemental/ordinals.xml");
@plural-rules = $ordinal-xml
                    .getElementsByTagName('plurals')
                    .first
                    .getElementsByTagName('pluralRules');
for @plural-rules -> $rule-group {
  my @languages = $rule-group<locales>.words;
  say "Processing ordinal language data for ", @languages.join(", ");
  my @plural-categories = $rule-group.getElementsByTagName('pluralRule');
  for @plural-categories -> $category {
    my $count = $category<count>;
    unless $count eq "other" {
      my $logic = Plural.parse($category.nodes.first.Str, :actions(PluralActionObject)).made;
      $file.say(@languages.join(',') ~ ":o:" ~ $count ~ ":" ~ $category.nodes.first.Str);
    }
  }
}


close $file;
