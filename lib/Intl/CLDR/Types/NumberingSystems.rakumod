unit class CLDR::NumberingSystems;
    use Intl::CLDR::Core;
    also does CLDR::Item;

has Str $.default;
has Str $.native;
has Str $.traditional;
has Str $.financial;

#| Creates a new CLDR::NumberingSystems object
method new(\blob, uint64 $offset is rw --> ::?CLASS) {
    use Intl::CLDR::Util::StrDecode;
    self.bless:
        default     => StrDecode::get(blob, $offset),
        native      => StrDecode::get(blob, $offset),
        traditional => StrDecode::get(blob, $offset),
        financial   => StrDecode::get(blob, $offset),
}

#`<<<<<# GENERATOR: Use toggle-generators.raku to [dis|en]able this code.
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
>>>>># GENERATOR