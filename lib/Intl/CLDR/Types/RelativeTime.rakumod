#| A class implementing CLDR's <relativeTime> element, containing information about formatting dates.
unit class CLDR::RelativeTime;
    use Intl::CLDR::Core;
    also does CLDR::Item;

has Str $.zero;
has Str $.one;
has Str $.two;
has Str $.few;
has Str $.many;
has Str $.other;

#| Creates a new CLDR-Dates object
method new(\blob, uint64 $offset is rw --> ::?CLASS) {
    use Intl::CLDR::Util::StrDecode;
    self.bless:
        zero  => StrDecode::get(blob, $offset),
        one   => StrDecode::get(blob, $offset),
        two   => StrDecode::get(blob, $offset),
        few   => StrDecode::get(blob, $offset),
        many  => StrDecode::get(blob, $offset),
        other => StrDecode::get(blob, $offset),
}

#`<<<<<# GENERATOR: Use toggle-generators.raku to [dis|en]able this code.
method encode(%relative-time) {
    use Intl::CLDR::Util::StrEncode;

    my $result = buf8.new;

    sub fallback ($id) {
        do given $*field-width {
            when 'standard' { %*field<standard>{$*relative-time-type}{$id} }
            when 'short'    { %*field<short   >{$*relative-time-type}{$id} // %*field<standard>{$*relative-time-type}{$id} }
            when 'narrow'   { %*field<narrow  >{$*relative-time-type}{$id} // %*field<short   >{$*relative-time-type}{$id} // %*field<standard>{$*relative-time-type}{$id} }
        } || ''
    }


    for <zero one two few many other> -> $id {
        $result ~= StrEncode::get(fallback $id)
    }

    $result
}
method parse(\base, \xml) {
    use Intl::CLDR::Util::XML-Helper;
    for xml.&elems('relativeTimePattern') -> \pattern {
        base{pattern<count>} = pattern.&contents;
    }
}

>>>>># GENERATOR