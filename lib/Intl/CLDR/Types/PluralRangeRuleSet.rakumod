use Intl::CLDR::Immutability;

#| A class implementing CLDR's <pluralRanges> element
unit class CLDR-PluralRangeRuleSet is CLDR-ItemNew;

# There are only six possible plurals, for a total of 36 combinations.
# There may be some *slightly* more efficient storage methods, but
# at only 36 bytes, just mass storing every combination (defaulting
# to 'other') is the easiest and not terrible inefficient.

my str @results = <other zero one two few many>;
my Int %eqv     = other => 0, zero => 1, one => 2, two => 3, few => 4, many => 5;


has blob8 $!data;

#| Creates a new CLDR-Plurals object
method new(|c) {
    self.bless!bind-init: |c;
}

submethod !bind-init(\blob, uint64 $offset is rw) {

    $!data = blob.subbuf: $offset, 36;
    $offset += 36;

    self
}
my class Selector { ... }
trusts   Selector;

my class Selector {
    has $!from is built;
    has $!data is built;
    method new($from, $data) {
        self.bless(:$from, :$data)
    }
    method to (Str $to) {
        @results[ $!data[$!from * 6 + %eqv{$to} ] ]
    }
}

method from(Str $from) {
    Selector.new(%eqv{$from}, $!data)
}

##`<<<<< # GENERATOR: This method should only be uncommented out by the parsing script
method encode(%ranges) {

    # Combinations default to "other" (0)
    my $result = buf8.new:
        0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0;

    for %ranges.kv -> $key, $value {
        my ($start, $end) = $key.split('-');
        $result[%eqv{$start} * 6 + %eqv{$end}] = %eqv{$value};
    }

    $result

}
method parse(\base, \xml) {
    use Intl::CLDR::Util::XML-Helper;

    my $rules-xml =
        xml.&elem('plurals').&elems('pluralRanges').grep($*lang (elem) *.<locales>.words).head;

    with $rules-xml {
        base{.<start> ~ '-' ~ .<end>} = .<result> for $rules-xml.&elems('pluralRange');
    }else{
        base<other-other> = 'other'
    }
}
#>>>>> # GENERATOR
