#| A class implementing CLDR's <pluralRuleSet> element
unit class CLDR::PluralRuleSet;
    use Intl::CLDR::Core;
    also does CLDR::Item;

has Str $.zero;  #= The rule for when a number follows 'zero' formatting
has Str $.one;   #= The rule for when a number follows 'one' formatting
has Str $.two;   #= The rule for when a number follows 'two' formatting
has Str $.few;   #= The rule for when a number follows 'few' formatting
has Str $.many;  #= The rule for when a number follows 'many' formatting

#| Creates a new CLDR-Plurals object
method new(\blob, uint64 $offset is rw --> ::?CLASS) {
    use Intl::CLDR::Util::StrDecode;

    self.bless:
        zero => StrDecode::get(blob, $offset),
        one  => StrDecode::get(blob, $offset),
        two  => StrDecode::get(blob, $offset),
        few  => StrDecode::get(blob, $offset),
        many => StrDecode::get(blob, $offset),

}

##`<<<<< # GENERATOR: This method should only be uncommented out by the parsing script
method encode(%plurals) {
    my $result = buf8.new;

    use Intl::CLDR::Util::StrEncode;

    for <zero one two few many> -> $count {
        with %plurals{$count} {
            $result ~= StrEncode::get( .substr: 0, .index('@') );
        } else {
            $result ~= StrEncode::get('');
        }
    }

    $result
}
method parse(\base, \xml) {
    use Intl::CLDR::Util::XML-Helper;

    my $rules-xml = (
        # The stupid .subst('-','_') is due to CLDR internally preferring Unicode
        # rather than BCP47 language tags.  Only Portuguese has separate rules based
        # for plural counts, but there may be more down the road
        xml.&elem('plurals').&elems('pluralRules').grep($*lang.subst('-','_') (elem) *.<locales>.words) ||
        xml.&elem('plurals').&elems('pluralRules').grep('root' (elem) *.<locales>.words)
    ).head;

    base{.<count>} = contents $_ for $rules-xml.&elems('pluralRule');
}
#>>>>> # GENERATOR
