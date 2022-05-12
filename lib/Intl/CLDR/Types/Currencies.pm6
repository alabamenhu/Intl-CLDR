unit class CLDR::Currencies;
    use Intl::CLDR::Core;
    also does CLDR::Item;
    also is   CLDR::Unordered;

use Intl::CLDR::Types::Currency;

#############################################
# Attributes are only included in the hash  #
# and not provided method-based access  as  #
# coverage for most languages does not seem #
# to warrant the overhead                   #
#############################################

#| Creates a new CLDR::Currencies object
method new(|c) {
    self.bless!add-keys: |c;
}

submethod !add-keys(\blob, uint64 $offset is rw) {
    ###################################################
    # These key/values effectively are the attributes #
    ###################################################

    use Intl::CLDR::Util::StrDecode;

    my $count = blob[$offset++] * 256 + blob[$offset++];
    self.Hash::BIND-KEY:
        StrDecode::get(   blob,  $offset),            # the currency code
        CLDR-Currency.new(blob, ($offset -= 2), self) # the data, accounting for index str of two bytes
            for ^$count;

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
