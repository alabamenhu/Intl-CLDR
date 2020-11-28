use Intl::CLDR::Immutability;

unit class CLDR-SymbolSets is CLDR-Item;

use Intl::CLDR::Types::Symbols;

has $!parent;

# The number systems here come from commons/bcp47/number.xml
# You can autogenerate some of this by using the following regex on the file:
# for ($text ~~ m:g/'name="' (<alnum>+) '" description="' (<-["]>+)/) -> $match {
#  say 'has CLDR-Symbols $.', $match[0].Str, " #= ", $match[1].Str;
# }
# main/root.xml doesn't actually provide for all of these (e.g. armn), but they are
# definitely included in other places.  Because all except for Arabic fallback to
# Latn, that is maintained in the encoding process.
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


#| Creates a new CLDR-DayPeriodContext object
method new(|c) {
    self.bless!bind-init: |c;
}

submethod !bind-init(\blob, uint64 $offset is rw, \parent) {
    $!parent := parent;

    self.Hash::BIND-KEY: 'adlam',           $!adlam;
    self.Hash::BIND-KEY: 'adlm',            $!adlam;
    self.Hash::BIND-KEY: 'ahom',            $!ahom;
    self.Hash::BIND-KEY: 'arabic',          $!arabic;
    self.Hash::BIND-KEY: 'arab',            $!arabic;
    self.Hash::BIND-KEY: 'arabic-extended', $!arabic-extended;
    self.Hash::BIND-KEY: 'arabext',         $!arabic-extended;
    self.Hash::BIND-KEY: 'armenian',        $!armenian;
    self.Hash::BIND-KEY: 'armn',            $!armenian;
    self.Hash::BIND-KEY: 'armenian-lc',     $!armenian-lc;
    self.Hash::BIND-KEY: 'armnlow',         $!armenian-lc;
    self.Hash::BIND-KEY: 'balinese',        $!balinese;
    self.Hash::BIND-KEY: 'bali',            $!balinese;
    self.Hash::BIND-KEY: 'bengali',         $!bengali;
    self.Hash::BIND-KEY: 'beng',            $!bengali;
    self.Hash::BIND-KEY: 'bhaiksuki',       $!bhaiksuki;
    self.Hash::BIND-KEY: 'bhks',            $!bhaiksuki;
    self.Hash::BIND-KEY: 'brahmi',          $!brahmi;
    self.Hash::BIND-KEY: 'brah',            $!brahmi;
    self.Hash::BIND-KEY: 'chakma',          $!chakma;
    self.Hash::BIND-KEY: 'cakm',            $!chakma;
    self.Hash::BIND-KEY: 'cham',            $!cham;
    self.Hash::BIND-KEY: 'cyrillic',        $!cyrillic;
    self.Hash::BIND-KEY: 'cyrl',            $!cyrillic;
    self.Hash::BIND-KEY: 'devanagari',      $!devanagari;
    self.Hash::BIND-KEY: 'deva',            $!devanagari;
    self.Hash::BIND-KEY: 'dives-akuru',     $!dives-akuru;
    self.Hash::BIND-KEY: 'diak',            $!dives-akuru;
    self.Hash::BIND-KEY: 'ethiopic',        $!ethiopic;
    self.Hash::BIND-KEY: 'ethi',            $!ethiopic;
    self.Hash::BIND-KEY: 'financial',       $!financial;
    self.Hash::BIND-KEY: 'finance',         $!financial;
    self.Hash::BIND-KEY: 'full-width',      $!full-width;
    self.Hash::BIND-KEY: 'fullwide',        $!full-width;
    self.Hash::BIND-KEY: 'georgian',        $!georgian;
    self.Hash::BIND-KEY: 'geor',            $!georgian;
    self.Hash::BIND-KEY: 'gunjala-gondi',   $!gunjala-gondi;
    self.Hash::BIND-KEY: 'gong',            $!gunjala-gondi;
    self.Hash::BIND-KEY: 'masaram-gondi',   $!masaram-gondi;
    self.Hash::BIND-KEY: 'gonm',            $!masaram-gondi;
    self.Hash::BIND-KEY: 'greek',           $!greek;
    self.Hash::BIND-KEY: 'grek',            $!greek;
    self.Hash::BIND-KEY: 'greek-lc',        $!greek-lc;
    self.Hash::BIND-KEY: 'greklow',         $!greek-lc;
    self.Hash::BIND-KEY: 'gujarati',        $!gujarati;
    self.Hash::BIND-KEY: 'gujr',            $!gujarati;
    self.Hash::BIND-KEY: 'gurmukhi',        $!gurmukhi;
    self.Hash::BIND-KEY: 'guru',            $!gurmukhi;
    self.Hash::BIND-KEY: 'han-days',        $!han-days;
    self.Hash::BIND-KEY: 'hanidays',        $!han-days;
    self.Hash::BIND-KEY: 'han-decimal',     $!han-decimal;
    self.Hash::BIND-KEY: 'hanidec',         $!han-decimal;
    self.Hash::BIND-KEY: 'han-simplified',  $!han-simplified;
    self.Hash::BIND-KEY: 'hans',            $!han-simplified;
    self.Hash::BIND-KEY: 'han-simplified-financial', $!han-simplified-financial;
    self.Hash::BIND-KEY: 'hansfin',         $!han-simplified-financial;
    self.Hash::BIND-KEY: 'han-traditional', $!han-traditional;
    self.Hash::BIND-KEY: 'hant',            $!han-traditional;
    self.Hash::BIND-KEY: 'han-traditional-financial', $!han-traditional-financial;
    self.Hash::BIND-KEY: 'hantfin',         $!han-traditional-financial;
    self.Hash::BIND-KEY: 'hebrew',          $!hebrew;
    self.Hash::BIND-KEY: 'hebr',            $!hebrew;
    self.Hash::BIND-KEY: 'pahawh-hmong',    $!pahawh-hmong;
    self.Hash::BIND-KEY: 'hmng',            $!pahawh-hmong;
    self.Hash::BIND-KEY: 'nyiakeng-puachue-hmong', $!nyiakeng-puachue-hmong;
    self.Hash::BIND-KEY: 'hmnp',            $!nyiakeng-puachue-hmong;
    self.Hash::BIND-KEY: 'javanese',        $!javanese;
    self.Hash::BIND-KEY: 'java',            $!javanese;
    self.Hash::BIND-KEY: 'japanese',        $!japanese;
    self.Hash::BIND-KEY: 'jpan',            $!japanese;
    self.Hash::BIND-KEY: 'japanese-financial', $!japanese-financial;
    self.Hash::BIND-KEY: 'jpanfin',         $!japanese-financial;
    self.Hash::BIND-KEY: 'japanese-year',   $!japanese-year;
    self.Hash::BIND-KEY: 'jpanyear',        $!japanese-year;
    self.Hash::BIND-KEY: 'kayah-li',        $!kayah-li;
    self.Hash::BIND-KEY: 'kali',            $!kayah-li;
    self.Hash::BIND-KEY: 'khmer',           $!khmer;
    self.Hash::BIND-KEY: 'khmr',            $!khmer;
    self.Hash::BIND-KEY: 'kannada',         $!kannada;
    self.Hash::BIND-KEY: 'knda',            $!kannada;
    self.Hash::BIND-KEY: 'lanna-hora',      $!lanna-hora;
    self.Hash::BIND-KEY: 'lana',            $!lanna-hora;
    self.Hash::BIND-KEY: 'lanna-tham',      $!lanna-tham;
    self.Hash::BIND-KEY: 'lanatham',        $!lanna-tham;
    self.Hash::BIND-KEY: 'lao',             $!lao;
    self.Hash::BIND-KEY: 'laoo',            $!lao;
    self.Hash::BIND-KEY: 'latin',           $!latin;
    self.Hash::BIND-KEY: 'latn',            $!latin;
    self.Hash::BIND-KEY: 'lepcha',          $!lepcha;
    self.Hash::BIND-KEY: 'lepc',            $!lepcha;
    self.Hash::BIND-KEY: 'limbu',           $!limbu;
    self.Hash::BIND-KEY: 'limb',            $!limbu;
    self.Hash::BIND-KEY: 'math-bold',       $!math-bold;
    self.Hash::BIND-KEY: 'mathbold',        $!math-bold;
    self.Hash::BIND-KEY: 'math-double',     $!math-double;
    self.Hash::BIND-KEY: 'mathdbl',         $!math-double;
    self.Hash::BIND-KEY: 'math-mono',       $!math-mono;
    self.Hash::BIND-KEY: 'mathmono',        $!math-mono;
    self.Hash::BIND-KEY: 'math-sans-bold',  $!math-sans-bold;
    self.Hash::BIND-KEY: 'mathsanb',        $!math-sans-bold;
    self.Hash::BIND-KEY: 'math-sans',       $!math-sans;
    self.Hash::BIND-KEY: 'mathsans',        $!math-sans;
    self.Hash::BIND-KEY: 'malayalam',       $!malayalam;
    self.Hash::BIND-KEY: 'mlym',            $!malayalam;
    self.Hash::BIND-KEY: 'modi',            $!modi;
    self.Hash::BIND-KEY: 'modi',            $!modi;
    self.Hash::BIND-KEY: 'mongolian',       $!mongolian;
    self.Hash::BIND-KEY: 'mong',            $!mongolian;
    self.Hash::BIND-KEY: 'mro',             $!mro;
    self.Hash::BIND-KEY: 'mroo',            $!mro;
    self.Hash::BIND-KEY: 'meetei-mayek',    $!meetei-mayek;
    self.Hash::BIND-KEY: 'mtei',            $!meetei-mayek;
    self.Hash::BIND-KEY: 'myanmar',         $!myanmar;
    self.Hash::BIND-KEY: 'mymr',            $!myanmar;
    self.Hash::BIND-KEY: 'myanmar-shan',    $!myanmar-shan;
    self.Hash::BIND-KEY: 'mymrshan',        $!myanmar-shan;
    self.Hash::BIND-KEY: 'myanmar-tai-laing', $!myanmar-tai-laing;
    self.Hash::BIND-KEY: 'mymrtlng',        $!myanmar-tai-laing;
    self.Hash::BIND-KEY: 'native',          $!native;
    self.Hash::BIND-KEY: 'newa',            $!newa;
    self.Hash::BIND-KEY: 'nko',             $!nko;
    self.Hash::BIND-KEY: 'nkoo',            $!nko;
    self.Hash::BIND-KEY: 'ol-chiki',        $!ol-chiki;
    self.Hash::BIND-KEY: 'olck',            $!ol-chiki;
    self.Hash::BIND-KEY: 'oriya',           $!oriya;
    self.Hash::BIND-KEY: 'orya',            $!oriya;
    self.Hash::BIND-KEY: 'osmanya',         $!osmanya;
    self.Hash::BIND-KEY: 'osma',            $!osmanya;
    self.Hash::BIND-KEY: 'hanifi-rohingya', $!hanifi-rohingya;
    self.Hash::BIND-KEY: 'rohg', $!hanifi-rohingya;
    self.Hash::BIND-KEY: 'roman', $!roman;
    self.Hash::BIND-KEY: 'roman-lc', $!roman-lc;
    self.Hash::BIND-KEY: 'romanlow', $!roman-lc;
    self.Hash::BIND-KEY: 'saurashtra', $!saurashtra;
    self.Hash::BIND-KEY: 'saur', $!saurashtra;
    self.Hash::BIND-KEY: 'segmented', $!segmented;
    self.Hash::BIND-KEY: 'segment', $!segmented;
    self.Hash::BIND-KEY: 'sharada', $!sharada;
    self.Hash::BIND-KEY: 'shrd', $!sharada;
    self.Hash::BIND-KEY: 'khudawadi', $!khudawadi; # NOTE THIS IS OUT OF ALPHABETIC ORDER because we go by code (sind)
    self.Hash::BIND-KEY: 'sind', $!khudawadi;
    self.Hash::BIND-KEY: 'sinhala', $!sinhala;
    self.Hash::BIND-KEY: 'sinh', $!sinhala;
    self.Hash::BIND-KEY: 'sora-sompeng', $!sora-sompeng;
    self.Hash::BIND-KEY: 'sora', $!sora-sompeng;
    self.Hash::BIND-KEY: 'sundanese', $!sundanese;
    self.Hash::BIND-KEY: 'sund', $!sundanese;
    self.Hash::BIND-KEY: 'takri', $!takri;
    self.Hash::BIND-KEY: 'takr', $!takri;
    self.Hash::BIND-KEY: 'new-tai-lue', $!new-tai-lue;
    self.Hash::BIND-KEY: 'talu', $!new-tai-lue;
    self.Hash::BIND-KEY: 'tamil', $!tamil;
    self.Hash::BIND-KEY: 'taml', $!tamil;
    self.Hash::BIND-KEY: 'tamil-decimal', $!tamil-decimal;
    self.Hash::BIND-KEY: 'tamldec', $!tamil-decimal;
    self.Hash::BIND-KEY: 'telugu', $!telugu;
    self.Hash::BIND-KEY: 'telu', $!telugu;
    self.Hash::BIND-KEY: 'thai', $!thai;
    self.Hash::BIND-KEY: 'tirhuta', $!tirhuta;
    self.Hash::BIND-KEY: 'tirh', $!tirhuta;
    self.Hash::BIND-KEY: 'tibetan', $!tibetan;
    self.Hash::BIND-KEY: 'tibt', $!tibetan;
    self.Hash::BIND-KEY: 'traditional', $!traditional;
    self.Hash::BIND-KEY: 'traditio', $!traditional;
    self.Hash::BIND-KEY: 'vai', $!vai;
    self.Hash::BIND-KEY: 'vaii', $!vai;
    self.Hash::BIND-KEY: 'warang-citi', $!warang-citi;
    self.Hash::BIND-KEY: 'wara', $!warang-citi;
    self.Hash::BIND-KEY: 'wancho', $!wancho;
    self.Hash::BIND-KEY: 'wcho', $!wancho;

    $!adlam           = CLDR-Symbols.new: blob, $offset, self;
    $!ahom            = CLDR-Symbols.new: blob, $offset, self;
    $!arabic          = CLDR-Symbols.new: blob, $offset, self;
    $!arabic-extended = CLDR-Symbols.new: blob, $offset, self;
    $!armenian        = CLDR-Symbols.new: blob, $offset, self;
    $!armenian-lc     = CLDR-Symbols.new: blob, $offset, self;
    $!balinese        = CLDR-Symbols.new: blob, $offset, self;
    $!bengali         = CLDR-Symbols.new: blob, $offset, self;
    $!bhaiksuki       = CLDR-Symbols.new: blob, $offset, self;
    $!brahmi          = CLDR-Symbols.new: blob, $offset, self;
    $!chakma          = CLDR-Symbols.new: blob, $offset, self;
    $!cham            = CLDR-Symbols.new: blob, $offset, self;
    $!cyrillic        = CLDR-Symbols.new: blob, $offset, self;
    $!devanagari      = CLDR-Symbols.new: blob, $offset, self;
    $!dives-akuru     = CLDR-Symbols.new: blob, $offset, self;
    $!ethiopic        = CLDR-Symbols.new: blob, $offset, self;
    $!financial       = CLDR-Symbols.new: blob, $offset, self;
    $!full-width      = CLDR-Symbols.new: blob, $offset, self;
    $!georgian        = CLDR-Symbols.new: blob, $offset, self;
    $!gunjala-gondi   = CLDR-Symbols.new: blob, $offset, self;
    $!masaram-gondi   = CLDR-Symbols.new: blob, $offset, self;
    $!greek           = CLDR-Symbols.new: blob, $offset, self;
    $!greek-lc        = CLDR-Symbols.new: blob, $offset, self;
    $!gujarati        = CLDR-Symbols.new: blob, $offset, self;
    $!gurmukhi        = CLDR-Symbols.new: blob, $offset, self;
    $!han-days        = CLDR-Symbols.new: blob, $offset, self;
    $!han-decimal     = CLDR-Symbols.new: blob, $offset, self;
    $!han-simplified  = CLDR-Symbols.new: blob, $offset, self;
    $!han-simplified-financial = CLDR-Symbols.new: blob, $offset, self;
    $!han-traditional = CLDR-Symbols.new: blob, $offset, self;
    $!han-traditional-financial = CLDR-Symbols.new: blob, $offset, self;
    $!hebrew          = CLDR-Symbols.new: blob, $offset, self;
    $!pahawh-hmong    = CLDR-Symbols.new: blob, $offset, self;
    $!nyiakeng-puachue-hmong = CLDR-Symbols.new: blob, $offset, self;
    $!javanese        = CLDR-Symbols.new: blob, $offset, self;
    $!japanese        = CLDR-Symbols.new: blob, $offset, self;
    $!japanese-financial = CLDR-Symbols.new: blob, $offset, self;
    $!japanese-year   = CLDR-Symbols.new: blob, $offset, self;
    $!kayah-li        = CLDR-Symbols.new: blob, $offset, self;
    $!khmer           = CLDR-Symbols.new: blob, $offset, self;
    $!kannada         = CLDR-Symbols.new: blob, $offset, self;
    $!lanna-hora      = CLDR-Symbols.new: blob, $offset, self;
    $!lanna-tham      = CLDR-Symbols.new: blob, $offset, self;
    $!lao             = CLDR-Symbols.new: blob, $offset, self;
    $!latin           = CLDR-Symbols.new: blob, $offset, self;
    $!lepcha          = CLDR-Symbols.new: blob, $offset, self;
    $!limbu           = CLDR-Symbols.new: blob, $offset, self;
    $!math-bold       = CLDR-Symbols.new: blob, $offset, self;
    $!math-double     = CLDR-Symbols.new: blob, $offset, self;
    $!math-mono       = CLDR-Symbols.new: blob, $offset, self;
    $!math-sans-bold  = CLDR-Symbols.new: blob, $offset, self;
    $!math-sans       = CLDR-Symbols.new: blob, $offset, self;
    $!malayalam       = CLDR-Symbols.new: blob, $offset, self;
    $!modi            = CLDR-Symbols.new: blob, $offset, self;
    $!mongolian       = CLDR-Symbols.new: blob, $offset, self;
    $!mro             = CLDR-Symbols.new: blob, $offset, self;
    $!meetei-mayek    = CLDR-Symbols.new: blob, $offset, self;
    $!myanmar         = CLDR-Symbols.new: blob, $offset, self;
    $!myanmar-shan    = CLDR-Symbols.new: blob, $offset, self;
    $!myanmar-tai-laing = CLDR-Symbols.new: blob, $offset, self;
    $!native          = CLDR-Symbols.new: blob, $offset, self;
    $!newa            = CLDR-Symbols.new: blob, $offset, self;
    $!nko             = CLDR-Symbols.new: blob, $offset, self;
    $!ol-chiki      = CLDR-Symbols.new: blob, $offset, self;
    $!oriya         = CLDR-Symbols.new: blob, $offset, self;
    $!osmanya       = CLDR-Symbols.new: blob, $offset, self;
    $!hanifi-rohingya = CLDR-Symbols.new: blob, $offset, self;
    $!roman         = CLDR-Symbols.new: blob, $offset, self;
    $!roman-lc      = CLDR-Symbols.new: blob, $offset, self;
    $!saurashtra    = CLDR-Symbols.new: blob, $offset, self;
    $!segmented     = CLDR-Symbols.new: blob, $offset, self;
    $!sharada       = CLDR-Symbols.new: blob, $offset, self;
    $!khudawadi     = CLDR-Symbols.new: blob, $offset, self;
    $!sinhala       = CLDR-Symbols.new: blob, $offset, self;
    $!sora-sompeng  = CLDR-Symbols.new: blob, $offset, self;
    $!sundanese     = CLDR-Symbols.new: blob, $offset, self;
    $!takri         = CLDR-Symbols.new: blob, $offset, self;
    $!new-tai-lue   = CLDR-Symbols.new: blob, $offset, self;
    $!tamil         = CLDR-Symbols.new: blob, $offset, self;
    $!tamil-decimal = CLDR-Symbols.new: blob, $offset, self;
    $!telugu        = CLDR-Symbols.new: blob, $offset, self;
    $!thai          = CLDR-Symbols.new: blob, $offset, self;
    $!tirhuta       = CLDR-Symbols.new: blob, $offset, self;
    $!tibetan       = CLDR-Symbols.new: blob, $offset, self;
    $!traditional   = CLDR-Symbols.new: blob, $offset, self;
    $!vai           = CLDR-Symbols.new: blob, $offset, self;
    $!warang-citi   = CLDR-Symbols.new: blob, $offset, self;
    $!wancho        = CLDR-Symbols.new: blob, $offset, self;

    self
}


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
    # We are passed the symbol set directly, so the xml is intentionally passed through
    CLDR-Symbols.parse: (base{$_} //= Hash.new), xml
        with xml<numberSystem>; # ← one will have no type, that's the fallback, which aliases to latn, so we ignore it︎
}
#>>>>> # GENERATOR
