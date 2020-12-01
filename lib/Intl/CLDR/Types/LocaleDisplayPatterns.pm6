use Intl::CLDR::Immutability;

unit class CLDR-LocaleDisplayPatterns is CLDR-Item;

has     $!parent;
has Str $.main;      #= The pattern to distinguish the language from its specifying elements
has Str $.separator; #= To separate additional identifying elements (including key-type extensions)
has Str $.language;  #= For use with language codes when no display name is available
has Str $.script;    #= For use with script codes when no display name is available
has Str $.territory; #= For use with territories codes when no display name is available
has Str $.extension; #= For use with extensions when no display name is available

#| Creates a new CLDR-MonthContext object
method new(|c) {
    self.bless!bind-init: |c;
}

submethod !bind-init(\blob, uint64 $offset is rw, \parent) {
    $!parent := parent;

    self.Hash::BIND-KEY: 'main',        $!main;
    self.Hash::BIND-KEY: 'separator',   $!separator;
    self.Hash::BIND-KEY: 'extension',   $!extension;
    self.Hash::BIND-KEY: 'keyType',     $!extension;
    self.Hash::BIND-KEY: 'language',    $!language;
    self.Hash::BIND-KEY: 'script',      $!script;
    self.Hash::BIND-KEY: 'territory',   $!territory;

    use Intl::CLDR::Util::StrDecode;

    $!main      = StrDecode::get(blob, $offset);
    $!separator = StrDecode::get(blob, $offset);
    $!extension = StrDecode::get(blob, $offset);
    $!language  = StrDecode::get(blob, $offset);
    $!script    = StrDecode::get(blob, $offset);
    $!territory = StrDecode::get(blob, $offset);

    self
}

##`<<<<<#GENERATOR: This method should only be uncommented out by the parsing script
method encode(\hash) {

    my $result = buf8.new;

    use Intl::CLDR::Util::StrEncode;
    $result ~= StrEncode::get(hash<localePattern>        // '');
    $result ~= StrEncode::get(hash<localeSeparator>      // '');
    $result ~= StrEncode::get(hash<localeKeyTypePattern> // '');
    $result ~= StrEncode::get(hash<languageCodePattern>  // '');
    $result ~= StrEncode::get(hash<scriptCodePattern>    // '');
    $result ~= StrEncode::get(hash<territoryCodePattern> // '');
}
method parse(\base, \xml) {
    use Intl::CLDR::Util::XML-Helper;
    with xml.&elem('localeDisplayPatterns') -> \xml-dp {
        base<localePattern>        = contents $_ with xml-dp.&elem('localePattern');
        base<localeSeparator>      = contents $_ with xml-dp.&elem('localeSeparator');
        base<localeKeyTypePattern> = contents $_ with xml-dp.&elem('localeKeyTypePattern');
    }
    with xml.&elem('codePatterns') -> \xml-cp {
        base{.<type> ~ 'CodePattern'} = contents $_ for xml-cp.&elems('codePattern');
    }
}
#>>>>>#GENERATOR
