#| A class implementing CLDR's <fieldWidth> element
unit class CLDR::FieldWidth;
    use Intl::CLDR::Core;
    also does CLDR::Item;

use Intl::CLDR::Types::RelativeTime;

has Str                $.display-name is aliased-by<displayName>;
has Str                $.less-two     is aliased-by<-2>;
has Str                $.less-one     is aliased-by<-1>;
has Str                $.same         is aliased-by<0>;
has Str                $.plus-two     is aliased-by<+2>;
has Str                $.plus-one     is aliased-by<+1>;
has CLDR::RelativeTime $.future;
has CLDR::RelativeTime $.past;

#| Creates a new CLDR-Dates object
method new(\blob, uint64 $offset is rw --> ::?CLASS) {
    use Intl::CLDR::Util::StrDecode;

    self.bless:
        display-name => StrDecode::get(        blob, $offset),
        less-two     => StrDecode::get(        blob, $offset),
        less-one     => StrDecode::get(        blob, $offset),
        same         => StrDecode::get(        blob, $offset),
        plus-one     => StrDecode::get(        blob, $offset),
        plus-two     => StrDecode::get(        blob, $offset),
        future       => CLDR::RelativeTime.new(blob, $offset),
        past         => CLDR::RelativeTime.new(blob, $offset),
}

#`<<<<<# GENERATOR: Use toggle-generators.raku to [dis|en]able this code.
method encode(%*field-width) {
    my $result = buf8.new;

    use Intl::CLDR::Util::StrEncode;

    sub fallback ($id) {
        do given $*field-width {
            when 'standard' { %*field<standard>{$id} }
            when 'short'    { %*field<short   >{$id} // %*field<standard>{$id} }
            when 'narrow'   { %*field<narrow  >{$id} // %*field<short   >{$id} // %*field<standard>{$id} }
        } || ''
    }

    $result ~= StrEncode::get(fallback 'displayName');
    $result ~= StrEncode::get(fallback '-2'         );
    $result ~= StrEncode::get(fallback '-1'         );
    $result ~= StrEncode::get(fallback  '0'         );
    $result ~= StrEncode::get(fallback  '1'         );
    $result ~= StrEncode::get(fallback  '2'         );

    my $*relative-time-type;

    $*relative-time-type = 'future';
    $result ~= CLDR::RelativeTime.encode( %*field-width<future> // Hash);

    $*relative-time-type = 'past';
    $result ~= CLDR::RelativeTime.encode( %*field-width<past> // Hash);

    $result
}
method parse(\base, \xml) {
    use Intl::CLDR::Util::XML-Helper;
    for xml.&elems('relative') -> \elem {
        base{elem<type>} = elem.&contents;
    }
    with xml.&elem('displayName', :ignore-alt) {
        base<displayName> = contents $_;
    }
    for xml.&elems('relativeTimePattern') -> \elem {
        CLDR::RelativeTime.parse: (base{elem<type>} //= Hash.new), elem
    }
}
>>>>># GENERATOR