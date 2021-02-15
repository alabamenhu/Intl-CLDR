use Intl::CLDR::Immutability;

use Intl::CLDR::Types::Plurals;
#use Intl::CLDR::Types::Features;
#use Intl::CLDR::Types::Derivations;

#| A class implementing CLDR's <dates> element, containing information about formatting dates.
unit class CLDR-Grammar is CLDR-ItemNew;

has CLDR-Plurals      $.plurals;
#has CLDR-Features     $.features;
#has CLDR-Derivations  $.derivations;

#| Creates a new CLDR-Dates object
method new(|c) {
    self.bless!bind-init: |c;
}

submethod !bind-init(\blob, uint64 $offset is rw) {

    use Intl::CLDR::Util::StrDecode;

    $!plurals     = CLDR-Plurals.new: blob, $offset;
    #$!features    = CLDR-Features.new: blob, $offset;
    #$!derivations = CLDR-Derivations.new: blob, $offset;

    self
}

##`<<<<< # GENERATOR: This method should only be uncommented out by the parsing script
method encode(%*grammar) {
    my $result = buf8.new;

    $result ~= CLDR-Plurals.encode(    %*grammar<plurals>);
    #$result ~= CLDR-Features.encode(   %*grammar<features>);
    #$result ~= CLDR-Derivations.encode(%*grammar<derivations>);

    $result
}
method parse(\base, \xml) {
    use Intl::CLDR::Util::XML-Helper;
    CLDR-Plurals.parse: (base<plurals> //= Hash.new), $;

}
#>>>>> # GENERATOR
