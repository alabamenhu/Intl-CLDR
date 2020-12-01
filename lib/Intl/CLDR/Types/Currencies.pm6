use Intl::CLDR::Immutability;

unit class CLDR-Currencies is CLDR-Item;

use Intl::CLDR::Types::Currency;

has $!parent;

######################################################
# Attributes are currently only included in the hash #
######################################################

#| Creates a new CLDR-DayPeriodContext object
method new(|c) {
    self.bless!bind-init: |c;
}

submethod !bind-init(\blob, uint64 $offset is rw, \parent) {
    $!parent := parent;

    ######################################################
    # Attributes are currently only included in the hash #
    ######################################################

    use Intl::CLDR::Util::StrDecode;

    my $count = blob[$offset++] * 256 + blob[$offset++];
    for ^$count {
        self.Hash::BIND-KEY:
            StrDecode::get(blob, $offset),          # the currency code
            CLDR-Currency.new(blob, ($offset -= 2), self); # the data, accounting for index str of two bytes
    }

    self
}


##`<<<<< # GENERATOR: This method should only be uncommented out by the parsing script
method encode(%*currencies) {
    my $result = buf8.new;

    my $count = %*currencies.keys.elems;
    $result.append: $count div 256;
    $result.append: $count mod 256;

    use Intl::CLDR::Util::StrEncode;
    for %*currencies.kv -> $*currency-code, %*currency-data {
        $result ~= CLDR-Currency.encode( %*currency-data // Hash.new )
    }

    $result
}
method parse(\base, \xml) {
    use Intl::CLDR::Util::XML-Helper;
    CLDR-Currency.parse: (base{.<type>} //= Hash.new), $_ for xml.&elems('currency');
}
#>>>>> # GENERATOR
