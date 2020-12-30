use Intl::CLDR::Immutability;

unit class CLDR-Characters is CLDR-ItemNew;

use Intl::CLDR::Types::ExemplarCharacters;
use Intl::CLDR::Types::Ellipses;

has CLDR-ExemplarCharacters $.exemplar;
#has CLDR-LenientParse          $.lenient-parse;
has CLDR-Ellipses $.ellipses;
has Str           $.more-info;

#| Creates a new CLDR-DayPeriodContext object
method new(|c) {
    self.bless!bind-init: |c;
}

submethod !bind-init(\blob, uint64 $offset is rw) {
    use Intl::CLDR::Util::StrDecode;
    $!exemplar      = CLDR-ExemplarCharacters.new: blob, $offset;
    #$!lenient-parse = CLDR-LenientParse.new:      blob, $offset;
    $!ellipses      = CLDR-Ellipses.new:           blob, $offset;
    $!more-info     = StrDecode::get(              blob, $offset);
    self
}

##`<<<<< # GENERATOR: This method should only be uncommented out by the parsing script
method encode(%*characters --> blob8) {
    use Intl::CLDR::Util::StrEncode;
    my $result = buf8.new;

    $result ~= CLDR-ExemplarCharacters.encode: %*characters<exemplar> // Hash;
    $result ~= CLDR-Ellipses.encode:           %*characters<ellipses> // Hash;
    $result ~= StrEncode::get(%*characters<moreInformation> // '');

    $result;
}
method parse(\base, \xml) {
    use Intl::CLDR::Util::XML-Helper;
    #CLDR-LenientParse.parse:          (base<lenient>  //= Hash.new), $_ with xml;
    CLDR-ExemplarCharacters.parse: (base<exemplar>{.<type> // 'standard'} //= Array.new), $_ for xml.&elems('exemplarCharacters');
    CLDR-Ellipses.parse:           (base<ellipses>{.<type>} //=        ''), $_ for xml.&elems('ellipsis');
    base<moreInformation> = contents $_ with xml.&elem('moreInformation');
}
#>>>>> # GENERATOR
