unit class CLDR::Derivations;
    use Intl::CLDR::Core;
    also does CLDR::Item;

use Intl::CLDR::Types::Derivation;

#| A class implementing CLDR's <dates> element, containing information about formatting dates.

has CLDR::Derivation $.per;
has CLDR::Derivation $.times;
has CLDR::Derivation $.power;
has CLDR::Derivation $.prefix;

#| Creates a new CLDR-Dates object
method new(\blob, uint64 $offset is rw) {
    use Intl::CLDR::Util::StrDecode;

    self.bless:
        per    => CLDR::Derivation.new(blob, $offset),
        times  => CLDR::Derivation.new(blob, $offset),
        power  => CLDR::Derivation.new(blob, $offset),
        prefix => CLDR::Derivation.new(blob, $offset),

}

##`<<<<< # GENERATOR: This method should only be uncommented out by the parsing script
method encode(%*derivations) {
    my $result = buf8.new;

    $result ~= CLDR::Derivation.encode(%*derivations<per>   );
    $result ~= CLDR::Derivation.encode(%*derivations<times> );
    $result ~= CLDR::Derivation.encode(%*derivations<power> );
    $result ~= CLDR::Derivation.encode(%*derivations<prefix>);

    $result
}
method parse(\base, \xml) {
    use Intl::CLDR::Util::XML-Helper;

    # Select the derivation element we'll use based on language
    my $derivation-xml = (
        # The stupid .subst('-','_') is due to CLDR internally preferring Unicode
        # rather than BCP47 language tags.  Only Portuguese has separate rules based
        # for plural counts, but there may be more down the road
        xml.&elem('grammaticalData').&elems('grammaticalDerivations').grep($*lang.subst('-','_') (elem) *.<locales>.words) ||
        xml.&elem('grammaticalData').&elems('grammaticalDerivations').grep('root' (elem) *.<locales>.words)
    ).head;


    for <per times power prefix> -> $type {
        CLDR::Derivation.parse: (base{$type} //= Hash.new), $_
            with $derivation-xml.&elems('deriveComponent').grep(*.<structure> eq $type).Slip,
                 $derivation-xml.&elems('deriveCompound' ).grep(*.<structure> eq $type).Slip;
    }
}
#>>>>> # GENERATOR
