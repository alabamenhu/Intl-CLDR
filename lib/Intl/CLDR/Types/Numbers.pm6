use Intl::CLDR::Immutability;

unit class CLDR-Numbers is CLDR-Item;

use Intl::CLDR::Types::SymbolSets;
use Intl::CLDR::Types::NumberingSystems;
use Intl::CLDR::Types::Currencies;

has $!parent;

has CLDR-SymbolSets            $.symbols;
has CLDR-NumberingSystems      $.numbering-systems;
has Int                        $.minimum-grouping-digits;
#has CLDR-DecimalFormats        $.decimal-formats;
#has CLDR-ScientificFormats     $.scientific-formats;
#has CLDR-PercentFormats        $.percent-formats;
#has CLDR-CurrencyFormats       $.currency-formats;
has CLDR-Currencies            $.currencies;
#has CLDR-MiscellaneousPatterns $.misc-patterns;
#has CLDR-MinimalPairs          $.minimal-pairs;


#| Creates a new CLDR-DayPeriodContext object
method new(|c) {
    self.bless!bind-init: |c;
}

submethod !bind-init(\blob, uint64 $offset is rw, \parent) {
    $!parent := parent;

    self.Hash::BIND-KEY: 'symbols',            $!symbols;
    self.Hash::BIND-KEY: 'numbering-systems',  $!numbering-systems;
    self.Hash::BIND-KEY: 'minimum-grouping-digits',  $!minimum-grouping-digits;
    #self.Hash::BIND-KEY: 'decimalFormats',     $!decimal-formats;
    #self.Hash::BIND-KEY: 'decimal-formats',    $!decimal-formats;
    #self.Hash::BIND-KEY: 'scientific-formats', $!scientific-formats;
    #self.Hash::BIND-KEY: 'scientificFormats',  $!scientific-formats;
    #self.Hash::BIND-KEY: 'percent-formats',    $!percent-formats;
    #self.Hash::BIND-KEY: 'percentFormats',     $!percent-formats;
    #self.Hash::BIND-KEY: 'currency-formats',   $!currency-formats;
    #self.Hash::BIND-KEY: 'currencyFormats',    $!currency-formats;
    self.Hash::BIND-KEY: 'currencies',         $!currencies;
    #self.Hash::BIND-KEY: 'misc-patterns',      $!misc-patterns;
    #self.Hash::BIND-KEY: 'miscPatterns',       $!misc-patterns;
    #self.Hash::BIND-KEY: 'minimal-pairs',      $!minimal-pairs;
    #self.Hash::BIND-KEY: 'minimalPairs',       $!minimal-pairs;

    $!symbols            = CLDR-SymbolSets.new:               blob, $offset, self;
    $!numbering-systems  = CLDR-NumberingSystems.new:         blob, $offset, self;
    $!minimum-grouping-digits  = blob[$offset++]; # it's an int, so...
    #$!decimal-formats    = CLDR-DecimalFormats.new:        blob, $offset, self;
    #$!scientific-formats = CLDR-ScientificFormats.new:     blob, $offset, self;
    #$!percent-formats    = CLDR-PercentFormats.new:        blob, $offset, self;
    #$!currency-formats   = CLDR-CurrencyFormats.new:       blob, $offset, self;
    $!currencies         = CLDR-Currencies.new:            blob, $offset, self;
    #$!misc-patterns      = CLDR-MiscellaneousPatterns.new: blob, $offset, self;
    #$!minimal-pairs      = CLDR-MinimalPairs.new:          blob, $offset, self;

    self
}


##`<<<<< # GENERATOR: This method should only be uncommented out by the parsing script
method encode(%*numbers) {
    my $result = buf8.new;

    $result ~= CLDR-SymbolSets.encode(               %*numbers<symbols>           // Hash.new);
    $result ~= CLDR-NumberingSystems.encode(         %*numbers<numberingSystems>  // Hash.new);
    $result ~= buf8.new: +(%*numbers<minimumGroupingDigits> // 1);
    #$result ~= CLDR-DecimalFormats.encode(        %*numbers<decimalFormats>    // Hash.new);
    #$result ~= CLDR-ScientificFormats.encode(     %*numbers<scientificFormats> // Hash.new);
    #$result ~= CLDR-PercentFormats.encode(        %*numbers<percentFormats>    // Hash.new);
    #$result ~= CLDR-CurrencyFormats.encode(       %*numbers<currencyFormats>   // Hash.new);
    $result ~= CLDR-Currencies.encode(            %*numbers<currencies>        // Hash.new);
    #$result ~= CLDR-MiscellaneousPatterns.encode( %*numbers<miscPatterns>      // Hash.new);
    #$result ~= CLDR-MinimalPairs.encode(          %*numbers<minimalPairs>      // Hash.new);

    $result
}
method parse(\base, \xml) {
    use Intl::CLDR::Util::XML-Helper;
    CLDR-SymbolSets.parse:               (base<symbols>          //= Hash.new), $_ for  xml.&elems('symbols');
    CLDR-NumberingSystems.parse: (base<numberingSystems> //= Hash.new),
                                  xml.&elem('defaultNumberingSystem'),
                                  xml.&elem('otherNumberingSystems');
    base<minimumGroupingDigits> = contents $_ with xml.&elem('minimumGroupingDigits');
    #CLDR-DecimalFormats.parse:        (base<decimalFormats>    //= Hash.new), $_ for  xml.&elem('decimalFormats');
    #CLDR-ScientificFormats.parse:     (base<scientificFormats> //= Hash.new), $_ for  xml.&elem('scientificFormats');
    #CLDR-PercentFormats.parse:        (base<percentFormats>    //= Hash.new), $_ for  xml.&elem('percentFormats');
    #CLDR-CurrencyFormats.parse:       (base<currencyFormats>   //= Hash.new), $_ for  xml.&elem('currencyFormats');
    CLDR-Currencies.parse:            (base<currencies>        //= Hash.new), $_ with xml.&elem('currencies');
    #CLDR-MiscellaneousPatterns.parse: (base<miscPatterns>      //= Hash.new), $_ with xml.&elem('miscPatterns');
    #CLDR-MinimalPairs.parse:          (base<minimalPairs>      //= Hash.new), $_ with xml.&elem('minimalPairs');
}
#>>>>> # GENERATOR
