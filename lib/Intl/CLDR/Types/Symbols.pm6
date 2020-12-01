use Intl::CLDR::Immutability;

unit class CLDR-Symbols is CLDR-Item;

has $!parent;

has Str $.decimal;
has Str $.group;
has Str $.list;
has Str $.percent;
has Str $.minus;
has Str $.plus;
has Str $.exponential;
has Str $.superscripting-exponent;
has Str $.permille;
has Str $.infinity;
has Str $.nan;
has Str $.time-separator;


#| Creates a new CLDR-DayPeriodContext object
method new(|c) {
    self.bless!bind-init: |c;
}

submethod !bind-init(\blob, uint64 $offset is rw, \parent) {
    $!parent := parent;

    #self.Hash::BIND-KEY: 'symbols',            $!symbols;

    use Intl::CLDR::Util::StrDecode;

    $!decimal                 = StrDecode::get(blob, $offset);
    $!group                   = StrDecode::get(blob, $offset);
    $!list                    = StrDecode::get(blob, $offset);
    $!percent                 = StrDecode::get(blob, $offset);
    $!minus                   = StrDecode::get(blob, $offset);
    $!plus                    = StrDecode::get(blob, $offset);
    $!exponential             = StrDecode::get(blob, $offset);
    $!superscripting-exponent = StrDecode::get(blob, $offset);
    $!permille                = StrDecode::get(blob, $offset);
    $!infinity                = StrDecode::get(blob, $offset);
    $!nan                     = StrDecode::get(blob, $offset);
    $!time-separator          = StrDecode::get(blob, $offset);

    self
}


##`<<<<< # GENERATOR: This method should only be uncommented out by the parsing script
method encode(%*symbols) {
    my $result = buf8.new;

    use Intl::CLDR::Util::StrEncode;

    for <decimal group list percentSign minusSign plusSign exponential
         superscriptingExponent perMille infinity nan timeSeparator>
     -> $type {

         $result ~= StrEncode::get(
            %*symbols{$type} //
            %*symbol-sets<latn>{$type} // # ← shouldn't reach this (fallback done in SymbolSets)
            ''                            # ← should NEVER reach this
         );
    }

    $result
}
method parse(\base, \xml) {
    use Intl::CLDR::Util::XML-Helper;
    # The 'xml' here is the actual symbol set, whose type is the number system identifier,
    # so we just pass it along as is
    for <decimal group list percentSign minusSign plusSign exponential
         superscriptingExponent perMille infinity nan timeSeparator>
     -> $type {
         base{$type} = contents $_ with xml.&elem($type)
     }
}
#>>>>> # GENERATOR
