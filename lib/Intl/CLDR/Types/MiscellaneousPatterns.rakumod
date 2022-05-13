use Intl::CLDR::Immutability;

unit class CLDR-MiscellaneousPatterns is CLDR-ItemNew;

use Intl::CLDR::Types::MiscellaneousPatternSet;

has CLDR-MiscellaneousPatternSet %!systems;

# The number systems here come from commons/bcp47/number.xml
# You can autogenerate some of this by using the following regex on the file:
# for ($text ~~ m:g/'name="' (<alnum>+) '" description="' (<-["]>+)/) -> $match {
#  say 'has CLDR-Symbols $.', $match[0].Str, " #= ", $match[1].Str;
# }
# main/root.xml doesn't actually provide for all of these (e.g. armn), but they are
# definitely included in other places.  Because all except for Arabic fallback to
# Latn, that is maintained in the encoding process.

#| Creates a new CLDR-PercentFormats object
method new(|c --> CLDR-MiscellaneousPatterns) {
    self.bless!bind-init: |c;
}

submethod !bind-init(\blob, uint64 $offset is rw --> CLDR-MiscellaneousPatterns) {
    use Intl::CLDR::Util::StrDecode;

    my $system-count = blob[$offset++];

    %!systems{StrDecode::get(blob, $offset)} := CLDR-MiscellaneousPatternSet.new(blob, $offset)
        for ^$system-count;

    self
}

#| Percent formats for the Adlam numbering system (adlm)
method adlam { %!systems<adlm> // %!systems<latn> }

#| Percent formats for the Ahom numbering system (ahom)
method ahom { %!systems<ahom> // %!systems<latn> }

#| Percent formats for the Arabic-Indic numbering system (arab)
method arabic { %!systems<arab> // %!systems<latn> }

#| Percent formats for the Extended Arabic-Indic numbering system (arabext)
method arabic-extended { %!systems<arabext> // %!systems<latn> }

#| Percent formats for the Armenian upper case numbering system (armn)
method armenian { %!systems<armn> // %!systems<latn> }

#| Percent formats for the Armenian lower case numbering system (armnlow)
method armenian-lc { %!systems<armnlow> // %!systems<latn> }

#| Percent formats for the Balinese numbering system (bali)
method balinese { %!systems<bali> // %!systems<latn> }

#| Percent formats for the Bengali numbering system (beng)
method bengali { %!systems<beng> // %!systems<latn> }

#| Percent formats for the Bhaiksuki numbering system (bhks)
method bhaiksuki { %!systems<bhks> // %!systems<latn> }

#| Percent formats for the Brahmi numbering system (brah)
method brahmi { %!systems<brah> // %!systems<latn> }

#| Percent formats for the Chakma numbering system (cakm)
method chakma { %!systems<cakm> // %!systems<latn> }

#| Percent formats for the Cham numbering system (cham)
method cham { %!systems<cham> // %!systems<latn> }

#| Percent formats for the Cyrillic numbering system (cyrl)
method cyrillic { %!systems<cyrl> // %!systems<latn> }

#| Percent formats for the Devanagari numbering system (deva)
method devanagari { %!systems<deva> // %!systems<latn> }

#| Percent formats for the Dives Akuru numbering system (diak)
method dives-akuru { %!systems<diak> // %!systems<latn> }

#| Percent formats for the Ethiopic numbering system (ethi)
method ethiopic { %!systems<ethi> // %!systems<latn> }

#| Percent formats for the Financial numbering system (finance)
method financial { %!systems<finance> // %!systems<latn> }

#| Percent formats for the Full width numbering system (fullwide)
method full-width { %!systems<fullwide> // %!systems<latn> }

#| Percent formats for the Georgian numbering system (geor)
method georgian { %!systems<geor> // %!systems<latn> }

#| Percent formats for the Gunjala Gondi numbering system (gong)
method gunjala-gondi { %!systems<gong> // %!systems<latn> }

#| Percent formats for the Masaram Gondi numbering system (gonm)
method masaram-gondi { %!systems<gonm> // %!systems<latn> }

#| Percent formats for the Greek upper case numbering system (grek)
method greek { %!systems<grek> // %!systems<latn> }

#| Percent formats for the Greek lower case numbering system (greklow)
method greek-lc { %!systems<greklow> // %!systems<latn> }

#| Percent formats for the Gujarati numbering system (gujr)
method gujarati { %!systems<gujr> // %!systems<latn> }

#| Percent formats for the Gurmukhi numbering system (guru)
method gurmukhi { %!systems<guru> // %!systems<latn> }

#| Percent formats for the Han-character day-of-month numbering for traditional calendars (hanidays)
method han-days { %!systems<hanidays> // %!systems<latn> }

#| Percent formats for the Positional decimal system using Chinese number ideographs (hanidec))
method han-decimal { %!systems<hanidec> // %!systems<latn> }

#| Percent formats for the Simplified Chinese numbering system (hans)
method han-simplified { %!systems<hans> // %!systems<latn> }

#| Percent formats for the Simplified Chinese financial numbering system (hansfin)
method han-simplified-financial { %!systems<hansfin> // %!systems<latn> }

#| Percent formats for the Traditional Chinese numbering system (hant)
method han-traditional { %!systems<hant> // %!systems<latn> }

#| Percent formats for the Traditional Chinese financial numbering system (hantfin)
method han-traditional-financial { %!systems<hantfin> // %!systems<latn> }

#| Percent formats for the Hebrew numbering system (hebr)
method hebrew { %!systems<hebr> // %!systems<latn> }

#| Percent formats for the Pahawh Hmong numbering system (hmng)
method pahawh-hmong { %!systems<hmng> // %!systems<latn> }

#| Percent formats for the Nyiakeng Puachue Hmong numbering system (hmnp)
method nyiakeng-puachue-hmong { %!systems<hmnp> // %!systems<latn> }

#| Percent formats for the Javanese numbering system (java)
method javanese { %!systems<java> // %!systems<latn> }

#| Percent formats for the Japanese numbering system (jpan)
method japanese { %!systems<jpan> // %!systems<latn> }

#| Percent formats for the Japanese financial numbering system (jpanfin)
method japanese-financial { %!systems<jpanfin> // %!systems<latn> }

#| Percent formats for the Japanese first-year Gannen numbering for Japanese calendar (jpanyear)
method japanese-year { %!systems<jpanyear> // %!systems<latn> }

#| Percent formats for the Kayah Li numbering system (kali)
method kayah-li { %!systems<kali> // %!systems<latn> }

#| Percent formats for the Khmer numbering system (khmr)
method khmer { %!systems<khmr> // %!systems<latn> }

#| Percent formats for the Kannada numbering system (knda)
method kannada { %!systems<knda> // %!systems<latn> }

#| Percent formats for the Tai Tham Hora (secular) numbering system (lana)
method lanna-hora { %!systems<secular> // %!systems<latn> }

#| Percent formats for the Tai Tham Tham (ecclesiastical) numbering system (lanatham)
method lanna-tham { %!systems<ecclesiastical> // %!systems<latn> }

#| Percent formats for the Lao numbering system (laoo)
method lao { %!systems<laoo> // %!systems<latn> }

#| Percent formats for the Latin numbering system (latn)
method latin { %!systems<latn> }

#| Percent formats for the Lepcha numbering system (lepc)
method lepcha { %!systems<lepc> // %!systems<latn> }

#| Percent formats for the Limbu numbering system (limb)
method limbu { %!systems<limb> // %!systems<latn> }

#| Percent formats for the Mathematical bold numbering system (mathbold)
method math-bold { %!systems<mathbold> // %!systems<latn> }

#| Percent formats for the Mathematical double-struck numbering system (mathdbl)
method math-double { %!systems<mathdbl> // %!systems<latn> }

#| Percent formats for the Mathematical monospace numbering system (mathmono)
method math-mono { %!systems<mathmono> // %!systems<latn> }

#| Percent formats for the Mathematical sans-serif bold numbering system (mathsanb)
method math-sans-bold { %!systems<mathsanb> // %!systems<latn> }

#| Percent formats for the Mathematical sans-serif numbering system (mathsans)
method math-sans { %!systems<mathsans> // %!systems<latn> }

#| Percent formats for the Malayalam numbering system (mlym)
method malayalam { %!systems<mlym> // %!systems<latn> }

#| Percent formats for the Modi numbering system (modi)
method modi { %!systems<modi> // %!systems<latn> }

#| Percent formats for the Mongolian numbering system (mong)
method mongolian { %!systems<mong> // %!systems<latn> }

#| Percent formats for the Mro numbering system (mroo)
method mro { %!systems<mroo> // %!systems<latn> }

#| Percent formats for the Meetei Mayek numbering system (mtei)
method meetei-mayek { %!systems<mtei> // %!systems<latn> }

#| Percent formats for the Myanmar numbering system (mymr)
method myanmar { %!systems<mymr> // %!systems<latn> }

#| Percent formats for the Myanmar Shan numbering system (mymrshan)
method myanmar-shan { %!systems<mymrshan> // %!systems<latn> }

#| Percent formats for the Myanmar Tai Laing numbering system (mymrtlng)
method myanmar-tai-laing { %!systems<mymrtlng> // %!systems<latn> }

#| Percent formats for the Native numbering system (native)
method native { %!systems<native> // %!systems<latn> }

#| Percent formats for the Newa numbering system (newa)
method newa { %!systems<newa> // %!systems<latn> }

#| Percent formats for the N'Ko numbering system (nkoo)
method nko { %!systems<nkoo> // %!systems<latn> }

#| Percent formats for the Ol Chiki numbering system (olck)
method ol-chiki { %!systems<olck> // %!systems<latn> }

#| Percent formats for the Oriya numbering system (orya)
method oriya { %!systems<orya> // %!systems<latn> }

#| Percent formats for the Osmanya numbering system (osma)
method osmanya { %!systems<osma> // %!systems<latn> }

#| Percent formats for the Hanifi Rohingya numbering system (rohg)
method hanifi-rohingya { %!systems<rohg> // %!systems<latn> }

#| Percent formats for the Roman upper case numbering system (roman)
method roman { %!systems<roman> // %!systems<latn> }

#| Percent formats for the Roman lowercase numbering system (romanlow)
method roman-lc { %!systems<romanlow> // %!systems<latn> }

#| Percent formats for the Saurashtra numbering system (saur)
method saurashtra { %!systems<saur> // %!systems<latn> }

#| Percent formats for the Legacy computing segmented numbering system (segment)
method segmented { %!systems<segment> // %!systems<latn> }

#| Percent formats for the Sharada numbering system (shrd)
method sharada { %!systems<shrd> // %!systems<latn> }

#| Percent formats for the Khudawadi numbering system (sind)
method khudawadi { %!systems<sind> // %!systems<latn> }

#| Percent formats for the Sinhala Lith numbering system (sinh)
method sinhala { %!systems<sinh> // %!systems<latn> }

#| Percent formats for the Sora_Sompeng numbering system (sora)
method sora-sompeng { %!systems<sora> // %!systems<latn> }

#| Percent formats for the Sundanese numbering system (sund)
method sundanese { %!systems<sund> // %!systems<latn> }

#| Percent formats for the Takri numbering system (takr)
method takri { %!systems<takr> // %!systems<latn> }

#| Percent formats for the New Tai Lue numbering system (talu)
method new-tai-lue { %!systems<talu> // %!systems<latn> }

#| Percent formats for the Tamil numbering system (taml)
method tamil { %!systems<taml> // %!systems<latn> }

#| Percent formats for the Modern Tamil decimal numbering system (tamldec)
method tamil-decimal { %!systems<tamldec> // %!systems<latn> }

#| Percent formats for the Telugu numbering system (telu)
method telugu { %!systems<telu> // %!systems<latn> }

#| Percent formats for the Thai numbering system (thai)
method thai { %!systems<thai> // %!systems<latn> }

#| Percent formats for the Tirhuta numbering system (tirh)
method tirhuta { %!systems<tirh> // %!systems<latn> }

#| Percent formats for the Tibetan numbering system (tibt)
method tibetan { %!systems<tibt> // %!systems<latn> }

#| Percent formats for the Traditional numbering system (traditio)
method traditional { %!systems<traditio> // %!systems<latn> }

#| Percent formats for the Vai numbering system (vaii)
method vai { %!systems<vaii> // %!systems<latn> }

#| Percent formats for the Warang Citi numbering system (wara)
method warang-citi { %!systems<wara> // %!systems<latn> }

#| Percent formats for the Wancho numbering system (wcho)
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

##`<<<<< # GENERATOR: This method should only be uncommented out by the parsing script
method encode(%*misc-patterns) {
    use Intl::CLDR::Util::StrEncode;

    my
    $result = buf8.new;
    $result.append: 0;

    my $count = 0;
    for %*misc-patterns.keys -> $type {
        next unless %*misc-patterns{$type}; # all are present, but not all have data post-parsing
        $result ~= StrEncode::get($type);
        $result ~= CLDR-MiscellaneousPatternSet.encode(%*misc-patterns{$type});
        $count++;
    }

    $result[0] = $count;

    # TODO: special handling for traditional / financial / native (need to look it up from main
    # %*numbers hash:
    #       <defaultNumberingSystem>latn</defaultNumberingSystem>
    #		<otherNumberingSystems>
    #			<native>latn</native>
    #			<traditional>armn</traditional>
    #			<financial>armn</financial>
    #		</otherNumberingSystems>

    $result
}
method parse(\base, \xml) {
    use Intl::CLDR::Util::XML-Helper;
    # We are passed the symbol set directly, so the xml is intentionally passed through
    CLDR-MiscellaneousPatternSet.parse: (base{$_} //= Hash.new), xml
        with xml<numberSystem>; # ← one will have no type, that's the fallback, which aliases to latn, so we ignore it︎
}
#>>>>> # GENERATOR
