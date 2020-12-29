use Intl::CLDR::Immutability;

unit class CLDR-Ellipses is CLDR-ItemNew;

has Str $.final;
has Str $.initial;
has Str $.medial;
has Str $.word-final;
has Str $.word-initial;
has Str $.word-medial;

#| Creates a new CLDR-DayPeriodContext object
method new(|c) {
    self.bless!bind-init: |c;
}

submethod !bind-init(\blob, uint64 $offset is rw) {
    use Intl::CLDR::Util::StrDecode;

    $!final        = StrDecode::get(blob, $offset);
    $!initial      = StrDecode::get(blob, $offset);
    $!medial       = StrDecode::get(blob, $offset);
    $!word-final   = StrDecode::get(blob, $offset);
    $!word-initial = StrDecode::get(blob, $offset);
    $!word-medial  = StrDecode::get(blob, $offset);

    self
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
