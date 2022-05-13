use Intl::CLDR::Immutability;

use Intl::CLDR::Types::RelativeTime;

#| A class implementing CLDR's <dates> element, containing information about formatting dates.
unit class CLDR-FieldWidth is CLDR-ItemNew;


has                   $!parent;         #= The CLDR-Dates object containing this CLDR-Fields
has Str               $.display-name;
has Str               $.less-two;
has Str               $.less-one;
has Str               $.same;
has Str               $.plus-two;
has Str               $.plus-one;
has CLDR-RelativeTime $.future;
has CLDR-RelativeTime $.past;

#| Creates a new CLDR-Dates object
method new(|c) {
    self.bless!bind-init: |c;
}

submethod !bind-init(\blob, uint64 $offset is rw) {

    use Intl::CLDR::Util::StrDecode;

    $!display-name = StrDecode::get(        blob, $offset);
    $!less-two     = StrDecode::get(        blob, $offset);
    $!less-one     = StrDecode::get(        blob, $offset);
    $!same         = StrDecode::get(        blob, $offset);
    $!plus-one     = StrDecode::get(        blob, $offset);
    $!plus-two     = StrDecode::get(        blob, $offset);
    $!future       = CLDR-RelativeTime.new: blob, $offset;
    $!past         = CLDR-RelativeTime.new: blob, $offset;

    self
}
constant detour = Map.new: (
   displayName => 'display-name',
   '-2'        => 'less-two',
   '-1'        => 'less-one',
   '0'         => 'same',
   '1'         => 'plus-two',
   '2'         => 'plus-one',

);
method DETOUR(-->detour) {;}
##`<<<<< # GENERATOR: This method should only be uncommented out by the parsing script
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
    $result ~= CLDR-RelativeTime.encode( %*field-width<future> // Hash);

    $*relative-time-type = 'past';
    $result ~= CLDR-RelativeTime.encode( %*field-width<past> // Hash);

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
        CLDR-RelativeTime.parse: (base{elem<type>} //= Hash.new), elem
    }
}
#>>>>> # GENERATOR
