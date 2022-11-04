#| A class implementing CLDR's <delimiters> element, containing information about quotation marks.
unit class CLDR::Delimiters;
    use       Intl::CLDR::Core;
    also does CLDR::Item;

# See https://www.unicode.org/reports/tr35/tr35-general.html#Delimiter_Elements for information

has Str $.quote-start     is aliased-by<quotationStart>;          #= The default opening quotation mark
has Str $.quote-end       is aliased-by<quotationEnd>;            #= The default closing quotation mark
has Str $.alt-quote-start is aliased-by<alternateQuotationStart>; #= The inner opening quotation mark
has Str $.alt-quote-end   is aliased-by<alternateQuotationEnd>;   #= The outer opening quotation mark

method new(\blob, uint64 $offset is rw --> ::?CLASS) {
    use Intl::CLDR::Util::StrDecode;

    self.bless:
        quote-start => StrDecode::get(blob, $offset),
        quote-end => StrDecode::get(blob, $offset),
        alt-quote-start => StrDecode::get(blob, $offset),
        alt-quote-end => StrDecode::get(blob, $offset);
}

#`<<<<<# GENERATOR: Use toggle-generators.raku to [dis|en]able this code.
method encode(%delimiters) {
    my $result = buf8.new;

    use Intl::CLDR::Util::StrEncode;

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
>>>>># GENERATOR