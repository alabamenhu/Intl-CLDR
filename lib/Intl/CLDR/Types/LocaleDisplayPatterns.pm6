use Intl::CLDR::Immutability;

unit class CLDR-LocaleDisplayPatterns is CLDR-Item;

has     $!parent;
has Str $.main;      #= The pattern to distinguish the language from its specifying elements
has Str $.separator; #= To separate additional identifying elements (including key-type extensions)
has Str $.key-type;  #= For use with extensions that lack custom names

#| Creates a new CLDR-MonthContext object
method new(|c) {
    self.bless!bind-init: |c;
}

submethod !bind-init(\blob, uint64 $offset is rw, \parent) {
    $!parent := parent;

    self.Hash::BIND-KEY: 'main',        $!main;
    self.Hash::BIND-KEY: 'separator',   $!separator;
    self.Hash::BIND-KEY: 'key-type',    $!key-type;
    self.Hash::BIND-KEY: 'keyType',     $!key-type;

    use Intl::CLDR::Classes::StrDecode;

    $!main      = StrDecode::get(blob, $offset);
    $!separator = StrDecode::get(blob, $offset);
    $!key-type  = StrDecode::get(blob, $offset);

    self
}

##`<<<<<#GENERATOR: This method should only be uncommented out by the parsing script
method encode(\hash) {

    my $result = buf8.new;

    use Intl::CLDR::Classes::StrEncode;
    $result ~= StrEncode::get(hash<localePattern>        // '');
    $result ~= StrEncode::get(hash<localeSeparator>      // '');
    $result ~= StrEncode::get(hash<localeKeyTypePattern> // '');
}
method parse(\base, \xml) {
    use Intl::CLDR::Util::XML-Helper;
    base<localePattern>        = contents $_ with xml.&elem('localePattern');
    base<localeSeparator>      = contents $_ with xml.&elem('localeSeparator');
    base<localeKeyTypePattern> = contents $_ with xml.&elem('localeKeyTypePattern');

}
#>>>>>#GENERATOR
