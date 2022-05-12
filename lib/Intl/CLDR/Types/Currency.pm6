unit class CLDR::Currency;
    use Intl::CLDR::Core;
    also does CLDR::Item;

class DisplayNameCounts does CLDR::Item {
    has $.explicit-zero;
    has $.explicit-one;
    has $.zero;
    has $.one;
    has $.two;
    has $.few;
    has $.many;
    has $.other;

    method new(\blob, $offset is raw) {
        use Intl::CLDR::Util::StrDecode;
        self.bless:
        explicit-zero => StrDecode::get(blob, $offset),
        explicit-one  => StrDecode::get(blob, $offset),
        zero          => StrDecode::get(blob, $offset),
        one           => StrDecode::get(blob, $offset),
        two           => StrDecode::get(blob, $offset),
        few           => StrDecode::get(blob, $offset),
        many          => StrDecode::get(blob, $offset),
        other         => StrDecode::get(blob, $offset),
    }
}

has Str               $.code;
has Str               $.display-name;        #= The titular form of the currency's name
has DisplayNameCounts $.display-name-counts; #= Count-based forms of the name for formatted / running text
has Str               $.symbol;              #= An unambiguous form of the currency symbol (e.g. US$)
has Str               $.symbol-narrow;       #= A version of the currency symbol that may be ambiguous (e.g. just $)


#| Creates a new CLDR-DayPeriodContext object
method new(\blob, uint64 $offset is rw) {
    use Intl::CLDR::Util::StrDecode;

    self.bless:
        code                => StrDecode::get(       blob, $offset),
        display-name        => StrDecode::get(       blob, $offset),
        display-name-counts => DisplayNameCounts.new(blob, $offset),
        symbol              => StrDecode::get(       blob, $offset),
        symbol-narrow       => StrDecode::get(       blob, $offset),
}

##`<<<<< # GENERATOR: This method should only be uncommented out by the parsing script
method encode(%*symbols) {
    my $result = buf8.new;
    use Intl::CLDR::Util::StrEncode;

    $result ~= StrEncode::get( $*currency-code.uc); # currency code (index value)
    $result ~= StrEncode::get( %*symbols<displayName> // $*currency-code.uc); # displayName
    for <0 1 zero one two few many other> -> $count { # displayNameCounts
        $result ~= StrEncode::get(
            %*symbols{'displayName-' ~ $count} //
            %*symbols{'displayName-other'} //
            %*symbols{'displayName'} //
            $*currency-code //
            '' # <- should never reach here
        )
    }
    $result ~= StrEncode::get( %*symbols<symbol> // %*symbols<symbolNarrow> // $*currency-code.uc // '' ); # symbol
    $result ~= StrEncode::get( %*symbols<symbolNarrow> // %*symbols<symbol> // $*currency-code.uc // '' ); #symbol-narrow

    $result
}
method parse(\base, \xml) {
    use Intl::CLDR::Util::XML-Helper;
    # The 'xml' here is the actual symbol set, whose type is the number system identifier,
    # so we just pass it along as is
    for xml.&elems('displayName') -> $name {
        if $name<count> {
            base{'displayName-' ~ $name<count>} = contents $name
        } else {
            base<displayName> = contents $name;
        }
    }
    for xml.&elems('symbol') -> $symbol {
        if $symbol<alt> {
            base<symbolNarrow> = contents $symbol
        }else{
            base<symbol> = contents $symbol
        }
    }
}
#>>>>> # GENERATOR
