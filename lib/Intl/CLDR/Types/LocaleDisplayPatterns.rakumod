unit class CLDR::LocaleDisplayPatterns;
    use Intl::CLDR::Core;
    also does CLDR::Item;

has Str $.main;      #= The pattern to distinguish the language from its specifying elements
has Str $.separator; #= To separate additional identifying elements (including key-type extensions)
has Str $.language;  #= For use with language codes when no display name is available
has Str $.script;    #= For use with script codes when no display name is available
has Str $.territory; #= For use with territories codes when no display name is available
has Str $.extension; #= For use with extensions when no display name is available

#| Creates a new CLDR-MonthContext object
method new(\blob, uint64 $offset is rw --> ::?CLASS) {
    use Intl::CLDR::Util::StrDecode;
    self.bless:
        main      => StrDecode::get(blob, $offset),
        separator => StrDecode::get(blob, $offset),
        extension => StrDecode::get(blob, $offset),
        language  => StrDecode::get(blob, $offset),
        script    => StrDecode::get(blob, $offset),
        territory => StrDecode::get(blob, $offset),

}

#`<<<<<# GENERATOR: Use toggle-generators.raku to [dis|en]able this code.
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
    with xml.&elem('localeDisplayPattern') -> \xml-dp {

        base<localePattern>        = contents $_ with xml-dp.&elem('localePattern');
        base<localeSeparator>      = contents $_ with xml-dp.&elem('localeSeparator');
        base<localeKeyTypePattern> = contents $_ with xml-dp.&elem('localeKeyTypePattern');
    }
    with xml.&elem('codePatterns') -> \xml-cp {
        base{.<type> ~ 'CodePattern'} = contents $_ for xml-cp.&elems('codePattern');
    }
}
>>>>># GENERATOR