use Intl::CLDR::Immutability;

#| A class implementing CLDR's <dates> element, containing information about formatting dates.
unit class CLDR-RelativeTime is CLDR-Item;


has     $!parent; #= The CLDR-FieldWidth object containing this CLDR-RelativeTime
has Str $.zero;
has Str $.one;
has Str $.two;
has Str $.few;
has Str $.many;
has Str $.other;

#| Creates a new CLDR-Dates object
method new(|c) {
    self.bless!bind-init: |c;
}

submethod !bind-init(\blob, uint64 $offset is rw, \parent) {
    $!parent := parent;

    self.Hash::BIND-KEY: 'zero',  $!zero;
    self.Hash::BIND-KEY: 'one',   $!one;
    self.Hash::BIND-KEY: 'two',   $!two;
    self.Hash::BIND-KEY: 'few',   $!few;
    self.Hash::BIND-KEY: 'many',  $!many;
    self.Hash::BIND-KEY: 'other', $!other;

    use Intl::CLDR::Classes::StrDecode;

    $!zero  = StrDecode::get( blob, $offset);
    $!one   = StrDecode::get( blob, $offset);
    $!two   = StrDecode::get( blob, $offset);
    $!few   = StrDecode::get( blob, $offset);
    $!many  = StrDecode::get( blob, $offset);
    $!other = StrDecode::get( blob, $offset);

    self
}

##`<<<<< # GENERATOR: This method should only be uncommented out by the parsing script
method encode(%relative-time) {
    use Intl::CLDR::Classes::StrEncode;

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

#>>>>> # GENERATOR
