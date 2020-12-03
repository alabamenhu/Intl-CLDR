use Intl::CLDR::Immutability;

unit class CLDR-DecimalFormatLengths is CLDR-ItemNew;
use Intl::CLDR::Types::DecimalFormat;
has $!parent;

has Str $.standard;             #= The generic number pattern (aka type '0', currently only a Str)
has CLDR-DecimalFormat $.long;  #= A spelled out version (e.g. 25 thousand, 34 million)
has CLDR-DecimalFormat $.short; #= An abbreviated version (e.g. 25 K, 34 M)

method new(|c) {
    self.bless!bind-init: |c
}

submethod !bind-init(\blob, uint64 $offset is rw, \parent) {
    use Intl::CLDR::Util::StrDecode;
    $!parent := parent;

    $!standard = StrDecode::get(blob, $offset);
    $!long     = CLDR-DecimalFormat.new(blob, $offset);
    $!short    = CLDR-DecimalFormat.new(blob, $offset);

    self
}

##`<<<<< # GENERATOR: This method should only be uncommented out by the parsing script
method encode(%*decimal-formats --> buf8) {
    use Intl::CLDR::Util::StrEncode;

    my $result = buf8.new;

    $result ~= StrEncode::get(        %*decimal-formats<standard> // '');
    $result ~= CLDR-DecimalFormat.new(%*decimal-formats<long>     // Hash);
    $result ~= CLDR-DecimalFormat.new(%*decimal-formats<short>    // Hash);

    $result
}
method parse(\base, \xml) { # xml is <decimal formats>
    use Intl::CLDR::Util::XML-Helper;

    base<standard> = xml.&elem
    base{.<type>} = contents $_ for xml.&elems('measurementSystemName');
}
#>>>>> # GENERATOR
