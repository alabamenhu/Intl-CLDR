use Intl::CLDR::Immutability;

unit class CLDR-MeasurementSystemNames is CLDR-ItemNew;

has $!parent;

has Str $.metric; #= The metric system
has Str $.uk;     #= The UK imperial system
has Str $.us;     #= The US customary system

method new(|c) {
    self.bless!bind-init: |c
}

submethod !bind-init(\blob, uint64 $offset is rw, \parent) {
    use Intl::CLDR::Util::StrDecode;
    $!parent := parent;

    $!metric := StrDecode::get(blob, $offset);
    $!uk     := StrDecode::get(blob, $offset);
    $!us     := StrDecode::get(blob, $offset);

    self
}
constant detour = Map.new(
    UK => 'uk',
    US => 'us'
);
method DETOUR(-->detour) {;}
##`<<<<< # GENERATOR: This method should only be uncommented out by the parsing script
method encode(%*territories --> buf8) {
    use Intl::CLDR::Util::StrEncode;

    my $result = buf8.new;

    $result ~= StrEncode::get(%*measurement-systems<metric> // '');
    $result ~= StrEncode::get(%*measurement-systems<uk>     // '');
    $result ~= StrEncode::get(%*measurement-systems<us>     // '');

    $result
}
method parse(\base, \xml) {
    use Intl::CLDR::Util::XML-Helper;
    base{.<type>} = contents $_ for xml.&elems('measurementSystemName');
}
#>>>>> # GENERATOR
