use Intl::CLDR::Immutability;

use Intl::CLDR::Types::RelativeTime;
use Intl::CLDR::Types::RegionFormat;
use Intl::CLDR::Types::Zones;
use Intl::CLDR::Types::Metazones;

#| A class implementing CLDR's <dates> element, containing information about formatting dates.
unit class CLDR-TimezoneNames is CLDR-ItemNew;


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

submethod !bind-init(\blob, uint64 $offset is rw) {
    use Intl::CLDR::Util::StrDecode;

    $!hour-format     = StrDecode::get(        blob, $offset);
    $!gmt-format      = StrDecode::get(        blob, $offset);
    $!gmt-zero-format = StrDecode::get(        blob, $offset);
    $!fallback-format = StrDecode::get(        blob, $offset);
    $!region-format   = CLDR-RegionFormat.new: blob, $offset;
    $!zones           = CLDR-Zones.new:        blob, $offset;
    $!metazones       = CLDR-Metazones.new:    blob, $offset;

    self
}

constant \detour = Map.new(
    hourFormat     => 'hour-format',
    gmtFormat      => 'gmt-format',
    gmtZeroFormat  => 'gmt-zero-format',
    fallbackFormat => 'fallback-format',
    regionFormat   => 'region-format'
);
method DETOUR(--> detour) {;}


##`<<<<< # GENERATOR: This method should only be uncommented out by the parsing script
method encode(%*timezone-names) {
    use Intl::CLDR::Util::StrEncode;

    my $result = buf8.new;

    $result ~= StrEncode::get(%*timezone-names<hourFormat>     // '');
    $result ~= StrEncode::get(%*timezone-names<gmtFormat>      // '');
    $result ~= StrEncode::get(%*timezone-names<gmtZeroFormat>  // '');
    $result ~= StrEncode::get(%*timezone-names<fallbackFormat> // '');
    $result ~= CLDR-RegionFormat.encode(%*timezone-names<regionFormat> // Hash);
    $result ~= CLDR-Zones.encode(       %*timezone-names<zones>        // Hash);
    $result ~= CLDR-Metazones.encode(   %*timezone-names<metazones>    // Hash);

    $result
}
method parse(\base, \xml) {
    use Intl::CLDR::Util::XML-Helper;
    with xml.&elem('hourFormat'    ) { base<hourFormat>    = contents $_ }
    with xml.&elem('gmtFormat'     ) { base<gmtFormat>     = contents $_ }
    with xml.&elem('gmtZeroFormat' ) { base<gmtZeroFormat> = contents $_ }
    with xml.&elem('fallbackFormat') { base<gmtZeroFormat> = contents $_ }

    base<regionFormat>{.<type> || 'generic'} = contents $_ for xml.&elems('regionFormat');

    CLDR-Zones.parse:     (base<zones>     //= Hash), xml, 'zone'; # the zones are at this same level for some weird reason
    CLDR-Metazones.parse: (base<metazones> //= Hash), xml, 'metazone';
}
#>>>>> # GENERATOR
