use Intl::CLDR::Immutability;

unit class CLDR-DecimalFormats is CLDR-ItemNew;

use Intl::CLDR::Types::DecimalFormat;
use Intl::CLDR::Types::DecimalFormatSet;

has $!parent;
has %systems;

# The number systems here come from commons/bcp47/number.xml
# You can autogenerate some of this by using the following regex on the file:
# for ($text ~~ m:g/'name="' (<alnum>+) '" description="' (<-["]>+)/) -> $match {
#  say 'has CLDR-Symbols $.', $match[0].Str, " #= ", $match[1].Str;
# }
# main/root.xml doesn't actually provide for all of these (e.g. armn), but they are
# definitely included in other places.  Because all except for Arabic fallback to
# Latn, that is maintained in the encoding process.


method latn {
    DecimalFormatSet.new: (%systems<latn> // %systems<latn>);
}




#`<<<
has CLDR-Symbols $.adlam;           #= Adlam numbering system (adlm)
has CLDR-Symbols $.ahom;            #= Ahom numbering system (ahom)
has CLDR-Symbols $.arabic;          #= Arabic-Indic numbering system (arab)
has CLDR-Symbols $.arabic-extended; #= Extended Arabic-Indic numbering system (arabext)
has CLDR-Symbols $.armenian;        #= Armenian upper case numbering system (armn)
has CLDR-Symbols $.armenian-lc;     #= Armenian lower case numbering system (armnlow)
has CLDR-Symbols $.balinese;        #= Balinese numbering system (bali)
has CLDR-Symbols $.bengali;         #= Bengali numbering system (beng)
has CLDR-Symbols $.bhaiksuki;       #= Bhaiksuki numbering system (bhks)
has CLDR-Symbols $.brahmi;          #= Brahmi numbering system (brah)
has CLDR-Symbols $.chakma;          #= Chakma numbering system (cakm)
has CLDR-Symbols $.cham;            #= Cham numbering system (cham)
has CLDR-Symbols $.cyrillic;        #= Cyrillic numbering system (cyrl)
has CLDR-Symbols $.devanagari;      #= Devanagari numbering system (deva)
has CLDR-Symbols $.dives-akuru;     #= Dives Akuru numbering system (diak)
has CLDR-Symbols $.ethiopic;        #= Ethiopic numbering system (ethi)
has CLDR-Symbols $.financial;       #= Financial numbering system (finance)
has CLDR-Symbols $.full-width;      #= Full width numbering system (fullwide)
has CLDR-Symbols $.georgian;        #= Georgian numbering system (geor)
has CLDR-Symbols $.gunjala-gondi;   #= Gunjala Gondi numbering system (gong)
has CLDR-Symbols $.masaram-gondi;   #= Masaram Gondi numbering system (gonm)
has CLDR-Symbols $.greek;           #= Greek upper case numbering system (grek)
has CLDR-Symbols $.greek-lc;        #= Greek lower case numbering system (greklow)
has CLDR-Symbols $.gujarati;        #= Gujarati numbering system (gujr)
has CLDR-Symbols $.gurmukhi;        #= Gurmukhi numbering system (guru)
has CLDR-Symbols $.han-days;        #= Han-character day-of-month numbering for traditional calendars (hanidays)
has CLDR-Symbols $.han-decimal;     #= Positional decimal system using Chinese number ideographs (hanidec))
has CLDR-Symbols $.han-simplified;  #= Simplified Chinese numbering system (hans)
has CLDR-Symbols $.han-simplified-financial;  #= Simplified Chinese financial numbering system (hansfin)
has CLDR-Symbols $.han-traditional; #= Traditional Chinese numbering system (hant)
has CLDR-Symbols $.han-traditional-financial; #= Traditional Chinese financial numbering system (hantfin)
has CLDR-Symbols $.hebrew;          #= Hebrew numbering system (hebr)
has CLDR-Symbols $.pahawh-hmong;    #= Pahawh Hmong numbering system (hmng)
has CLDR-Symbols $.nyiakeng-puachue-hmong; #= Nyiakeng Puachue Hmong numbering system (hmnp)
has CLDR-Symbols $.javanese;        #= Javanese numbering system (java)
has CLDR-Symbols $.japanese;        #= Japanese numbering system (jpan)
has CLDR-Symbols $.japanese-financial; #= Japanese financial numbering system (jpanfin)
has CLDR-Symbols $.japanese-year;   #= Japanese first-year Gannen numbering for Japanese calendar (jpanyear)
has CLDR-Symbols $.kayah-li;        #= Kayah Li numbering system (kali)
has CLDR-Symbols $.khmer;           #= Khmer numbering system (khmr)
has CLDR-Symbols $.kannada;         #= Kannada numbering system (knda)
has CLDR-Symbols $.lanna-hora;      #= Tai Tham Hora (secular) numbering system (lana)
has CLDR-Symbols $.lanna-tham;      #= Tai Tham Tham (ecclesiastical) numbering system (lanatham)
has CLDR-Symbols $.lao;             #= Lao numbering system (laoo)
has CLDR-Symbols $.latin;           #= Latin numbering system (latn)
has CLDR-Symbols $.lepcha;          #= Lepcha numbering system (lepc)
has CLDR-Symbols $.limbu;           #= Limbu numbering system (limb)
has CLDR-Symbols $.math-bold;       #= Mathematical bold numbering system (mathbold)
has CLDR-Symbols $.math-double;     #= Mathematical double-struck numbering system (mathdbl)
has CLDR-Symbols $.math-mono;       #= Mathematical monospace numbering system (mathmono)
has CLDR-Symbols $.math-sans-bold;  #= Mathematical sans-serif bold numbering system (mathsanb)
has CLDR-Symbols $.math-sans;       #= Mathematical sans-serif numbering system (mathsans)
has CLDR-Symbols $.malayalam;       #= Malayalam numbering system (mlym)
has CLDR-Symbols $.modi;            #= Modi numbering system (modi)
has CLDR-Symbols $.mongolian;       #= Mongolian numbering system (mong)
has CLDR-Symbols $.mro;             #= Mro numbering system (mroo)
has CLDR-Symbols $.meetei-mayek;    #= Meetei Mayek numbering system (mtei)
has CLDR-Symbols $.myanmar;         #= Myanmar numbering system (mymr)
has CLDR-Symbols $.myanmar-shan;    #= Myanmar Shan numbering system (mymrshan)
has CLDR-Symbols $.myanmar-tai-laing; #= Myanmar Tai Laing numbering system (mymrtlng)
has CLDR-Symbols $.native;          #= Native numbering system (native)
has CLDR-Symbols $.newa;            #= Newa numbering system (newa)
has CLDR-Symbols $.nko;             #= N'Ko numbering system (nkoo)
has CLDR-Symbols $.ol-chiki;        #= Ol Chiki numbering system (olck)
has CLDR-Symbols $.oriya;           #= Oriya numbering system (orya)
has CLDR-Symbols $.osmanya;         #= Osmanya numbering system (osma)
has CLDR-Symbols $.hanifi-rohingya; #= Hanifi Rohingya numbering system (rohg)
has CLDR-Symbols $.roman;           #= Roman upper case numbering system (roman)
has CLDR-Symbols $.roman-lc;        #= Roman lowercase numbering system (romanlow)
has CLDR-Symbols $.saurashtra;      #= Saurashtra numbering system (saur)
has CLDR-Symbols $.segmented;       #= Legacy computing segmented numbering system (segment)
has CLDR-Symbols $.sharada;         #= Sharada numbering system (shrd)
has CLDR-Symbols $.khudawadi;       #= Khudawadi numbering system (sind)
has CLDR-Symbols $.sinhala;         #= Sinhala Lith numbering system (sinh)
has CLDR-Symbols $.sora-sompeng;    #= Sora_Sompeng numbering system (sora)
has CLDR-Symbols $.sundanese;       #= Sundanese numbering system (sund)
has CLDR-Symbols $.takri;           #= Takri numbering system (takr)
has CLDR-Symbols $.new-tai-lue;     #= New Tai Lue numbering system (talu)
has CLDR-Symbols $.tamil;           #= Tamil numbering system (taml)
has CLDR-Symbols $.tamil-decimal;   #= Modern Tamil decimal numbering system (tamldec)
has CLDR-Symbols $.telugu;          #= Telugu numbering system (telu)
has CLDR-Symbols $.thai;            #= Thai numbering system (thai)
has CLDR-Symbols $.tirhuta;         #= Tirhuta numbering system (tirh)
has CLDR-Symbols $.tibetan;         #= Tibetan numbering system (tibt)
has CLDR-Symbols $.traditional;     #= Traditional numbering system (traditio)
has CLDR-Symbols $.vai;             #= Vai numbering system (vaii)
has CLDR-Symbols $.warang-citi;     #= Warang Citi numbering system (wara)
has CLDR-Symbols $.wancho;          #= Wancho numbering system (wcho)
>>>

#| Creates a new CLDR-DayPeriodContext object
method new(|c) {
    self.bless!bind-init: |c;
}

submethod !bind-init(\blob, uint64 $offset is rw, \parent) {
    $!parent := parent;


    self
}

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


##`<<<<< # GENERATOR: This method should only be uncommented out by the parsing script
method encode(%*symbol-sets) {
    my $result = buf8.new;

    for <adlm ahom arab arabext armn armnlow bali beng bhks brah cakm cham cyrl
         deva diak ethi finance fullwide geor gong gonm grek greklow gujr guru
         hanidays hanidec hans hansfin hant hantfin hebr hmng hmnp java jpan
         jpanfin jpanyear jali jhmer knda lana lanatham laoo latn lepc limb
         mathbold mathdbl mathmono mathsanb mathsans mlym modi mong mroo mtei
         mymr mymrshan mymrtlng native newa nkoo olck orya osma rohg roman
         romanlow saur segment shrd sind sinh sora sund takr talu taml tamldec
         telu thai tirh tibt traditio vaii wara wcho> -> $type {

        # TODO: special handling for traditional / financial / native (need to look it up from main
        # %*numbers hash:
        #       <defaultNumberingSystem>latn</defaultNumberingSystem>
        #		<otherNumberingSystems>
        #			<native>latn</native>
        #			<traditional>armn</traditional>
        #			<financial>armn</financial>
        #		</otherNumberingSystems>

        # Fallback to Latin immediately here if not available
        $result ~= CLDR-Symbols.encode(%*symbol-sets{$type} || %*symbol-sets<latn> || Hash);
    }

    $result
}
method parse(\base, \xml) {
    use Intl::CLDR::Util::XML-Helper;

    my $system = xml<numberSystem> // 'latn';
    # At this level, there are four lengths (long, medium, short, narrow) of which only two are currently used
    # (long and short), as well as a fifth pseudo length (no type) that is considered to be the defacto standard.
    for xml.&elems('decimalFormatLengths') -> \xml-length {
        my $length = xml-length<length> // 'standard';

        # At this level, there is a single decimalpattern (only currency pattern has two), which has multiple patterns
        # that have various attributes by count and 'type' (a divisor used in formatting).
        for xml-length.&elem('decimalFormat').&elems('pattern') -> \xml-pattern {
            die "Add case support to DecimalFormats.pm6" with xml-pattern<case>;
            die "Add case support to DecimalFormats.pm6" with xml-pattern<gender>;

            base{$system}{$length}{.<count> // 'other'}{.<type> // '0'} = <

        }
    }
    CLDR-Symbols.parse: (base{$_} //= Hash.new), xml
    with xml<numberSystem>; # ← one will have no type, that's the fallback, which aliases to latn, so we ignore it︎
}
#>>>>> # GENERATOR
