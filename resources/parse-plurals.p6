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

class PluralAction { 
  method TOP ($/) {
    make $<condition>.made
  }
  method condition ($/) {
	  make $<and>.map(*.made).join( ' || ' );
  }
  method and ($/) {
	  make "(" ~ $<relation>.map(*.made).join(') && (') ~ ")";
  }
  method relation ($/) {
	  make $<is-relation>.made if $<is-relation>;
	  make $<in-relation>.made if $<in-relation>;
	  $<within-relation>.made;
  }
  method is-relation ($/) {
	  make $<expr>.made ~ ($0 eq 'is' ?? ' == ' !! ' != ') ~ $<value>.made
  }
  method in-relation ($/) {
	  my %list := $<range-list>.made;
	  my $values = %list<values>.join("|");
	  my $ranges = %list<ranges>.map({ '(' ~ $_<start> ~ '..' ~ $_<end> ~ ')' }).join("|");
	  make $<expr>.made
		  ~ (($0.Str.starts-with: 'in'|'=') ?? ' ∈ ' !! ' !∈ ')
		  ~ $values
		  ~ ('|' if $values ne '' && $ranges ne '')
		  ~ $ranges;
  }
  method within-relation ($/) {
	  # This is currently not used in any plural rules
	  # And thus is intentionally left unimplemented at present
	  die "-(not) within- has NOT been implemented for plural rules.  If not an error, implement."
  }
  method expr ($/) {
    make $<operand>.made ~ ( ( ' mod ' ~ $<value>) if $<value> )
  }
  method operand ($/) {
	   make '$^x.' ~ $/.Str
  }
  method range-list ($/) {
	  my @values = $0.grep({$_{"value"} :exists}).map(*<value>.made);
	  my @ranges = $0.grep({$_{"range"} :exists}).map(*<range>.made);
	  make %(:@values, :@ranges);
  }
  method range ($/) { make %(start => $<value>[0].Str, end => $<value>[1].Str) }
  method value ($/) { make $/.Str }
}

my $file = open "PluralLogic.data", :w;

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
      my $logic = '{"' ~ $count ~ '" if ' ~ Plural.parse($category.nodes.first.Str, :actions(PluralAction)).made ~ "}";
      say "  $count: $logic";
      $file.say(@languages.join(',') ~ ":c:$logic");
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
      my $logic = '{"' ~ $count ~ '" if ' ~ Plural.parse($category.nodes.first.Str, :actions(PluralAction)).made ~ "}";
      say "  $count: $logic";
      $file.say(@languages.join(',') ~ ":o:$logic");
    }
  }
}

close $file;
