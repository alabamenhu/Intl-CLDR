use Intl::CLDR::Immutability;

unit class CLDR-Numbers is CLDR-ItemNew;

use Intl::CLDR::Types::Symbols;
use Intl::CLDR::Types::NumberingSystems;
use Intl::CLDR::Types::Currencies;
use Intl::CLDR::Types::DecimalFormats;
use Intl::CLDR::Types::PercentFormats;
use Intl::CLDR::Types::ScientificFormats;
use Intl::CLDR::Types::CurrencyFormats;
use Intl::CLDR::Types::MiscellaneousPatterns;
use Intl::CLDR::Types::MinimalPairs;

has $!parent;

has CLDR-Symbols               $.symbols;
has CLDR-NumberingSystems      $.numbering-systems;
has Int                        $.min-grouping-digits;
has CLDR-DecimalFormats        $.decimal-formats;
has CLDR-ScientificFormats     $.scientific-formats;
has CLDR-PercentFormats        $.percent-formats;
has CLDR-CurrencyFormats       $.currency-formats;
has CLDR-Currencies            $.currencies;
has CLDR-MiscellaneousPatterns $.misc-patterns;
has CLDR-MinimalPairs          $.minimal-pairs;


#| Creates a new CLDR-DayPeriodContext object
method new(|c) {
    self.bless!bind-init: |c;
}

submethod !bind-init(\blob, uint64 $offset is rw) {
    $!symbols              = CLDR-Symbols.new:               blob, $offset;
    $!numbering-systems    = CLDR-NumberingSystems.new:      blob, $offset;
    $!decimal-formats      = CLDR-DecimalFormats.new:        blob, $offset;
    $!scientific-formats   = CLDR-ScientificFormats.new:     blob, $offset;
    $!percent-formats      = CLDR-PercentFormats.new:        blob, $offset;
    $!currency-formats     = CLDR-CurrencyFormats.new:       blob, $offset;
    $!currencies           = CLDR-Currencies.new:            blob, $offset;
    $!misc-patterns        = CLDR-MiscellaneousPatterns.new: blob, $offset;
    $!minimal-pairs        = CLDR-MinimalPairs.new:          blob, $offset;
    $!min-grouping-digits  = blob[$offset++]; # it's an int, so...

    self
}

constant detour = Map.new: (
    numberingSystems      => 'numbering-systems',
    decimalFormats        => 'decimal-formats',
    scientificFormats     => 'scientific-formats',
    percentFormats        => 'percent-formats',
    currencyFormats       => 'currency-formats',
    miscPatterns          => 'misc-patterns',
    minimalPairs          => 'minimal-pairs',
    minimumGroupingDigits => 'min-grouping-digits',
);
method DETOUR(-->detour) {;}

##`<<<<< # GENERATOR: This method should only be uncommented out by the parsing script
method encode(%*numbers) {
    my $result = buf8.new;

    $result ~= CLDR-Symbols.encode(               %*numbers<symbols>               // Hash.new);
    $result ~= CLDR-NumberingSystems.encode(      %*numbers<numberingSystems>      // Hash.new);
    $result ~= CLDR-DecimalFormats.encode(        %*numbers<decimalFormats>        // Hash.new);
    $result ~= CLDR-ScientificFormats.encode(     %*numbers<scientificFormats>     // Hash.new);
    $result ~= CLDR-PercentFormats.encode(        %*numbers<percentFormats>        // Hash.new);
    $result ~= CLDR-CurrencyFormats.encode(       %*numbers<currencyFormats>       // Hash.new);
    $result ~= CLDR-Currencies.encode(            %*numbers<currencies>            // Hash.new);
    $result ~= CLDR-MiscellaneousPatterns.encode( %*numbers<miscPatterns>          // Hash.new);
    $result ~= CLDR-MinimalPairs.encode(          %*numbers<minimalPairs>          // Hash.new);
    $result ~= buf8.new:                        +(%*numbers<minimumGroupingDigits> //        1);

    $result
}
method parse(\base, \xml) {
    use Intl::CLDR::Util::XML-Helper;
    CLDR-Symbols.parse:               (base<symbols>           //= Hash.new), $_ for xml.&elems('symbols');
    CLDR-NumberingSystems.parse:      (base<numberingSystems>  //= Hash.new),
                                       xml.&elems('defaultNumberingSystem').grep(not *.<alt>).head, # this ugliness is for languages like arabic
                                       xml.&elem('otherNumberingSystems');
    CLDR-DecimalFormats.parse:        (base<decimalFormats>    //= Hash.new), $_ for  xml.&elems('decimalFormats');
    CLDR-ScientificFormats.parse:     (base<scientificFormats> //= Hash.new), $_ for  xml.&elems('scientificFormats');
    CLDR-PercentFormats.parse:        (base<percentFormats>    //= Hash.new), $_ for  xml.&elems('percentFormats');
    CLDR-CurrencyFormats.parse:       (base<currencyFormats>   //= Hash.new), $_ for  xml.&elems('currencyFormats');
    CLDR-Currencies.parse:            (base<currencies>        //= Hash.new), $_ with xml.&elem('currencies');
    CLDR-MiscellaneousPatterns.parse: (base<miscPatterns>      //= Hash.new), $_ for  xml.&elems('miscPatterns');
    CLDR-MinimalPairs.parse:          (base<minimalPairs>      //= Hash.new), $_ with xml.&elem('minimalPairs');
    base<minimumGroupingDigits> = contents $_ with xml.&elem('minimumGroupingDigits');
}
#>>>>> # GENERATOR
