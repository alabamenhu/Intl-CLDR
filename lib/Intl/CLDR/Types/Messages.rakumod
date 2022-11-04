unit class CLDR::Messages;
    use Intl::CLDR::Core;
    also does CLDR::Item;

has Str $.yesstr;
has Str $.nostr;

#| Creates a new CLDR-DayPeriodContext object
method new(\blob, uint64 $offset is rw --> ::?CLASS) {
    use Intl::CLDR::Util::StrDecode;
    self.bless:
        yesstr => StrDecode::get(blob, $offset),
        nostr  => StrDecode::get(blob, $offset);
}

#`<<<<<# GENERATOR: Use toggle-generators.raku to [dis|en]able this code.
method encode(%*messages) {
    use Intl::CLDR::Util::StrEncode;
    my
    $result  = buf8.new;
    $result ~= StrEncode::get(%*messages<yesstr> // '');
    $result ~= StrEncode::get(%*messages<nostr>  // '');
    $result
}

method parse(\base, \xml) {
    use Intl::CLDR::Util::XML-Helper;
    base<yesstr> = contents $_ with xml.&elem('yesstr');
    base<nostr>  = contents $_ with xml.&elem('nostr');
}
>>>>># GENERATOR