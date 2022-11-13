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
method ahom is aliased-by<ahom> { %!systems<ahom> // %!systems<latn> }

#| Symbols for the Arabic-Indic numbering system (arab)
method arabic is aliased-by<arab> { %!systems<arab> // %!systems<latn> }

#| Symbols for the Extended Arabic-Indic numbering system (arabext)
method arabic-extended is aliased-by<arabext> { %!systems<arabext> // %!systems<latn> }

#| Symbols for the Armenian upper case numbering system (armn)
method armenian is aliased-by<armn> { %!systems<armn> // %!systems<latn> }

#| Symbols for the Armenian lower case numbering system (armnlow)
method armenian-lc is aliased-by<armnlow> { %!systems<armnlow> // %!systems<latn> }

#| Symbols for the Balinese numbering system (bali)
method balinese is aliased-by<bali> { %!systems<bali> // %!systems<latn> }

#| Symbols for the Bengali numbering system (beng)
method bengali is aliased-by<beng> { %!systems<beng> // %!systems<latn> }

#| Symbols for the Bhaiksuki numbering system (bhks)
method bhaiksuki is aliased-by<bhks> { %!systems<bhks> // %!systems<latn> }

#| Symbols for the Brahmi numbering system (brah)
method brahmi is aliased-by<brah> { %!systems<brah> // %!systems<latn> }

#| Symbols for the Chakma numbering system (cakm)
method chakma is aliased-by<cakm> { %!systems<cakm> // %!systems<latn> }

#| Symbols for the Cham numbering system (cham)
method cham is aliased-by<cham> { %!systems<cham> // %!systems<latn> }

#| Symbols for the Cyrillic numbering system (cyrl)
method cyrillic is aliased-by<cyrl> { %!systems<cyrl> // %!systems<latn> }

#| Symbols for the Devanagari numbering system (deva)
method devanagari is aliased-by<deva> { %!systems<deva> // %!systems<latn> }

#| Symbols for the Dives Akuru numbering system (diak)
method dives-akuru is aliased-by<diak> { %!systems<diak> // %!systems<latn> }

#| Symbols for the Ethiopic numbering system (ethi)
method ethiopic is aliased-by<ethi> { %!systems<ethi> // %!systems<latn> }

#| Symbols for the Financial numbering system (finance)
method financial is aliased-by<finance> { %!systems<finance> // %!systems<latn> }

#| Symbols for the Full width numbering system (fullwide)
method full-width is aliased-by<fullwide> { %!systems<fullwide> // %!systems<latn> }

#| Symbols for the Georgian numbering system (geor)
method georgian is aliased-by<geor> { %!systems<geor> // %!systems<latn> }

#| Symbols for the Gunjala Gondi numbering system (gong)
method gunjala-gondi is aliased-by<gong> { %!systems<gong> // %!systems<latn> }

#| Symbols for the Masaram Gondi numbering system (gonm)
method masaram-gondi is aliased-by<gonm> { %!systems<gonm> // %!systems<latn> }

#| Symbols for the Greek upper case numbering system (grek)
method greek is aliased-by<grek> { %!systems<grek> // %!systems<latn> }

#| Symbols for the Greek lower case numbering system (greklow)
method greek-lc is aliased-by<greklow> { %!systems<greklow> // %!systems<latn> }

#| Symbols for the Gujarati numbering system (gujr)
method gujarati is aliased-by<gujr> { %!systems<gujr> // %!systems<latn> }

#| Symbols for the Gurmukhi numbering system (guru)
method gurmukhi is aliased-by<guru> { %!systems<guru> // %!systems<latn> }

#| Symbols for the Han-character day-of-month numbering for traditional calendars (hanidays)
method han-days is aliased-by<hanidays> { %!systems<hanidays> // %!systems<latn> }

#| Symbols for the Positional decimal system using Chinese number ideographs (hanidec))
method han-decimal is aliased-by<hanidec> { %!systems<hanidec> // %!systems<latn> }

#| Symbols for the Simplified Chinese numbering system (hans)
method han-simplified is aliased-by<hans> { %!systems<hans> // %!systems<latn> }

#| Symbols for the Simplified Chinese financial numbering system (hansfin)
method han-simplified-financial is aliased-by<hansfin> { %!systems<hansfin> // %!systems<latn> }

#| Symbols for the Traditional Chinese numbering system (hant)
method han-traditional is aliased-by<hant> { %!systems<hant> // %!systems<latn> }

#| Symbols for the Traditional Chinese financial numbering system (hantfin)
method han-traditional-financial is aliased-by<hantfin> { %!systems<hantfin> // %!systems<latn> }

#| Symbols for the Hebrew numbering system (hebr)
method hebrew is aliased-by<hebr> { %!systems<hebr> // %!systems<latn> }

#| Symbols for the Pahawh Hmong numbering system (hmng)
method pahawh-hmong is aliased-by<hmng> { %!systems<hmng> // %!systems<latn> }

#| Symbols for the Nyiakeng Puachue Hmong numbering system (hmnp)
method nyiakeng-puachue-hmong is aliased-by<hmnp> { %!systems<hmnp> // %!systems<latn> }

#| Symbols for the Javanese numbering system (java)
method javanese is aliased-by<java> { %!systems<java> // %!systems<latn> }

#| Symbols for the Japanese numbering system (jpan)
method japanese is aliased-by<jpan> { %!systems<jpan> // %!systems<latn> }

#| Symbols for the Japanese financial numbering system (jpanfin)
method japanese-financial is aliased-by<jpanfin> { %!systems<jpanfin> // %!systems<latn> }

#| Symbols for the Japanese first-year Gannen numbering for Japanese calendar (jpanyear)
method japanese-year is aliased-by<jpanyear> { %!systems<jpanyear> // %!systems<latn> }

#| Symbols for the Kayah Li numbering system (kali)
method kayah-li is aliased-by<kali> { %!systems<kali> // %!systems<latn> }

#| Symbols for the Khmer numbering system (khmr)
method khmer is aliased-by<khmr> { %!systems<khmr> // %!systems<latn> }

#| Symbols for the Kannada numbering system (knda)
method kannada is aliased-by<knda> { %!systems<knda> // %!systems<latn> }

#| Symbols for the Tai Tham Hora (secular) numbering system (lana)
method lanna-hora is aliased-by<lana> { %!systems<lana> // %!systems<latn> }

#| Symbols for the Tai Tham Tham (ecclesiastical) numbering system (lanatham)
method lanna-tham is aliased-by<lanatham> { %!systems<lanatham> // %!systems<latn> }

#| Symbols for the Lao numbering system (laoo)
method lao is aliased-by<laoo> { %!systems<laoo> // %!systems<latn> }

#| Symbols for the Latin numbering system (latn)
method latin is aliased-by<latn> { %!systems<latn> }

#| Symbols for the Lepcha numbering system (lepc)
method lepcha is aliased-by<lepc> { %!systems<lepc> // %!systems<latn> }

#| Symbols for the Limbu numbering system (limb)
method limbu is aliased-by<limb> { %!systems<limb> // %!systems<latn> }

#| Symbols for the Mathematical bold numbering system (mathbold)
method math-bold is aliased-by<mathbold> { %!systems<mathbold> // %!systems<latn> }

#| Symbols for the Mathematical double-struck numbering system (mathdbl)
method math-double is aliased-by<mathdbl> { %!systems<mathdbl> // %!systems<latn> }

#| Symbols for the Mathematical monospace numbering system (mathmono)
method math-mono is aliased-by<mathmono> { %!systems<mathmono> // %!systems<latn> }

#| Symbols for the Mathematical sans-serif bold numbering system (mathsanb)
method math-sans-bold is aliased-by<mathsanb> { %!systems<mathsanb> // %!systems<latn> }

#| Symbols for the Mathematical sans-serif numbering system (mathsans)
method math-sans is aliased-by<mathsans> { %!systems<mathsans> // %!systems<latn> }

#| Symbols for the Malayalam numbering system (mlym)
method malayalam is aliased-by<mlym> { %!systems<mlym> // %!systems<latn> }

#| Symbols for the Modi numbering system (modi)
method modi is aliased-by<modi> { %!systems<modi> // %!systems<latn> }

#| Symbols for the Mongolian numbering system (mong)
method mongolian is aliased-by<mong> { %!systems<mong> // %!systems<latn> }

#| Symbols for the Mro numbering system (mroo)
method mro is aliased-by<mroo> { %!systems<mroo> // %!systems<latn> }

#| Symbols for the Meetei Mayek numbering system (mtei)
method meetei-mayek is aliased-by<mtei> { %!systems<mtei> // %!systems<latn> }

#| Symbols for the Myanmar numbering system (mymr)
method myanmar is aliased-by<mymr> { %!systems<mymr> // %!systems<latn> }

#| Symbols for the Myanmar Shan numbering system (mymrshan)
method myanmar-shan is aliased-by<mymrshan> { %!systems<mymrshan> // %!systems<latn> }

#| Symbols for the Myanmar Tai Laing numbering system (mymrtlng)
method myanmar-tai-laing is aliased-by<mymrtlng> { %!systems<mymrtlng> // %!systems<latn> }

#| Symbols for the Native numbering system (native)
method native is aliased-by<native> { %!systems<native> // %!systems<latn> }

#| Symbols for the Newa numbering system (newa)
method newa is aliased-by<newa> { %!systems<newa> // %!systems<latn> }

#| Symbols for the N'Ko numbering system (nkoo)
method nko is aliased-by<nkoo> { %!systems<nkoo> // %!systems<latn> }

#| Symbols for the Ol Chiki numbering system (olck)
method ol-chiki is aliased-by<olck> { %!systems<olck> // %!systems<latn> }

#| Symbols for the Oriya numbering system (orya)
method oriya is aliased-by<orya> { %!systems<orya> // %!systems<latn> }

#| Symbols for the Osmanya numbering system (osma)
method osmanya is aliased-by<osma> { %!systems<osma> // %!systems<latn> }

#| Symbols for the Hanifi Rohingya numbering system (rohg)
method hanifi-rohingya is aliased-by<rohg> { %!systems<rohg> // %!systems<latn> }

#| Symbols for the Roman upper case numbering system (roman)
method roman is aliased-by<roman> { %!systems<roman> // %!systems<latn> }

#| Symbols for the Roman lowercase numbering system (romanlow)
method roman-lc is aliased-by<romanlow> { %!systems<romanlow> // %!systems<latn> }

#| Symbols for the Saurashtra numbering system (saur)
method saurashtra is aliased-by<saur> { %!systems<saur> // %!systems<latn> }

#| Symbols for the Legacy computing segmented numbering system (segment)
method segmented is aliased-by<segment> { %!systems<segment> // %!systems<latn> }

#| Symbols for the Sharada numbering system (shrd)
method sharada is aliased-by<shrd> { %!systems<shrd> // %!systems<latn> }

#| Symbols for the Khudawadi numbering system (sind)
method khudawadi is aliased-by<sind> { %!systems<sind> // %!systems<latn> }

#| Symbols for the Sinhala Lith numbering system (sinh)
method sinhala is aliased-by<sinh> { %!systems<sinh> // %!systems<latn> }

#| Symbols for the Sora_Sompeng numbering system (sora)
method sora-sompeng is aliased-by<sora> { %!systems<sora> // %!systems<latn> }

#| Symbols for the Sundanese numbering system (sund)
method sundanese is aliased-by<sund> { %!systems<sund> // %!systems<latn> }

#| Symbols for the Takri numbering system (takr)
method takri is aliased-by<takr> { %!systems<takr> // %!systems<latn> }

#| Symbols for the New Tai Lue numbering system (talu)
method new-tai-lue is aliased-by<talu> { %!systems<talu> // %!systems<latn> }

#| Symbols for the Tamil numbering system (taml)
method tamil is aliased-by<taml> { %!systems<taml> // %!systems<latn> }

#| Symbols for the Modern Tamil decimal numbering system (tamldec)
method tamil-decimal is aliased-by<tamldec> { %!systems<tamldec> // %!systems<latn> }

#| Symbols for the Telugu numbering system (telu)
method telugu is aliased-by<telu> { %!systems<telu> // %!systems<latn> }

#| Symbols for the Thai numbering system (thai)
method thai is aliased-by<thai> { %!systems<thai> // %!systems<latn> }

#| Symbols for the Tirhuta numbering system (tirh)
method tirhuta is aliased-by<tirh> { %!systems<tirh> // %!systems<latn> }

#| Symbols for the Tibetan numbering system (tibt)
method tibetan is aliased-by<tibt> { %!systems<tibt> // %!systems<latn> }

#| Symbols for the Traditional numbering system (traditio)
method traditional is aliased-by<traditio> { %!systems<traditio> // %!systems<latn> }

#| Symbols for the Vai numbering system (vaii)
method vai is aliased-by<vaii> { %!systems<vaii> // %!systems<latn> }

#| Symbols for the Warang Citi numbering system (wara)
method warang-citi is aliased-by<wara> { %!systems<wara> // %!systems<latn> }

#| Symbols for the Wancho numbering system (wcho)
method wancho is aliased-by<wcho> { %!systems<wcho> // %!systems<latn> }


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