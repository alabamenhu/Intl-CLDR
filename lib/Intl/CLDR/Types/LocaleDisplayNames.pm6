use Intl::CLDR::Immutability;

unit class CLDR-LocaleDisplayNames is CLDR-ItemNew;

use Intl::CLDR::Types::LocaleDisplayPatterns;
use Intl::CLDR::Types::LanguageNames;
use Intl::CLDR::Types::ScriptNames;
use Intl::CLDR::Types::TerritoryNames;
use Intl::CLDR::Types::VariantNames;
use Intl::CLDR::Types::ExtensionNames;
use Intl::CLDR::Types::MeasurementSystemNames;


has $!parent;

has CLDR-LocaleDisplayPatterns  $.display-patterns;
has CLDR-LanguageNames          $.languages;
has CLDR-ScriptNames            $.scripts;
has CLDR-TerritoryNames         $.territories;
has CLDR-VariantNames           $.variants;
has CLDR-MeasurementSystemNames $.measurement-systems;
has CLDR-ExtensionNames         $.extensions;


#| Creates a new CLDR-DayPeriodContext object
method new(|c) {
    self.bless!bind-init: |c;
}

submethod !bind-init(\blob, uint64 $offset is rw, \parent) {
    $!parent := parent;

    $!display-patterns       = CLDR-LocaleDisplayPatterns.new:   blob, $offset, self;
    $!languages              = CLDR-LanguageNames.new:           blob, $offset, self;
    $!scripts                = CLDR-ScriptNames.new:             blob, $offset, self;
    $!territories            = CLDR-TerritoryNames.new:          blob, $offset, self;
    $!variants               = CLDR-VariantNames.new:            blob, $offset, self;
    $!measurement-systems    = CLDR-MeasurementSystemNames.new:  blob, $offset, self;
    $!extensions             = CLDR-ExtensionNames.new:          blob, $offset, self;

    self
}
constant detour = Map.new: (
    localeDisplayPattern   => 'display-pattern',
    displayPattern         => 'display-pattern',
    locale-display-pattern => 'display-pattern',
    measurementSystems     => 'measurementSystems'
);


##`<<<<< # GENERATOR: This method should only be uncommented out by the parsing script
method encode(%*names) {
    my $result = buf8.new;

    $result ~= CLDR-LocaleDisplayPatterns.encode( %*names<localeDisplayPattern> // Hash.new);
    $result ~= CLDR-LanguageNames.encode(         %*names<languages>            // Hash.new);
    $result ~= CLDR-ScriptNames.encode(           %*names<scripts>              // Hash.new);
    $result ~= CLDR-TerritoryNames.encode(        %*names<territories>          // Hash.new);
    $result ~= CLDR-VariantNames.encode(          %*names<variants>             // Hash.new);
    $result ~= CLDR-MeasurementSystemNames.encode(%*names<measurementSystems>   // Hash.new);
    $result ~= CLDR-ExtensionNames.encode(        %*names<extensions>           // Hash.new);

    $result
}
method parse(\base, \xml) {
   use Intl::CLDR::Util::XML-Helper;
   CLDR-LanguageNames.parse:          (base<languages>              //= Hash.new), $_ with xml.&elem('languages');
   CLDR-ScriptNames.parse:            (base<scripts>                //= Hash.new), $_ with xml.&elem('scripts');
   CLDR-TerritoryNames.parse:         (base<territories>            //= Hash.new), $_ with xml.&elem('territories');
   CLDR-VariantNames.parse:           (base<variants>               //= Hash.new), $_ with xml.&elem('variants');
   CLDR-MeasurementSystemNames.parse: (base<measurementSystemNames> //= Hash.new), $_ with xml.&elem('measurementSystemNames');
   CLDR-ExtensionNames.parse:         (base<extensions>             //= Hash.new), xml; # pass through to access two separate elements
   CLDR-LocaleDisplayPatterns.parse:  (base<localeDisplayPattern>   //= Hash.new), xml; # pass through to access two separate elements
}
#>>>>> # GENERATOR
