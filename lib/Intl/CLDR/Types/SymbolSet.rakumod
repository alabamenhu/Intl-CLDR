unit class CLDR::SymbolSet;
    use Intl::CLDR::Core;
    also does CLDR::Item;

has Str $.decimal;                                           #= The symbol between integral and fractional units
has Str $.group;                                             #= The symbol between groups of digits
has Str $.list;                                              #= The symbol for lists in mathematical contexts
has Str $.percent          is aliased-by<percentSign>;       #= The percent (1/100) sign
has Str $.minus            is aliased-by<minusSign>;         #= The symbol to represent negative numbers
has Str $.plus             is aliased-by<plusSign>;          #= The symbol to represent positive numbers
has Str $.exponential;                                       #= The symbol to use for scientific exponents
has Str $.superscripting-exponent
                           is aliased-by<superscriptingExponent>; #= The symbol to indicate non-scientific (e.g. superscript) exponents
has Str $.permille         is aliased-by<perMille>;          #= The permille (1/1000) sign
has Str $.infinity;                                          #= The symbol for infinity
has Str $.nan;                                               #= The symbol to represent the 'not a number' state
has Str $.time-separator   is aliased-by<timeSeparator>;     #= The symbol between units in a time display
has Str $.approximately    is aliased-by<approximatelySign>; #= The symbol to represent approximate equaly
has Str $.currency-decimal is aliased-by<currencyDecimal>;   #= The symbol between integral and fractional units with currency
has Str $.currency-group   is aliased-by<currencyGroup>;     #= The symbol between groups of digits with currency


#| Creates a new CLDR-DayPeriodContext object
method new(\blob, uint64 $offset is rw --> ::?CLASS) {
    use Intl::CLDR::Util::StrDecode;
    self.bless:
        decimal                 => StrDecode::get(blob, $offset),
        group                   => StrDecode::get(blob, $offset),
        list                    => StrDecode::get(blob, $offset),
        percent                 => StrDecode::get(blob, $offset),
        minus                   => StrDecode::get(blob, $offset),
        plus                    => StrDecode::get(blob, $offset),
        exponential             => StrDecode::get(blob, $offset),
        superscripting-exponent => StrDecode::get(blob, $offset),
        permille                => StrDecode::get(blob, $offset),
        infinity                => StrDecode::get(blob, $offset),
        nan                     => StrDecode::get(blob, $offset),
        time-separator          => StrDecode::get(blob, $offset),
        approximately           => StrDecode::get(blob, $offset), # fairly new, may not be present in all.
        currency-decimal        => StrDecode::get(blob, $offset),
        currency-group          => StrDecode::get(blob, $offset),
}

#`<<<<<# GENERATOR: Use toggle-generators.raku to [dis|en]able this code.
method encode(%*symbols) {
    use Intl::CLDR::Util::StrEncode;

    my $result = buf8.new;

    for <decimal group list percentSign minusSign plusSign exponential
         superscriptingExponent perMille infinity nan timeSeparator
         approximatelySign currencyDecimal currencyGroup>
     -> $type {
         $result ~= StrEncode::get(
            %*symbols{$type} //
            ($type eq 'currencyDecimal' ?? %*symbols<decimal> !! Nil) //
            ($type eq 'currencyGroup'   ?? %*symbols<group>   !! Nil) //
            %*symbol-sets<latn>{$type}  // # ← shouldn't reach this (fallback done in SymbolSets)
            ''                             # ← should NEVER reach this
         );
    }

    $result
}
method parse(\base, \xml) {
    use Intl::CLDR::Util::XML-Helper;
    # The 'xml' here is the actual symbol set, whose type is the number system identifier,
    # so we just pass it along as is
    for <decimal group list percentSign minusSign plusSign exponential
         superscriptingExponent perMille infinity nan timeSeparator
         approximatelySign currencyDecimal currencyGroup>
     -> $type {
         base{$type} = contents $_ with xml.&elem($type, :ignore-alt) # wtf nn, why do you need two time separators?
     }
}
>>>>># GENERATOR