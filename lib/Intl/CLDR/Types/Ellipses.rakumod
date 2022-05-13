unit class CLDR::Ellipses;
    use Intl::CLDR::Core;
    also does CLDR::Item;

has Str $.final;        #= Ellipse pattern when removing the end of a text
has Str $.initial;      #= Ellipse pattern when removing the start of a text
has Str $.medial;       #= Ellipse pattern when removing a middle portion of text
has Str $.word-final;   #= Ellipse pattern when removing the end of a text along word boundaries
has Str $.word-initial; #= Ellipse pattern when removing the start of a text along word boundaries
has Str $.word-medial;  #= Ellipse pattern when removing a middle portion of text along word boundaries

#| Creates a new CLDR-DayPeriodContext object
method new(buf8 \blob, uint64 $offset is rw --> ::?CLASS ) {
    use Intl::CLDR::Util::StrDecode;
    self.bless:
        final        => StrDecode::get(blob, $offset),
        initial      => StrDecode::get(blob, $offset),
        medial       => StrDecode::get(blob, $offset),
        word-final   => StrDecode::get(blob, $offset),
        word-initial => StrDecode::get(blob, $offset),
        word-medial  => StrDecode::get(blob, $offset);
}

##`<<<<< # GENERATOR: This method should only be uncommented out by the parsing script
method encode(%*ellipses --> blob8) {
    use Intl::CLDR::Util::StrEncode;

    my $result = buf8.new;

    $result ~= StrEncode::get(%*ellipses<final>        // '');
    $result ~= StrEncode::get(%*ellipses<initial>      // '');
    $result ~= StrEncode::get(%*ellipses<medial>       // '');
    $result ~= StrEncode::get(%*ellipses<word-final>   // '');
    $result ~= StrEncode::get(%*ellipses<word-initial> // '');
    $result ~= StrEncode::get(%*ellipses<word-medial>  // '');

    $result;
}
method parse(\base, \xml) {
    use Intl::CLDR::Util::XML-Helper;
    base = contents xml;
}
#>>>>> # GENERATOR
