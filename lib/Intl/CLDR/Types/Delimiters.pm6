use Intl::CLDR::Immutability;

#| A class implementing CLDR's <delimiters> element, containing information about quotation marks.
unit class CLDR-Delimiters is CLDR-Item;

# See https://www.unicode.org/reports/tr35/tr35-general.html#Delimiter_Elements for information

has     $!parent;            #= The CLDR-Base object containing this CLDR-Delimiter
has Str $.quote-start;       #= The default opening quotation mark
has Str $.quote-end;         #= The default closing quotation mark
has Str $.alt-quote-start;   #= The inner opening quotation mark
has Str $.alt-quote-end;     #= The outer opening quotation mark

#| Creates a new CLDR-Dates object
method new(|c) {
    self.bless!bind-init: |c;
}

submethod !bind-init(\blob, uint64 $offset is rw, \parent = "foo") {
    $!parent := parent;

    self.Hash::BIND-KEY: 'quote-start',             $!quote-start;
    self.Hash::BIND-KEY: 'quotationStart',          $!quote-start;
    self.Hash::BIND-KEY: 'quote-end',               $!quote-end;
    self.Hash::BIND-KEY: 'quotationEnd',            $!quote-end;
    self.Hash::BIND-KEY: 'alt-quote-start',         $!alt-quote-start;
    self.Hash::BIND-KEY: 'alternateQuotationStart', $!alt-quote-start;
    self.Hash::BIND-KEY: 'alt-quote-end',           $!alt-quote-end;
    self.Hash::BIND-KEY: 'alternateQuotationEnd',   $!alt-quote-end;

    use Intl::CLDR::Classes::StrDecode;

    $!quote-start     = StrDecode::get(blob, $offset);
    $!quote-end       = StrDecode::get(blob, $offset);
    $!alt-quote-start = StrDecode::get(blob, $offset);
    $!alt-quote-end   = StrDecode::get(blob, $offset);

    self
}

##`<<<<< # GENERATOR: This method should only be uncommented out by the parsing script
method encode(%delimiters) {
    my $result = buf8.new;

    use Intl::CLDR::Classes::StrEncode;

    $result ~= StrEncode::get(%delimiters<quotationStart>          // '');
    $result ~= StrEncode::get(%delimiters<quotationEnd>            // '');
    $result ~= StrEncode::get(%delimiters<alternateQuotationStart> // '');
    $result ~= StrEncode::get(%delimiters<alternateQuotationEnd>   // '');

    $result
}
method parse(\base, \xml) {
    use Intl::CLDR::Util::XML-Helper;
    base<quotationStart>          = contents $_ with xml.&elem('quotationStart');
    base<quotationEnd>            = contents $_ with xml.&elem('quotationEnd');
    base<alternateQuotationStart> = contents $_ with xml.&elem('alternateQuotationStart');
    base<alternateQuotationEnd>   = contents $_ with xml.&elem('alternateQuotationEnd');
}
#>>>>> # GENERATOR
