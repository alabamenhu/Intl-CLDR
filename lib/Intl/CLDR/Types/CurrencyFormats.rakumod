unit class CLDR::CurrencyFormats;
    use Intl::CLDR::Core;
    also does CLDR::Item;

use Intl::CLDR::Types::CurrencyFormatSystem;

has CLDR::CurrencyFormatSystem %!systems is built;
has $.spacing-before;
has $.spacing-after;

# The number systems here come from commons/bcp47/number.xml
# You can autogenerate some of this by using the following regex on the file:
#     for ($text ~~ m:g/'name="' (<alnum>+) '" description="' (<-["]>+)/) -> $match {
#         say 'has CLDR-Symbols $.', $match[0].Str, " #= ", $match[1].Str;
#     }
# main/root.xml doesn't actually provide for all of these (e.g. armn), but they are
# definitely included in other places.  Because all except for Arabic fallback to
# Latn, that is maintained in the encoding process.

#| Creates a new CLDR-PercentFormats object
method new(\blob, uint64 $offset is rw --> CLDR::CurrencyFormats) {
    use Intl::CLDR::Util::StrDecode;

    my %systems;
    my $system-count = blob[$offset++];

    %systems{StrDecode::get(blob, $offset)} := CLDR::CurrencyFormatSystem.new(blob, $offset)
        for ^$system-count;

    self.bless: :%systems
}

#| Currency formats for the Adlam numbering system (adlm)
method adlam is aliased-by<adlm>
{ %!systems<adlm> // %!systems<latn> }

#| Currency formats for the Ahom numbering system (ahom)
method ahom
{ %!systems<ahom> // %!systems<latn> }

#| Currency formats for the Arabic-Indic numbering system (arab)
method arabic is aliased-by<arab>
{ %!systems<arab> // %!systems<latn> }

#| Currency formats for the Extended Arabic-Indic numbering system (arabext)
method arabic-extended is aliased-by<arabext>
{ %!systems<arabext> // %!systems<latn> }

#| Currency formats for the Armenian upper case numbering system (armn)
method armenian { %!systems<armn> // %!systems<latn> }

#| Currency formats for the Armenian lower case numbering system (armnlow)
method armenian-lc { %!systems<armnlow> // %!systems<latn> }

#| Currency formats for the Balinese numbering system (bali)
method balinese { %!systems<bali> // %!systems<latn> }

#| Currency formats for the Bengali numbering system (beng)
method bengali { %!systems<beng> // %!systems<latn> }

#| Currency formats for the Bhaiksuki numbering system (bhks)
method bhaiksuki { %!systems<bhks> // %!systems<latn> }

#| Currency formats for the Brahmi numbering system (brah)
method brahmi { %!systems<brah> // %!systems<latn> }

#| Currency formats for the Chakma numbering system (cakm)
method chakma { %!systems<cakm> // %!systems<latn> }

#| Currency formats for the Cham numbering system (cham)
method cham { %!systems<cham> // %!systems<latn> }

#| Currency formats for the Cyrillic numbering system (cyrl)
method cyrillic { %!systems<cyrl> // %!systems<latn> }

#| Currency formats for the Devanagari numbering system (deva)
method devanagari { %!systems<deva> // %!systems<latn> }

#| Currency formats for the Dives Akuru numbering system (diak)
method dives-akuru { %!systems<diak> // %!systems<latn> }

#| Currency formats for the Ethiopic numbering system (ethi)
method ethiopic { %!systems<ethi> // %!systems<latn> }

#| Currency formats for the Financial numbering system (finance)
method financial { %!systems<finance> // %!systems<latn> }

#| Currency formats for the Full width numbering system (fullwide)
method full-width { %!systems<fullwide> // %!systems<latn> }

#| Currency formats for the Georgian numbering system (geor)
method georgian { %!systems<geor> // %!systems<latn> }

#| Currency formats for the Gunjala Gondi numbering system (gong)
method gunjala-gondi { %!systems<gong> // %!systems<latn> }

#| Currency formats for the Masaram Gondi numbering system (gonm)
method masaram-gondi { %!systems<gonm> // %!systems<latn> }

#| Currency formats for the Greek upper case numbering system (grek)
method greek { %!systems<grek> // %!systems<latn> }

#| Currency formats for the Greek lower case numbering system (greklow)
method greek-lc { %!systems<greklow> // %!systems<latn> }

#| Currency formats for the Gujarati numbering system (gujr)
method gujarati { %!systems<gujr> // %!systems<latn> }

#| Currency formats for the Gurmukhi numbering system (guru)
method gurmukhi { %!systems<guru> // %!systems<latn> }

#| Currency formats for the Han-character day-of-month numbering for traditional calendars (hanidays)
method han-days { %!systems<hanidays> // %!systems<latn> }

#| Currency formats for the Positional decimal system using Chinese number ideographs (hanidec))
method han-decimal { %!systems<hanidec> // %!systems<latn> }

#| Currency formats for the Simplified Chinese numbering system (hans)
method han-simplified { %!systems<hans> // %!systems<latn> }

#| Currency formats for the Simplified Chinese financial numbering system (hansfin)
method han-simplified-financial { %!systems<hansfin> // %!systems<latn> }

#| Currency formats for the Traditional Chinese numbering system (hant)
method han-traditional { %!systems<hant> // %!systems<latn> }

#| Currency formats for the Traditional Chinese financial numbering system (hantfin)
method han-traditional-financial { %!systems<hantfin> // %!systems<latn> }

#| Currency formats for the Hebrew numbering system (hebr)
method hebrew { %!systems<hebr> // %!systems<latn> }

#| Currency formats for the Pahawh Hmong numbering system (hmng)
method pahawh-hmong { %!systems<hmng> // %!systems<latn> }

#| Currency formats for the Nyiakeng Puachue Hmong numbering system (hmnp)
method nyiakeng-puachue-hmong { %!systems<hmnp> // %!systems<latn> }

#| Currency formats for the Javanese numbering system (java)
method javanese { %!systems<java> // %!systems<latn> }

#| Currency formats for the Japanese numbering system (jpan)
method japanese { %!systems<jpan> // %!systems<latn> }

#| Currency formats for the Japanese financial numbering system (jpanfin)
method japanese-financial { %!systems<jpanfin> // %!systems<latn> }

#| Currency formats for the Japanese first-year Gannen numbering for Japanese calendar (jpanyear)
method japanese-year { %!systems<jpanyear> // %!systems<latn> }

#| Currency formats for the Kayah Li numbering system (kali)
method kayah-li { %!systems<kali> // %!systems<latn> }

#| Currency formats for the Khmer numbering system (khmr)
method khmer { %!systems<khmr> // %!systems<latn> }

#| Currency formats for the Kannada numbering system (knda)
method kannada { %!systems<knda> // %!systems<latn> }

#| Currency formats for the Tai Tham Hora (secular) numbering system (lana)
method lanna-hora { %!systems<secular> // %!systems<latn> }

#| Currency formats for the Tai Tham Tham (ecclesiastical) numbering system (lanatham)
method lanna-tham { %!systems<ecclesiastical> // %!systems<latn> }

#| Currency formats for the Lao numbering system (laoo)
method lao { %!systems<laoo> // %!systems<latn> }

#| Currency formats for the Latin numbering system (latn)
method latin { %!systems<latn> }

#| Currency formats for the Lepcha numbering system (lepc)
method lepcha { %!systems<lepc> // %!systems<latn> }

#| Currency formats for the Limbu numbering system (limb)
method limbu { %!systems<limb> // %!systems<latn> }

#| Currency formats for the Mathematical bold numbering system (mathbold)
method math-bold { %!systems<mathbold> // %!systems<latn> }

#| Currency formats for the Mathematical double-struck numbering system (mathdbl)
method math-double { %!systems<mathdbl> // %!systems<latn> }

#| Currency formats for the Mathematical monospace numbering system (mathmono)
method math-mono { %!systems<mathmono> // %!systems<latn> }

#| Currency formats for the Mathematical sans-serif bold numbering system (mathsanb)
method math-sans-bold { %!systems<mathsanb> // %!systems<latn> }

#| Currency formats for the Mathematical sans-serif numbering system (mathsans)
method math-sans { %!systems<mathsans> // %!systems<latn> }

#| Currency formats for the Malayalam numbering system (mlym)
method malayalam { %!systems<mlym> // %!systems<latn> }

#| Currency formats for the Modi numbering system (modi)
method modi { %!systems<modi> // %!systems<latn> }

#| Currency formats for the Mongolian numbering system (mong)
method mongolian { %!systems<mong> // %!systems<latn> }

#| Currency formats for the Mro numbering system (mroo)
method mro { %!systems<mroo> // %!systems<latn> }

#| Currency formats for the Meetei Mayek numbering system (mtei)
method meetei-mayek { %!systems<mtei> // %!systems<latn> }

#| Currency formats for the Myanmar numbering system (mymr)
method myanmar { %!systems<mymr> // %!systems<latn> }

#| Currency formats for the Myanmar Shan numbering system (mymrshan)
method myanmar-shan { %!systems<mymrshan> // %!systems<latn> }

#| Currency formats for the Myanmar Tai Laing numbering system (mymrtlng)
method myanmar-tai-laing { %!systems<mymrtlng> // %!systems<latn> }

#| Currency formats for the Native numbering system (native)
method native { %!systems<native> // %!systems<latn> }

#| Currency formats for the Newa numbering system (newa)
method newa { %!systems<newa> // %!systems<latn> }

#| Currency formats for the N'Ko numbering system (nkoo)
method nko { %!systems<nkoo> // %!systems<latn> }

#| Currency formats for the Ol Chiki numbering system (olck)
method ol-chiki { %!systems<olck> // %!systems<latn> }

#| Currency formats for the Oriya numbering system (orya)
method oriya { %!systems<orya> // %!systems<latn> }

#| Currency formats for the Osmanya numbering system (osma)
method osmanya { %!systems<osma> // %!systems<latn> }

#| Currency formats for the Hanifi Rohingya numbering system (rohg)
method hanifi-rohingya { %!systems<rohg> // %!systems<latn> }

#| Currency formats for the Roman upper case numbering system (roman)
method roman { %!systems<roman> // %!systems<latn> }

#| Currency formats for the Roman lowercase numbering system (romanlow)
method roman-lc { %!systems<romanlow> // %!systems<latn> }

#| Currency formats for the Saurashtra numbering system (saur)
method saurashtra { %!systems<saur> // %!systems<latn> }

#| Currency formats for the Legacy computing segmented numbering system (segment)
method segmented { %!systems<segment> // %!systems<latn> }

#| Currency formats for the Sharada numbering system (shrd)
method sharada { %!systems<shrd> // %!systems<latn> }

#| Currency formats for the Khudawadi numbering system (sind)
method khudawadi { %!systems<sind> // %!systems<latn> }

#| Currency formats for the Sinhala Lith numbering system (sinh)
method sinhala { %!systems<sinh> // %!systems<latn> }

#| Currency formats for the Sora_Sompeng numbering system (sora)
method sora-sompeng { %!systems<sora> // %!systems<latn> }

#| Currency formats for the Sundanese numbering system (sund)
method sundanese { %!systems<sund> // %!systems<latn> }

#| Currency formats for the Takri numbering system (takr)
method takri { %!systems<takr> // %!systems<latn> }

#| Currency formats for the New Tai Lue numbering system (talu)
method new-tai-lue { %!systems<talu> // %!systems<latn> }

#| Currency formats for the Tamil numbering system (taml)
method tamil { %!systems<taml> // %!systems<latn> }

#| Currency formats for the Modern Tamil decimal numbering system (tamldec)
method tamil-decimal { %!systems<tamldec> // %!systems<latn> }

#| Currency formats for the Telugu numbering system (telu)
method telugu { %!systems<telu> // %!systems<latn> }

#| Currency formats for the Thai numbering system (thai)
method thai { %!systems<thai> // %!systems<latn> }

#| Currency formats for the Tirhuta numbering system (tirh)
method tirhuta { %!systems<tirh> // %!systems<latn> }

#| Currency formats for the Tibetan numbering system (tibt)
method tibetan { %!systems<tibt> // %!systems<latn> }

#| Currency formats for the Traditional numbering system (traditio)
method traditional { %!systems<traditio> // %!systems<latn> }

#| Currency formats for the Vai numbering system (vaii)
method vai { %!systems<vaii> // %!systems<latn> }

#| Currency formats for the Warang Citi numbering system (wara)
method warang-citi { %!systems<wara> // %!systems<latn> }

#| Currency formats for the Wancho numbering system (wcho)
method wancho { %!systems<wcho> // %!systems<latn> }



constant detour = Map.new: (
adlm =>            'adlam',
arab =>            'arabic',
arabext =>         'arabic-extended',
armn =>            'armenian',
armnlow =>         'armenian-lc',
bali =>            'balinese',
beng =>            'bengali',
bhks =>            'bhaiksuki',
brah =>            'brahmi',
cakm =>            'chakma',
cham =>            'cham',
cyrl =>            'cyrillic',
deva =>            'devanagari',
diak =>            'dives-akuru',
ethi =>            'ethiopic',
finance =>         'financial',
fullwide =>        'full-width',
geor =>            'georgian',
gong =>            'gunjala-gondi',
gonm =>            'masaram-gondi',
grek =>            'greek',
greklow =>         'greek-lc',
gujr =>            'gujarati',
guru =>            'gurmukhi',
hanidays =>        'han-days',
hanidec =>         'han-decimal',
hans =>            'han-simplified',
hansfin =>         'han-simplified-financial',
hant =>            'han-traditional',
hantfin =>         'han-traditional-financial',
hebr =>            'hebrew',
hmng =>            'pahawh-hmong',
hmnp =>            'nyiakeng-puachue-hmong',
java =>            'javanese',
jpan =>            'japanese',
jpanfin =>         'japanese-financial',
jpanyear =>        'japanese-year',
kali =>            'kayah-li',
khmr =>            'khmer',
knda =>            'kannada',
lana =>            'lanna-hora',
lanatham =>        'lanna-tham',
laoo =>            'lao',
latn =>            'latin',
lepc =>            'lepcha',
limb =>            'limbu',
mathbold =>        'math-bold',
mathdbl =>         'math-double',
mathmono =>        'math-mono',
mathsanb =>        'math-sans-bold',
mathsans =>        'math-sans',
mlym =>            'malayalam',
modi =>            'modi',
mong =>            'mongolian',
mroo =>            'mro',
mtei =>            'meetei-mayek',
mymr =>            'myanmar',
mymrshan  => 'myanmar-shan',
mymrtlng  => 'myanmar-tai-laing',
nkoo      => 'nko',
olck      => 'ol-chiki',
orya      => 'oriya',
osma      => 'osmanya',
rohg      => 'hanifi-rohingya',
romanlow  => 'roman-lc',
saur      => 'saurashtra',
segment   => 'segmented',
shrd      => 'sharada',
sind      => 'khudawadi',
sinh      => 'sinhala',
sora      => 'sora-sompeng',
sund      => 'sundanese',
takr      => 'takri',
talu      => 'new-tai-lue',
taml      => 'tamil',
tamldec   => 'tamil-decimal',
telu      => 'telugu',
thai      => 'thai',
tirh      => 'tirhuta',
tibt      => 'tibetan',
traditio  => 'traditional',
vaii      => 'vai',
wara      => 'warang-citi',
wcho      => 'wancho',
);
method DETOUR(-->detour) {;}
sub rsay ($text) { say "\x001b[31m$text\x001b[0m" }
sub rwsay ($texta, $textb) { say "\x001b[31m$texta\x001b[0m  $textb" }

#`<<<<<# GENERATOR: Use toggle-generators.raku to [dis|en]able this code.
method encode(%*formats) {
    use Intl::CLDR::Types::NumberFormat; # for encode only
    use Intl::CLDR::Types::NumberFormatSet; # for encode only
    use Intl::CLDR::Util::StrEncode;
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
            for <full long medium short>
              X <standard accounting>
             -> ($length, $currency) {
                return True if %*formats{$system}{$length}{$currency} && %*formats{$system}{$length}{$currency}{$count};
                return True if %*formats<latn>{$length}{$currency}    && %*formats<latn>{$length}{$currency}{$count};
            }
            return False;
        }

        sub check-currency($currency) {
            for <full long medium short>
            -> $length {
                return True if %*formats{$system}{$length} && %*formats{$system}{$length}{$currency};
                return True if %*formats<latn>{$length}    && %*formats<latn>{$length}{$currency};
            }
            return False;
        }

        my Int @length-existence-table = [
            (%*formats{$system}<short>.keys  > 0 || %*formats<latn><short>.keys  > 0),
            (%*formats{$system}<medium>.keys > 0 || %*formats<latn><medium>.keys > 0),
            (%*formats{$system}<long>.keys   > 0 || %*formats<latn><long>.keys   > 0),
            (%*formats{$system}<full>.keys   > 0 || %*formats<latn><full>.keys   > 0),
        ];
        my Int @currency-existence-table = [
            check-currency('standard'),
            check-currency('accounting')
        ];
        my Int @count-existence-table = [
            check-count('other'), # other goes first, because it's the default (= 0)
            check-count('many' ),
            check-count('few'  ),
            check-count('two'  ),
            check-count('one'  ),
            check-count('zero' ),
        ];

        # This complicated line creates a length fallback where each falls back to its closest neighbor
        # if not found but the count falls back to 0 (or other) if not found
        my @length-transform   = ([\+]   @length-existence-table).map({ $^x - 1 < 0 ?? 0 !! $^x - 1});
        my @currency-transform = ([\+] @currency-existence-table).map({ $^x - 1 < 0 ?? 0 !! $^x - 1});
        my @count-transform    = ([\+]    @count-existence-table).map({ $^x - 1 < 0 ?? 0 !! $^x - 1}) Z* @count-existence-table;

        die "Need to update PercentFormats.pm6 to handle more than just 'standard' and 'account' patterns"
            if %*formats{$system}<standard>.elems > 2;
        my $standard      = %*formats{$system}<standard><other><0> // %*formats<latn><standard><0>;
        my $standard-acct = %*formats{$system}<accounting><other><0> // %*formats{$system}<standard><other><0> // %*formats<latn><accounting><other><0> // %*formats<latn><standard><0>;

        $result ~= StrEncode::get($system);                                            # system as the header
        { my $*pattern-type = 0; $result ~= CLDR::NumberFormat.encode($standard)      } # standard pattern
        { my $*pattern-type = 0; $result ~= CLDR::NumberFormat.encode($standard-acct) } # standard accounting pattern
        $result.append: @length-existence-table.sum;    # lengths in this system
        $result.append: @length-transform>>.Int.Slip;   # length conversion table
        $result.append: @currency-existence-table.sum;  # currencies in this system
        $result.append: @currency-transform>>.Int.Slip; # currency conversion table
        $result.append: @count-existence-table.sum;     # counts in this system
        $result.append: @count-transform>>.Int.Slip;    # count conversion table

        for <standard accounting> Z ^2 -> ($*currency, $currency-cell) {
            next unless @currency-existence-table[$currency-cell];
            for <short medium long full> Z ^4 -> ($*length, $length-cell) {
                next unless @length-existence-table[$length-cell];
                for <other many few two one zero> Z ^6 -> ($*count, $count-cell) {
                    next unless @count-existence-table[$count-cell];
                    $result ~= CLDR::NumberFormatSet.encode: %*formats{$system}{$*length}{$*currency}{$*count} // %*formats<latn>{$*length}{$*currency}{$*count};
                }
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
    for xml.&elems('currencyFormatLength') -> \xml-length {
        my $length = xml-length<type> // 'standard';

        # At this level, there is a single decimalpattern (only currency pattern has two), which has multiple patterns
        # that have various attributes by count and 'type' (a divisor used in formatting).
        for xml-length.&elems('currencyFormat') -> \xml-currency {
            my $currency = xml-currency<type> // 'standard';
            for xml-currency.&elems('pattern').grep(*.defined) -> \xml-pattern {
                die "Add case support to CurrencyFormats.pm6" with xml-pattern<case>;
                die "Add gender support to CurrencyFormats.pm6" with xml-pattern<gender>;

                base{$system}{$length}{$currency}{xml-pattern.<count> // 'other'}{xml-pattern.<type> // '0'} = contents xml-pattern;
            }
        }
    }
    #use Data::Dump::Tree;
    #dump base;
}
>>>>># GENERATOR