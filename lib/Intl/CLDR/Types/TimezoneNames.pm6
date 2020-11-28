use Intl::CLDR::Immutability;

use Intl::CLDR::Types::RelativeTime;
use Intl::CLDR::Types::RegionFormat;
use Intl::CLDR::Types::Zones;
use Intl::CLDR::Types::Metazones;

#| A class implementing CLDR's <dates> element, containing information about formatting dates.
unit class CLDR-TimezoneNames is CLDR-Item;


has                   $!parent;         #= The CLDR-Dates object containing this CLDR-Fields
has Str               $.hour-format;
has Str               $.gmt-format;
has Str               $.gmt-zero-format;
has Str               $.fallback-format;
has CLDR-RegionFormat $.region-format;
has CLDR-Zones        $.zones;
has CLDR-Metazones    $.metazones;

#| Creates a new CLDR-TimezoneNames object
method new(|c) {
    self.bless!bind-init: |c;
}

submethod !bind-init(\blob, uint64 $offset is rw, \parent) {
    $!parent := parent;

    self.Hash::BIND-KEY: 'hourFormat',      $!hour-format;
    self.Hash::BIND-KEY: 'hour-format',     $!hour-format;
    self.Hash::BIND-KEY: 'gmtFormat',       $!gmt-format;
    self.Hash::BIND-KEY: 'gmt-format',      $!gmt-format;
    self.Hash::BIND-KEY: 'gmtZeroFormat',   $!gmt-zero-format;
    self.Hash::BIND-KEY: 'gmt-zero-format', $!gmt-zero-format;
    self.Hash::BIND-KEY: 'fallbackFormat',  $!fallback-format;
    self.Hash::BIND-KEY: 'fallback-format', $!fallback-format;
    self.Hash::BIND-KEY: 'regionFormat',    $!region-format;
    self.Hash::BIND-KEY: 'region-format',   $!region-format;
    self.Hash::BIND-KEY: 'zone',            $!zones;
    self.Hash::BIND-KEY: 'metazone',        $!metazones;

    use Intl::CLDR::Classes::StrDecode;


    $!hour-format     = StrDecode::get(        blob, $offset);
    $!gmt-format      = StrDecode::get(        blob, $offset);
    $!gmt-zero-format = StrDecode::get(        blob, $offset);
    $!fallback-format = StrDecode::get(        blob, $offset);
    $!region-format   = CLDR-RegionFormat.new: blob, $offset, self;
    $!zones           = CLDR-Zones.new:        blob, $offset, self;
    $!metazones       = CLDR-Metazones.new:    blob, $offset, self;

    self
}

##`<<<<< # GENERATOR: This method should only be uncommented out by the parsing script
method encode(%*timezone-names) {
    use Intl::CLDR::Classes::StrEncode;

    my $result = buf8.new;

    $result ~= StrEncode::get(%*timezone-names<hourFormat>     // '');
    $result ~= StrEncode::get(%*timezone-names<gmtFormat>      // '');
    $result ~= StrEncode::get(%*timezone-names<gmtZeroFormat>  // '');
    $result ~= StrEncode::get(%*timezone-names<fallbackFormat> // '');
    $result ~= CLDR-RegionFormat.encode(%*timezone-names<regionFormat> // Hash);
    $result ~= CLDR-Zones.encode(%*timezone-names<zones> // Hash);
    $result ~= CLDR-Metazones.encode(%*timezone-names<metazones> // Hash);

    $result.append: 0
}
#>>>>> # GENERATOR
