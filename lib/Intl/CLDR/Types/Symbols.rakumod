# TODO: finish aliasing number sets
unit class CLDR::Symbols;
    use Intl::CLDR::Core;
    also does CLDR::Item;

use Intl::CLDR::Types::SymbolSet;

has CLDR::SymbolSet %!systems is built;
# The number systems here come from commons/bcp47/number.xml
# You can autogenerate some of this by using the following regex on the file:
# for ($text ~~ m:g/'name="' (<alnum>+) '" description="' (<-["]>+)/) -> $match {
#  say 'has CLDR-Symbols $.', $match[0].Str, " #= ", $match[1].Str;
# }
# main/root.xml doesn't actually provide for all of these (e.g. armn), but they are
# definitely included in other places.  Because all except for Arabic fallback to
# Latn, that is maintained in the encoding process.

#| Creates a new CLDR-SymbolSetsAAAA object
method new(\blob, uint64 $offset is rw --> ::?CLASS) {
    use Intl::CLDR::Util::StrDecode;

    my $count = blob[$offset++];
    my CLDR::SymbolSet %systems;
    %systems{StrDecode::get(blob, $offset)} = CLDR::SymbolSet.new: blob, $offset
        for ^$count;

    self.bless:
        :%systems
}

#| Symbols for the Adlam numbering system (adlm)
method adlam is aliased-by<adlm> { %!systems<adlm> // %!systems<latn> }

#| Symbols for the Ahom numbering system (ahom)
method ahom { %!systems<ahom> // %!systems<latn> }

#| Symbols for the Arabic-Indic numbering system (arab)
method arabic { %!systems<arab> // %!systems<latn> }

#| Symbols for the Extended Arabic-Indic numbering system (arabext)
method arabic-extended { %!systems<arabext> // %!systems<latn> }

#| Symbols for the Armenian upper case numbering system (armn)
method armenian { %!systems<armn> // %!systems<latn> }

#| Symbols for the Armenian lower case numbering system (armnlow)
method armenian-lc { %!systems<armnlow> // %!systems<latn> }

#| Symbols for the Balinese numbering system (bali)
method balinese { %!systems<bali> // %!systems<latn> }

#| Symbols for the Bengali numbering system (beng)
method bengali { %!systems<beng> // %!systems<latn> }

#| Symbols for the Bhaiksuki numbering system (bhks)
method bhaiksuki { %!systems<bhks> // %!systems<latn> }

#| Symbols for the Brahmi numbering system (brah)
method brahmi { %!systems<brah> // %!systems<latn> }

#| Symbols for the Chakma numbering system (cakm)
method chakma { %!systems<cakm> // %!systems<latn> }

#| Symbols for the Cham numbering system (cham)
method cham { %!systems<cham> // %!systems<latn> }

#| Symbols for the Cyrillic numbering system (cyrl)
method cyrillic { %!systems<cyrl> // %!systems<latn> }

#| Symbols for the Devanagari numbering system (deva)
method devanagari { %!systems<deva> // %!systems<latn> }

#| Symbols for the Dives Akuru numbering system (diak)
method dives-akuru { %!systems<diak> // %!systems<latn> }

#| Symbols for the Ethiopic numbering system (ethi)
method ethiopic { %!systems<ethi> // %!systems<latn> }

#| Symbols for the Financial numbering system (finance)
method financial { %!systems<finance> // %!systems<latn> }

#| Symbols for the Full width numbering system (fullwide)
method full-width { %!systems<fullwide> // %!systems<latn> }

#| Symbols for the Georgian numbering system (geor)
method georgian { %!systems<geor> // %!systems<latn> }

#| Symbols for the Gunjala Gondi numbering system (gong)
method gunjala-gondi { %!systems<gong> // %!systems<latn> }

#| Symbols for the Masaram Gondi numbering system (gonm)
method masaram-gondi { %!systems<gonm> // %!systems<latn> }

#| Symbols for the Greek upper case numbering system (grek)
method greek { %!systems<grek> // %!systems<latn> }

#| Symbols for the Greek lower case numbering system (greklow)
method greek-lc { %!systems<greklow> // %!systems<latn> }

#| Symbols for the Gujarati numbering system (gujr)
method gujarati { %!systems<gujr> // %!systems<latn> }

#| Symbols for the Gurmukhi numbering system (guru)
method gurmukhi { %!systems<guru> // %!systems<latn> }

#| Symbols for the Han-character day-of-month numbering for traditional calendars (hanidays)
method han-days { %!systems<hanidays> // %!systems<latn> }

#| Symbols for the Positional decimal system using Chinese number ideographs (hanidec))
method han-decimal { %!systems<hanidec> // %!systems<latn> }

#| Symbols for the Simplified Chinese numbering system (hans)
method han-simplified { %!systems<hans> // %!systems<latn> }

#| Symbols for the Simplified Chinese financial numbering system (hansfin)
method han-simplified-financial { %!systems<hansfin> // %!systems<latn> }

#| Symbols for the Traditional Chinese numbering system (hant)
method han-traditional { %!systems<hant> // %!systems<latn> }

#| Symbols for the Traditional Chinese financial numbering system (hantfin)
method han-traditional-financial { %!systems<hantfin> // %!systems<latn> }

#| Symbols for the Hebrew numbering system (hebr)
method hebrew { %!systems<hebr> // %!systems<latn> }

#| Symbols for the Pahawh Hmong numbering system (hmng)
method pahawh-hmong { %!systems<hmng> // %!systems<latn> }

#| Symbols for the Nyiakeng Puachue Hmong numbering system (hmnp)
method nyiakeng-puachue-hmong { %!systems<hmnp> // %!systems<latn> }

#| Symbols for the Javanese numbering system (java)
method javanese { %!systems<java> // %!systems<latn> }

#| Symbols for the Japanese numbering system (jpan)
method japanese { %!systems<jpan> // %!systems<latn> }

#| Symbols for the Japanese financial numbering system (jpanfin)
method japanese-financial { %!systems<jpanfin> // %!systems<latn> }

#| Symbols for the Japanese first-year Gannen numbering for Japanese calendar (jpanyear)
method japanese-year { %!systems<jpanyear> // %!systems<latn> }

#| Symbols for the Kayah Li numbering system (kali)
method kayah-li { %!systems<kali> // %!systems<latn> }

#| Symbols for the Khmer numbering system (khmr)
method khmer { %!systems<khmr> // %!systems<latn> }

#| Symbols for the Kannada numbering system (knda)
method kannada { %!systems<knda> // %!systems<latn> }

#| Symbols for the Tai Tham Hora (secular) numbering system (lana)
method lanna-hora { %!systems<secular> // %!systems<latn> }

#| Symbols for the Tai Tham Tham (ecclesiastical) numbering system (lanatham)
method lanna-tham { %!systems<ecclesiastical> // %!systems<latn> }

#| Symbols for the Lao numbering system (laoo)
method lao { %!systems<laoo> // %!systems<latn> }

#| Symbols for the Latin numbering system (latn)
method latin { %!systems<latn> }

#| Symbols for the Lepcha numbering system (lepc)
method lepcha { %!systems<lepc> // %!systems<latn> }

#| Symbols for the Limbu numbering system (limb)
method limbu { %!systems<limb> // %!systems<latn> }

#| Symbols for the Mathematical bold numbering system (mathbold)
method math-bold { %!systems<mathbold> // %!systems<latn> }

#| Symbols for the Mathematical double-struck numbering system (mathdbl)
method math-double { %!systems<mathdbl> // %!systems<latn> }

#| Symbols for the Mathematical monospace numbering system (mathmono)
method math-mono { %!systems<mathmono> // %!systems<latn> }

#| Symbols for the Mathematical sans-serif bold numbering system (mathsanb)
method math-sans-bold { %!systems<mathsanb> // %!systems<latn> }

#| Symbols for the Mathematical sans-serif numbering system (mathsans)
method math-sans { %!systems<mathsans> // %!systems<latn> }

#| Symbols for the Malayalam numbering system (mlym)
method malayalam { %!systems<mlym> // %!systems<latn> }

#| Symbols for the Modi numbering system (modi)
method modi { %!systems<modi> // %!systems<latn> }

#| Symbols for the Mongolian numbering system (mong)
method mongolian { %!systems<mong> // %!systems<latn> }

#| Symbols for the Mro numbering system (mroo)
method mro { %!systems<mroo> // %!systems<latn> }

#| Symbols for the Meetei Mayek numbering system (mtei)
method meetei-mayek { %!systems<mtei> // %!systems<latn> }

#| Symbols for the Myanmar numbering system (mymr)
method myanmar { %!systems<mymr> // %!systems<latn> }

#| Symbols for the Myanmar Shan numbering system (mymrshan)
method myanmar-shan { %!systems<mymrshan> // %!systems<latn> }

#| Symbols for the Myanmar Tai Laing numbering system (mymrtlng)
method myanmar-tai-laing { %!systems<mymrtlng> // %!systems<latn> }

#| Symbols for the Native numbering system (native)
method native { %!systems<native> // %!systems<latn> }

#| Symbols for the Newa numbering system (newa)
method newa { %!systems<newa> // %!systems<latn> }

#| Symbols for the N'Ko numbering system (nkoo)
method nko { %!systems<nkoo> // %!systems<latn> }

#| Symbols for the Ol Chiki numbering system (olck)
method ol-chiki { %!systems<olck> // %!systems<latn> }

#| Symbols for the Oriya numbering system (orya)
method oriya { %!systems<orya> // %!systems<latn> }

#| Symbols for the Osmanya numbering system (osma)
method osmanya { %!systems<osma> // %!systems<latn> }

#| Symbols for the Hanifi Rohingya numbering system (rohg)
method hanifi-rohingya { %!systems<rohg> // %!systems<latn> }

#| Symbols for the Roman upper case numbering system (roman)
method roman { %!systems<roman> // %!systems<latn> }

#| Symbols for the Roman lowercase numbering system (romanlow)
method roman-lc { %!systems<romanlow> // %!systems<latn> }

#| Symbols for the Saurashtra numbering system (saur)
method saurashtra { %!systems<saur> // %!systems<latn> }

#| Symbols for the Legacy computing segmented numbering system (segment)
method segmented { %!systems<segment> // %!systems<latn> }

#| Symbols for the Sharada numbering system (shrd)
method sharada { %!systems<shrd> // %!systems<latn> }

#| Symbols for the Khudawadi numbering system (sind)
method khudawadi { %!systems<sind> // %!systems<latn> }

#| Symbols for the Sinhala Lith numbering system (sinh)
method sinhala { %!systems<sinh> // %!systems<latn> }

#| Symbols for the Sora_Sompeng numbering system (sora)
method sora-sompeng { %!systems<sora> // %!systems<latn> }

#| Symbols for the Sundanese numbering system (sund)
method sundanese { %!systems<sund> // %!systems<latn> }

#| Symbols for the Takri numbering system (takr)
method takri { %!systems<takr> // %!systems<latn> }

#| Symbols for the New Tai Lue numbering system (talu)
method new-tai-lue { %!systems<talu> // %!systems<latn> }

#| Symbols for the Tamil numbering system (taml)
method tamil { %!systems<taml> // %!systems<latn> }

#| Symbols for the Modern Tamil decimal numbering system (tamldec)
method tamil-decimal { %!systems<tamldec> // %!systems<latn> }

#| Symbols for the Telugu numbering system (telu)
method telugu { %!systems<telu> // %!systems<latn> }

#| Symbols for the Thai numbering system (thai)
method thai { %!systems<thai> // %!systems<latn> }

#| Symbols for the Tirhuta numbering system (tirh)
method tirhuta { %!systems<tirh> // %!systems<latn> }

#| Symbols for the Tibetan numbering system (tibt)
method tibetan { %!systems<tibt> // %!systems<latn> }

#| Symbols for the Traditional numbering system (traditio)
method traditional { %!systems<traditio> // %!systems<latn> }

#| Symbols for the Vai numbering system (vaii)
method vai { %!systems<vaii> // %!systems<latn> }

#| Symbols for the Warang Citi numbering system (wara)
method warang-citi { %!systems<wara> // %!systems<latn> }

#| Symbols for the Wancho numbering system (wcho)
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
    mymrshan =>        'myanmar-shan',
    mymrtlng =>        'myanmar-tai-laing',
    nkoo =>            'nko',
    olck =>            'ol-chiki',
    orya =>            'oriya',
    osma =>            'osmanya',
    rohg => 'hanifi-rohingya',
    romanlow => 'roman-lc',
    saur => 'saurashtra',
    segment => 'segmented',
    shrd => 'sharada',
    sind => 'khudawadi',
    sinh => 'sinhala',
    sora => 'sora-sompeng',
    sund => 'sundanese',
    takr => 'takri',
    talu => 'new-tai-lue',
    taml => 'tamil',
    tamldec => 'tamil-decimal',
    telu => 'telugu',
    thai => 'thai',
    tirh => 'tirhuta',
    tibt => 'tibetan',
    traditio => 'traditional',
    vaii => 'vai',
    wara => 'warang-citi',
    wcho => 'wancho',
);
method DETOUR(-->detour) {;}


#`<<<<<# GENERATOR: Use toggle-generators.raku to [dis|en]able this code.
method encode(%*symbol-sets) {
    use Intl::CLDR::Util::StrEncode;

    my
    $result = buf8.new;
    $result.append: 0;

    my $count = 0;
    for %*symbol-sets.keys -> $type {
        next unless %*symbol-sets{$type}; # these would just have an alias element, so parsed version is empty
        $result ~= StrEncode::get($type);
        $result ~= CLDR::SymbolSet.encode(%*symbol-sets{$type});
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
    CLDR::SymbolSet.parse: (base{$_} //= Hash.new), xml
        with xml<numberSystem>; # ← one will have no type, that's the fallback, which aliases to latn, so we ignore it︎
}
>>>>># GENERATOR