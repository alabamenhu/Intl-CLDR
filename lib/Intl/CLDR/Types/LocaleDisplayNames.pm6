use Intl::CLDR::Immutability;

unit class CLDR-LocaleDisplayNames is CLDR-Item;

use Intl::CLDR::Types::LocaleDisplayPattern;
use Intl::CLDR::Types::LocaleDisplayNameSet;
use Intl::CLDR::Types::ExtensionNameSet;
use Intl::CLDR::Types::MeasurementSystems;
use Intl::CLDR::Types::CodePatterns;


has $!parent;

has CLDR-LocaleDisplayPattern $.locale-display-pattern;
has CLDR-LocaleDisplayNameSet $.languages;
has CLDR-LocaleDisplayNameSet $.scripts;
has CLDR-LocaleDisplayNameSet $.territories;
has CLDR-LocaleDisplayNameSet $.variants;
has CLDR-MeasurementSystems   $.measurement-systems;
has CLDR-CodePatterns         $.code-patterns;
has CLDR-ExtensionNameSet     $.extensions;


#| Creates a new CLDR-DayPeriodContext object
method new(|c) {
    self.bless!bind-init: |c;
}

submethod !bind-init(\blob, uint64 $offset is rw, \parent) {
    $!parent := parent;

    self.Hash::BIND-KEY: 'locale-display-pattern', $!locale-display-pattern;
    self.Hash::BIND-KEY: 'localeDisplayPattern',   $!locale-display-pattern;
    self.Hash::BIND-KEY: 'languages',              $!languages;
    self.Hash::BIND-KEY: 'scripts',                $!scripts;
    self.Hash::BIND-KEY: 'territories',            $!territories;
    self.Hash::BIND-KEY: 'variants',               $!variants;
    self.Hash::BIND-KEY: 'extensions',             $!extensions;
    self.Hash::BIND-KEY: 'measurement-systems',    $!measurement-systems;
    self.Hash::BIND-KEY: 'measurementSystems',     $!measurement-systems;
    self.Hash::BIND-KEY: 'code-patterns',          $!code-patterns;
    self.Hash::BIND-KEY: 'codePatterns',           $!code-patterns;

    $!locale-display-pattern = CLDR-LocaleDisplayPattern.new: blob, $offset, self;
    $!languages              = CLDR-LocaleDisplayNameSet.new: blob, $offset, self;
    $!scripts                = CLDR-LocaleDisplayNameSet.new: blob, $offset, self;
    $!territories            = CLDR-LocaleDisplayNameSet.new: blob, $offset, self;
    $!variants               = CLDR-LocaleDisplayNameSet.new: blob, $offset, self;
    $!extensions             = CLDR-ExtensionNameSet.new:     blob, $offset, self;
    $!measurement-systems    = CLDR-MeasurementSystems.new:   blob, $offset, self;
    $!code-patterns          = CLDR-CodePatterns.new:         blob, $offset, self;

    self
}


##`<<<<< # GENERATOR: This method should only be uncommented out by the parsing script
method encode(%*names) {
    my $result = buf8.new;

    $result ~= CLDR-LocaleDisplayNames.encode(  %*names<localeDisplayPattern> // Hash.new);
    $result ~= CLDR-LocaleDisplayNameSet.encode(%*names<languages>            // Hash.new);
    $result ~= CLDR-LocaleDisplayNameSet.encode(%*names<scripts>              // Hash.new);
    $result ~= CLDR-LocaleDisplayNameSet.encode(%*names<territories>          // Hash.new);
    $result ~= CLDR-LocaleDisplayNameSet.encode(%*names<variants>             // Hash.new);
    $result ~= CLDR-ExtensionNameSet.encode(    %*names<extensions>           // Hash.new);
    $result ~= CLDR-MeasurementSystems.encode(  %*names<measurementSystems>   // Hash.new);
    $result ~= CLDR-CodePatterns.encode(        %*names<codePatterns>         // Hash.new);

    $result
}
method parse(\base, \xml) {

}
#>>>>> # GENERATOR
