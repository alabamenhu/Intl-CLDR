unit class CLDR::ScientificFormats;
    use Intl::CLDR::Core;
    also does CLDR::Item;

use Intl::CLDR::Types::ScientificFormatSystem;

has CLDR::ScientificFormatSystem %!systems is built;

# The number systems here come from commons/bcp47/number.xml
# You can autogenerate some of this by using the following regex on the file:
# for ($text ~~ m:g/'name="' (<alnum>+) '" description="' (<-["]>+)/) -> $match {
#  say 'has CLDR-Symbols $.', $match[0].Str, " #= ", $match[1].Str;
# }
# main/root.xml doesn't actually provide for all of these (e.g. armn), but they are
# definitely included in other places.  Because all except for Arabic fallback to
# Latn, that is maintained in the encoding process.

#| Creates a new CLDR::ScientificFormats object
method new(\blob, uint64 $offset is rw --> ::?CLASS) {
    use Intl::CLDR::Util::StrDecode;

    my $system-count = blob[$offset++];
    my CLDR::ScientificFormatSystem %systems;
    %systems{StrDecode::get(blob, $offset)} := CLDR::ScientificFormatSystem.new(blob, $offset)
        for ^$system-count;

    self.bless:
        :%systems
}

#| Scientific formats for the Adlam numbering system (adlm)
method adlam is aliased-by<adlm> { %!systems<adlm> // %!systems<latn> }

#| Scientific formats for the Ahom numbering system (ahom)
method ahom { %!systems<ahom> // %!systems<latn> }

#| Scientific formats for the Arabic-Indic numbering system (arab)
method arabic is aliased-by<arab> { %!systems<arab> // %!systems<latn> }

#| Scientific formats for the Extended Arabic-Indic numbering system (arabext)
method arabic-extended is aliased-by<arabext> { %!systems<arabext> // %!systems<latn> }

#| Scientific formats for the Armenian upper case numbering system (armn)
method armenian is aliased-by<armn> { %!systems<armn> // %!systems<latn> }

#| Scientific formats for the Armenian lower case numbering system (armnlow)
method armenian-lc is aliased-by<armnlow> { %!systems<armnlow> // %!systems<latn> }

#| Scientific formats for the Balinese numbering system (bali)
method balinese is aliased-by<bali> { %!systems<bali> // %!systems<latn> }

#| Scientific formats for the Bengali numbering system (beng)
method bengali is aliased-by<beng> { %!systems<beng> // %!systems<latn> }

#| Scientific formats for the Bhaiksuki numbering system (bhks)
method bhaiksuki is aliased-by<bhks> { %!systems<bhks> // %!systems<latn> }

#| Scientific formats for the Brahmi numbering system (brah)
method brahmi is aliased-by<brah> { %!systems<brah> // %!systems<latn> }

#| Scientific formats for the Chakma numbering system (cakm)
method chakma is aliased-by<cakm> { %!systems<cakm> // %!systems<latn> }

#| Scientific formats for the Cham numbering system (cham)
method cham { %!systems<cham> // %!systems<latn> }

#| Scientific formats for the Cyrillic numbering system (cyrl)
method cyrillic is aliased-by<cyrl> { %!systems<cyrl> // %!systems<latn> }

#| Scientific formats for the Devanagari numbering system (deva)
method devanagari is aliased-by<deva> { %!systems<deva> // %!systems<latn> }

#| Scientific formats for the Dives Akuru numbering system (diak)
method dives-akuru is aliased-by<diak> { %!systems<diak> // %!systems<latn> }

#| Scientific formats for the Ethiopic numbering system (ethi)
method ethiopic is aliased-by<ethi> { %!systems<ethi> // %!systems<latn> }

#| Scientific formats for the Financial numbering system (finance)
method financial is aliased-by<finance> { %!systems<finance> // %!systems<latn> }

#| Scientific formats for the Full width numbering system (fullwide)
method full-width is aliased-by<fullwide> { %!systems<fullwide> // %!systems<latn> }

#| Scientific formats for the Georgian numbering system (geor)
method georgian is aliased-by<geor> { %!systems<geor> // %!systems<latn> }

#| Scientific formats for the Gunjala Gondi numbering system (gong)
method gunjala-gondi is aliased-by<gong> { %!systems<gong> // %!systems<latn> }

#| Scientific formats for the Masaram Gondi numbering system (gonm)
method masaram-gondi is aliased-by<gonm> { %!systems<gonm> // %!systems<latn> }

#| Scientific formats for the Greek upper case numbering system (grek)
method greek is aliased-by<grek> { %!systems<grek> // %!systems<latn> }

#| Scientific formats for the Greek lower case numbering system (greklow)
method greek-lc is aliased-by<greklow> { %!systems<greklow> // %!systems<latn> }

#| Scientific formats for the Gujarati numbering system (gujr)
method gujarati is aliased-by<gujr> { %!systems<gujr> // %!systems<latn> }

#| Scientific formats for the Gurmukhi numbering system (guru)
method gurmukhi is aliased-by<guru> { %!systems<guru> // %!systems<latn> }

#| Scientific formats for the Han-character day-of-month numbering for traditional calendars (hanidays)
method han-days is aliased-by<hanidays> { %!systems<hanidays> // %!systems<latn> }

#| Scientific formats for the Positional decimal system using Chinese number ideographs (hanidec))
method han-decimal is aliased-by<hanidec> { %!systems<hanidec> // %!systems<latn> }

#| Scientific formats for the Simplified Chinese numbering system (hans)
method han-simplified is aliased-by<hans> { %!systems<hans> // %!systems<latn> }

#| Scientific formats for the Simplified Chinese financial numbering system (hansfin)
method han-simplified-financial is aliased-by<hansfin> { %!systems<hansfin> // %!systems<latn> }

#| Scientific formats for the Traditional Chinese numbering system (hant)
method han-traditional is aliased-by<hant> { %!systems<hant> // %!systems<latn> }

#| Scientific formats for the Traditional Chinese financial numbering system (hantfin)
method han-traditional-financial is aliased-by<hantfin> { %!systems<hantfin> // %!systems<latn> }

#| Scientific formats for the Hebrew numbering system (hebr)
method hebrew is aliased-by<hebr> { %!systems<hebr> // %!systems<latn> }

#| Scientific formats for the Pahawh Hmong numbering system (hmng)
method pahawh-hmong is aliased-by<hmng> { %!systems<hmng> // %!systems<latn> }

#| Scientific formats for the Nyiakeng Puachue Hmong numbering system (hmnp)
method nyiakeng-puachue-hmong is aliased-by<hmnp> { %!systems<hmnp> // %!systems<latn> }

#| Scientific formats for the Javanese numbering system (java)
method javanese is aliased-by<java> { %!systems<java> // %!systems<latn> }

#| Scientific formats for the Japanese numbering system (jpan)
method japanese is aliased-by<jpan> { %!systems<jpan> // %!systems<latn> }

#| Scientific formats for the Japanese financial numbering system (jpanfin)
method japanese-financial is aliased-by<jpanfin> { %!systems<jpanfin> // %!systems<latn> }

#| Scientific formats for the Japanese first-year Gannen numbering for Japanese calendar (jpanyear)
method japanese-year is aliased-by<jpanyear> { %!systems<jpanyear> // %!systems<latn> }

#| Scientific formats for the Kayah Li numbering system (kali)
method kayah-li is aliased-by<kali> { %!systems<kali> // %!systems<latn> }

#| Scientific formats for the Khmer numbering system (khmr)
method khmer is aliased-by<khmr> { %!systems<khmr> // %!systems<latn> }

#| Scientific formats for the Kannada numbering system (knda)
method kannada is aliased-by<knda> { %!systems<knda> // %!systems<latn> }

#| Scientific formats for the Tai Tham Hora (secular) numbering system (lana)
method lanna-hora is aliased-by<lana> { %!systems<lana> // %!systems<latn> }

#| Scientific formats for the Tai Tham Tham (ecclesiastical) numbering system (lanatham)
method lanna-tham is aliased-by<lanatham> { %!systems<lanatham> // %!systems<latn> }

#| Scientific formats for the Lao numbering system (laoo)
method lao is aliased-by<laoo> { %!systems<laoo> // %!systems<latn> }

#| Scientific formats for the Latin numbering system (latn)
method latin is aliased-by<latn> { %!systems<latn> }

#| Scientific formats for the Lepcha numbering system (lepc)
method lepcha is aliased-by<lepc> { %!systems<lepc> // %!systems<latn> }

#| Scientific formats for the Limbu numbering system (limb)
method limbu is aliased-by<limb> { %!systems<limb> // %!systems<latn> }

#| Scientific formats for the Mathematical bold numbering system (mathbold)
method math-bold is aliased-by<mathbold> { %!systems<mathbold> // %!systems<latn> }

#| Scientific formats for the Mathematical double-struck numbering system (mathdbl)
method math-double is aliased-by<mathdbl> { %!systems<mathdbl> // %!systems<latn> }

#| Scientific formats for the Mathematical monospace numbering system (mathmono)
method math-mono is aliased-by<mathmono> { %!systems<mathmono> // %!systems<latn> }

#| Scientific formats for the Mathematical sans-serif bold numbering system (mathsanb)
method math-sans-bold is aliased-by<mathsanb> { %!systems<mathsanb> // %!systems<latn> }

#| Scientific formats for the Mathematical sans-serif numbering system (mathsans)
method math-sans is aliased-by<mathsans> { %!systems<mathsans> // %!systems<latn> }

#| Scientific formats for the Malayalam numbering system (mlym)
method malayalam is aliased-by<mlym> { %!systems<mlym> // %!systems<latn> }

#| Scientific formats for the Modi numbering system (modi)
method modi is aliased-by<modi> { %!systems<modi> // %!systems<latn> }

#| Scientific formats for the Mongolian numbering system (mong)
method mongolian is aliased-by<mong> { %!systems<mong> // %!systems<latn> }

#| Scientific formats for the Mro numbering system (mroo)
method mro is aliased-by<mroo> { %!systems<mroo> // %!systems<latn> }

#| Scientific formats for the Meetei Mayek numbering system (mtei)
method meetei-mayek is aliased-by<mtei> { %!systems<mtei> // %!systems<latn> }

#| Scientific formats for the Myanmar numbering system (mymr)
method myanmar is aliased-by<mymr> { %!systems<mymr> // %!systems<latn> }

#| Scientific formats for the Myanmar Shan numbering system (mymrshan)
method myanmar-shan is aliased-by<mymrshan> { %!systems<mymrshan> // %!systems<latn> }

#| Scientific formats for the Myanmar Tai Laing numbering system (mymrtlng)
method myanmar-tai-laing is aliased-by<mymrtlng> { %!systems<mymrtlng> // %!systems<latn> }

#| Scientific formats for the Native numbering system (native)
method native is aliased-by<native> { %!systems<native> // %!systems<latn> }

#| Scientific formats for the Newa numbering system (newa)
method newa is aliased-by<newa> { %!systems<newa> // %!systems<latn> }

#| Scientific formats for the N'Ko numbering system (nkoo)
method nko is aliased-by<nkoo> { %!systems<nkoo> // %!systems<latn> }

#| Scientific formats for the Ol Chiki numbering system (olck)
method ol-chiki is aliased-by<olck> { %!systems<olck> // %!systems<latn> }

#| Scientific formats for the Oriya numbering system (orya)
method oriya is aliased-by<orya> { %!systems<orya> // %!systems<latn> }

#| Scientific formats for the Osmanya numbering system (osma)
method osmanya is aliased-by<osma> { %!systems<osma> // %!systems<latn> }

#| Scientific formats for the Hanifi Rohingya numbering system (rohg)
method hanifi-rohingya is aliased-by<rohg> { %!systems<rohg> // %!systems<latn> }

#| Scientific formats for the Roman upper case numbering system (roman)
method roman is aliased-by<roman> { %!systems<roman> // %!systems<latn> }

#| Scientific formats for the Roman lowercase numbering system (romanlow)
method roman-lc is aliased-by<romanlow> { %!systems<romanlow> // %!systems<latn> }

#| Scientific formats for the Saurashtra numbering system (saur)
method saurashtra is aliased-by<saur> { %!systems<saur> // %!systems<latn> }

#| Scientific formats for the Legacy computing segmented numbering system (segment)
method segmented is aliased-by<segment> { %!systems<segment> // %!systems<latn> }

#| Scientific formats for the Sharada numbering system (shrd)
method sharada is aliased-by<shrd> { %!systems<shrd> // %!systems<latn> }

#| Scientific formats for the Khudawadi numbering system (sind)
method khudawadi is aliased-by<sind> { %!systems<sind> // %!systems<latn> }

#| Scientific formats for the Sinhala Lith numbering system (sinh)
method sinhala is aliased-by<sinh> { %!systems<sinh> // %!systems<latn> }

#| Scientific formats for the Sora_Sompeng numbering system (sora)
method sora-sompeng is aliased-by<sora> { %!systems<sora> // %!systems<latn> }

#| Scientific formats for the Sundanese numbering system (sund)
method sundanese is aliased-by<sund> { %!systems<sund> // %!systems<latn> }

#| Scientific formats for the Takri numbering system (takr)
method takri is aliased-by<takr> { %!systems<takr> // %!systems<latn> }

#| Scientific formats for the New Tai Lue numbering system (talu)
method new-tai-lue is aliased-by<talu> { %!systems<talu> // %!systems<latn> }

#| Scientific formats for the Tamil numbering system (taml)
method tamil is aliased-by<taml> { %!systems<taml> // %!systems<latn> }

#| Scientific formats for the Modern Tamil decimal numbering system (tamldec)
method tamil-decimal is aliased-by<tamldec> { %!systems<tamldec> // %!systems<latn> }

#| Scientific formats for the Telugu numbering system (telu)
method telugu is aliased-by<telu> { %!systems<telu> // %!systems<latn> }

#| Scientific formats for the Thai numbering system (thai)
method thai is aliased-by<thai> { %!systems<thai> // %!systems<latn> }

#| Scientific formats for the Tirhuta numbering system (tirh)
method tirhuta is aliased-by<tirh> { %!systems<tirh> // %!systems<latn> }

#| Scientific formats for the Tibetan numbering system (tibt)
method tibetan is aliased-by<tibt> { %!systems<tibt> // %!systems<latn> }

#| Scientific formats for the Traditional numbering system (traditio)
method traditional is aliased-by<traditio> { %!systems<traditio> // %!systems<latn> }

#| Scientific formats for the Vai numbering system (vaii)
method vai is aliased-by<vaii> { %!systems<vaii> // %!systems<latn> }

#| Scientific formats for the Warang Citi numbering system (wara)
method warang-citi is aliased-by<wara> { %!systems<wara> // %!systems<latn> }

#| Scientific formats for the Wancho numbering system (wcho)
method wancho is aliased-by<wcho> { %!systems<wcho> // %!systems<latn> }


#`<<<<<# GENERATOR: Use toggle-generators.raku to [dis|en]able this code.
method encode(%*formats) {
    use Intl::CLDR::Util::StrEncode;
    use Intl::CLDR::Types::NumberFormat; # for encode only
    use Intl::CLDR::Types::NumberFormatSet; # for encode only

    my $result = buf8.new: 0; # 0 will be adjusted at end
    my $encoded-systems = 0;
    for <adlm ahom arab arabext armn armnlow bali beng bhks brah cakm cham cyrl
         deva diak ethi finance fullwide geor gong gonm grek greklow gujr guru
         hanidays hanidec hans hansfin hant hantfin hebr hmng hmnp java jpan
         jpanfin jpanyear jali jhmer knda lana lanatham laoo latn lepc limb
         mathbold mathdbl mathmono mathsanb mathsans mlym modi mong mroo mtei
         mymr mymrshan mymrtlng native newa nkoo olck orya osma rohg roman
         romanlow saur segment shrd sind sinh sora sund takr talu taml tamldec
         telu thai tirh tibt traditio vaii wara wcho> -> $system {

        # TODO: special handling for traditional / financial / native (need to look it up from main
        # %*numbers hash:
        #       <defaultNumberingSystem>latn</defaultNumberingSystem>
        #		<otherNumberingSystems>
        #			<native>latn</native>
        #			<traditional>armn</traditional>
        #			<financial>armn</financial>
        #		</otherNumberingSystems>
        next unless %*formats{$system};

        sub check-count($count) {
            for <full long medium short> -> $length {
                return True if %*formats{$system}{$length} && %*formats{$system}{$length}{$count};
                return True if %*formats<latn>{$length}    && %*formats<latn>{$length}{$count};
            }
            return False;
        }

        my Int @length-existence-table = [
            (%*formats{$system}<short>.keys  > 0 || %*formats<latn><short>.keys  > 0),
            (%*formats{$system}<medium>.keys > 0 || %*formats<latn><medium>.keys > 0),
            (%*formats{$system}<long>.keys   > 0 || %*formats<latn><long>.keys   > 0),
            (%*formats{$system}<full>.keys   > 0 || %*formats<latn><full>.keys   > 0),
        ];
        my Int @count-existence-table = [
            check-count('other'), # other goes first, because it's the default (= 0)
            check-count('many'),
            check-count('few'),
            check-count('two'),
            check-count('one'),
            check-count('zero'),
        ];

        # This complicated line creates a length fallback where each falls back to its closest neighbor
        # if not found but the count falls back to 0 (or other) if not found
        my @length-transform = ([\+] @length-existence-table).map({ $^x - 1 < 0 ?? 0 !! $^x - 1});
        my @count-transform  = ([\+] @count-existence-table ).map({ $^x - 1 < 0 ?? 0 !! $^x - 1}) Z* @count-existence-table;

        die "Need to update ScientificFormats.pm6 to handle multiple standard patterns" if %*formats{$system}<standard>.elems > 1;
        my $standard = %*formats{$system}<standard><other><0> // %*formats<latn><standard><0>;

        $result ~= StrEncode::get($system);                                        # system as the header
        { my $*pattern-type = 0; $result ~= CLDR::NumberFormat.encode($standard) } # standard pattern
        $result.append: @length-existence-table.sum;  # lengths in this system
        $result.append: @length-transform>>.Int.Slip; # length conversion table
        $result.append: @count-existence-table.sum;   # counts in this system
        $result.append: @count-transform>>.Int.Slip;  # count conversion table

        for <short medium long full> Z ^4 -> ($*length, $length-cell) {
            next unless @length-existence-table[$length-cell];
            for <other many few two one zero> Z ^6 -> ($*count, $count-cell) {
                next unless @count-existence-table[$count-cell];
                $result ~= CLDR::NumberFormatSet.encode: %*formats{$system}{$*length}{$*count} // %*formats<latn>{$*length}{$*count};
            }
        }
        $encoded-systems++;
    }
    $result[0] = $encoded-systems; # insert final system cmunt
    $result
}
method parse(\base, \xml) {
    use Intl::CLDR::Util::XML-Helper;

    my $system = xml<numberSystem> // 'latn';

    # At this level, there are four lengths (long, medium, short, narrow) of which only two are currently used
    # (long and short), as well as a fifth pseudo length (no type) that is considered to be the defacto standard.
    for xml.&elems('scientificFormatLength') -> \xml-length {
        my $length = xml-length<type> // 'standard';

        # At this level, there is a single decimalpattern (only currency pattern has two), which has multiple patterns
        # that have various attributes by count and 'type' (a divisor used in formatting).
        for xml-length.&elem('scientificFormat').&elems('pattern').grep(*.defined) -> \xml-pattern {
            die "Add case support to ScientificFormats.pm6" with xml-pattern<case>;
            die "Add gender support to ScientificFormats.pm6" with xml-pattern<gender>;

            base{$system}{$length}{xml-pattern.<count> // 'other'}{xml-pattern.<type> // '0'} = contents xml-pattern;
        }
    }
    #use Data::Dump::Tree;
    #dump base;
}
>>>>># GENERATOR