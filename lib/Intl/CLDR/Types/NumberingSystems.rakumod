use Intl::CLDR::Immutability;

unit class CLDR-NumberingSystems is CLDR-ItemNew;

has Str $.default;
has Str $.native;
has Str $.traditional;
has Str $.financial;


#| Creates a new CLDR-DayPeriodContext object
method new(|c) {
    self.bless!bind-init: |c;
}

submethod !bind-init(\blob, uint64 $offset is rw) {
    use Intl::CLDR::Util::StrDecode;

    $!default     = StrDecode::get(blob, $offset);
    $!native      = StrDecode::get(blob, $offset);
    $!traditional = StrDecode::get(blob, $offset);
    $!financial   = StrDecode::get(blob, $offset);

    self
}


##`<<<<< # GENERATOR: This method should only be uncommented out by the parsing script
method encode(%*numbering-systems) {
    my $result = buf8.new;

    use Intl::CLDR::Util::StrEncode;

    $result ~= StrEncode::get(                                    %*numbering-systems<default> // 'latn');
    $result ~= StrEncode::get(%*numbering-systems<native>      // %*numbering-systems<default> // 'latn');
    $result ~= StrEncode::get(%*numbering-systems<traditional> // %*numbering-systems<default> // 'latn');
    $result ~= StrEncode::get(%*numbering-systems<financial>   // %*numbering-systems<default> // 'latn');

    $result
}
method parse(\base, \xml-default, \xml-others) {
    # the xml passed here is just the <numbers> main element, since we combine two subelements
    use Intl::CLDR::Util::XML-Helper;
    base<default>     = contents $_ with xml-default; # I suppose this might not be defined for some reason
    base<native>      = contents $_ with xml-others.&elem('native');
    base<traditional> = contents $_ with xml-others.&elem('traditional');
    base<financial>   = contents $_ with xml-others.&elem('financial');
}
#>>>>> # GENERATOR
