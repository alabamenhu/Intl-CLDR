unit class CLDR::LocaleDisplayNames;
    use Intl::CLDR::Core;
    also does CLDR::Item;

use Intl::CLDR::Types::LocaleDisplayPatterns;
use Intl::CLDR::Types::LanguageNames;
use Intl::CLDR::Types::ScriptNames;
use Intl::CLDR::Types::TerritoryNames;
use Intl::CLDR::Types::VariantNames;
use Intl::CLDR::Types::ExtensionNames;
use Intl::CLDR::Types::MeasurementSystemNames;


has CLDR::LanguageNames          $.languages;
has CLDR::ScriptNames            $.scripts;
has CLDR::TerritoryNames         $.territories;
has CLDR::VariantNames           $.variants;
has CLDR::MeasurementSystemNames $.measurement-systems is aliased-by<measurementSystems>;
has CLDR::ExtensionNames         $.extensions;
has CLDR::LocaleDisplayPatterns  $.display-patterns    is aliased-by<displayPatter>
                                                       is aliased-by<locale-display-pattern>
                                                       is aliased-by<localeDisplayPattern>;


#| Creates a new CLDR-DayPeriodContext object
method new(\blob, uint64 $offset is rw --> ::?CLASS) {
    self.bless:
        display-patterns       => CLDR::LocaleDisplayPatterns.new(   blob, $offset),
        languages              => CLDR::LanguageNames.new(           blob, $offset),
        scripts                => CLDR::ScriptNames.new(             blob, $offset),
        territories            => CLDR::TerritoryNames.new(          blob, $offset),
        variants               => CLDR::VariantNames.new(            blob, $offset),
        measurement-systems    => CLDR::MeasurementSystemNames.new(  blob, $offset),
        extensions             => CLDR::ExtensionNames.new(          blob, $offset),
}

#`<<<<<# GENERATOR: Use toggle-generators.raku to [dis|en]able this code.
method encode(%*names) {
    my $result = buf8.new;

    $result ~= CLDR::LocaleDisplayPatterns.encode( %*names<localeDisplayPattern>   // Hash.new);
    $result ~= CLDR::LanguageNames.encode(         %*names<languages>              // Hash.new);
    $result ~= CLDR::ScriptNames.encode(           %*names<scripts>                // Hash.new);
    $result ~= CLDR::TerritoryNames.encode(        %*names<territories>            // Hash.new);
    $result ~= CLDR::VariantNames.encode(          %*names<variants>               // Hash.new);
    $result ~= CLDR::MeasurementSystemNames.encode(%*names<measurementSystemNames> // Hash.new);
    $result ~= CLDR::ExtensionNames.encode(        %*names<extensions>             // Hash.new);

    $result
}
method parse(\base, \xml) {
   use Intl::CLDR::Util::XML-Helper;
   CLDR::LanguageNames.parse:          (base<languages>              //= Hash.new), $_ with xml.&elem('languages');
   CLDR::ScriptNames.parse:            (base<scripts>                //= Hash.new), $_ with xml.&elem('scripts');
   CLDR::TerritoryNames.parse:         (base<territories>            //= Hash.new), $_ with xml.&elem('territories');
   CLDR::VariantNames.parse:           (base<variants>               //= Hash.new), $_ with xml.&elem('variants');
   CLDR::MeasurementSystemNames.parse: (base<measurementSystemNames> //= Hash.new), $_ with xml.&elem('measurementSystemNames');
   CLDR::ExtensionNames.parse:         (base<extensions>             //= Hash.new), xml; # pass through to access two separate elements
   CLDR::LocaleDisplayPatterns.parse:  (base<localeDisplayPattern>   //= Hash.new), xml; # pass through to access two separate elements
}
>>>>># GENERATOR