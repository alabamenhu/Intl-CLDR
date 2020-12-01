use Intl::CLDR::Immutability;

unit class CLDR-Messages is CLDR-Item;

has $!parent;

has Str $.yesstr;
has Str $.nostr;

#| Creates a new CLDR-DayPeriodContext object
method new(|c) {
    self.bless!bind-init: |c;
}

submethod !bind-init(\blob, uint64 $offset is rw, \parent) {
    $!parent := parent;

    self.Hash::BIND-KEY: 'yesstr', $!yesstr;
    self.Hash::BIND-KEY: 'nostr',  $!nostr;

    use Intl::CLDR::Util::StrDecode;
    $!yesstr = StrDecode::get(blob, $offset);
    $!nostr  = StrDecode::get(blob, $offset);

    self
}


##`<<<<< # GENERATOR: This method should only be uncommented out by the parsing script
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
