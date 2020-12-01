use Intl::CLDR::Immutability;

use Intl::CLDR::Types::Calendar;

#| A container class holding CLDR's <calendar> elements.
unit class CLDR-Calendars is CLDR-Item;

has               $!parent;               #= The CLDR-Dates that holds this CLDR-Calendars
has CLDR-Calendar $.buddhist;             #= Buddhist calendar data
has CLDR-Calendar $.chinese;              #= Chinese calendar data
has CLDR-Calendar $.coptic;               #= Coptic calendar data
has CLDR-Calendar $.dangi;                #= Dangi calendar data
has CLDR-Calendar $.ethiopic;             #= Ethiopic calendar (284 AD epoch) data
has CLDR-Calendar $.ethiopic-amete-alem;  #= Ethiopic calendar (5493 BC epoch) data
has CLDR-Calendar $.generic;              #= Generic, numbers-only calendar data (this should generally not be used, per CLDR. Included for completeness.)
has CLDR-Calendar $.gregorian;            #= Gregorian (civil) calendar data
has CLDR-Calendar $.hebrew;               #= Hebrew calendar data
has CLDR-Calendar $.indian;               #= Indian calendar data
has CLDR-Calendar $.islamic;              #= Islamic calendar (generic) data
has CLDR-Calendar $.islamic-civil;        #= Islamic calendar (Friday-epoch tabular) data
has CLDR-Calendar $.islamic-rgsa;         #= Tabular Islamic (Thursday-epoch tabular) calendar data
has CLDR-Calendar $.islamic-tbla;         #= Islamic calendar (Saudi Arabia-sighted) data
has CLDR-Calendar $.islamic-umalqura;     #= Islamic calendar (Umm al-Qura) data
has CLDR-Calendar $.japanese;             #= Japanese calendar data
has CLDR-Calendar $.persian;              #= Persian calendar data
has CLDR-Calendar $.roc;                  #= Taiwanese calendar data

#| Creates a new CLDR-Dates object
method new(|c) {
    self.bless!bind-init: |c;
}

submethod !bind-init(\blob, uint64 $offset is rw, \parent) {
    $!parent := parent;

    self.Hash::BIND-KEY: 'buddhist',            $!buddhist;
    self.Hash::BIND-KEY: 'chinese',             $!chinese;
    self.Hash::BIND-KEY: 'coptic',              $!coptic;
    self.Hash::BIND-KEY: 'dangi',               $!dangi;
    self.Hash::BIND-KEY: 'ethiopic',            $!ethiopic;
    self.Hash::BIND-KEY: 'ethiopic-amete-alem', $!ethiopic-amete-alem;
    self.Hash::BIND-KEY: 'generic',             $!generic;
    self.Hash::BIND-KEY: 'gregorian',           $!gregorian;
    self.Hash::BIND-KEY: 'hebrew',              $!hebrew;
    self.Hash::BIND-KEY: 'indian',              $!indian;
    self.Hash::BIND-KEY: 'islamic',             $!islamic;
    self.Hash::BIND-KEY: 'islamic-civil',       $!islamic-civil;
    self.Hash::BIND-KEY: 'islamic-rgsa',        $!islamic-rgsa;
    self.Hash::BIND-KEY: 'islamic-tbla',        $!islamic-tbla;
    self.Hash::BIND-KEY: 'islamic-umalqura',    $!islamic-umalqura;
    self.Hash::BIND-KEY: 'japanese',            $!japanese;
    self.Hash::BIND-KEY: 'persian',             $!persian;
    self.Hash::BIND-KEY: 'roc',                 $!roc;

    # Note the order used in encoding, offset automatically advances
    $!buddhist         = CLDR-Calendar.new: blob, $offset, self;
    $!chinese          = CLDR-Calendar.new: blob, $offset, self;
    $!coptic           = CLDR-Calendar.new: blob, $offset, self;
    $!dangi            = CLDR-Calendar.new: blob, $offset, self;
    $!ethiopic         = CLDR-Calendar.new: blob, $offset, self;
    $!ethiopic-amete-alem = CLDR-Calendar.new: blob, $offset, self;
    $!gregorian        = CLDR-Calendar.new: blob, $offset, self;
    $!hebrew           = CLDR-Calendar.new: blob, $offset, self;
    $!indian           = CLDR-Calendar.new: blob, $offset, self;
    $!islamic          = CLDR-Calendar.new: blob, $offset, self;
    $!islamic-civil    = CLDR-Calendar.new: blob, $offset, self;
    $!islamic-rgsa     = CLDR-Calendar.new: blob, $offset, self;
    $!islamic-tbla     = CLDR-Calendar.new: blob, $offset, self;
    $!islamic-umalqura = CLDR-Calendar.new: blob, $offset, self;
    $!japanese         = CLDR-Calendar.new: blob, $offset, self;
    $!persian          = CLDR-Calendar.new: blob, $offset, self;
    $!roc              = CLDR-Calendar.new: blob, $offset, self;

    self
}

##`<<<<< # GENERATOR: This method should only be uncommented out by the parsing script
method encode(%*calendars) {

    # All calendars (including 'generic' must be present)
    my @expected = <buddhist chinese coptic dangi ethiopic ethiopic-amete-alem generic
                     gregorian hebrew indian islamic islamic-civil islamic-rgsa
                     islamic-tbla islamic-umalqura japanese persian roc>;

    die "Calendar mismatch (are you missing one or was a new one added?)\n"
      ~ "Expected: {@expected.sort}\n"
      ~ "Got:      {%*calendars.keys.sort}"
        if @expected ⊖ %*calendars.keys;

    my $result = buf8.new;

    # The 'generic' calendar is only used for fallback generation, so is not included here.
    for <buddhist chinese coptic dangi ethiopic ethiopic-amete-alem gregorian hebrew indian
         islamic islamic-civil islamic-rgsa islamic-tbla islamic-umalqura japanese
         persian roc> -> $*calendar-type {

        $result ~= CLDR-Calendar.encode: %*calendars{$*calendar-type}

    }

    $result
}
method parse(\base, \xml) {
    use Intl::CLDR::Util::XML-Helper;
    CLDR-Calendar.parse: (base{.<type>} //= Hash.new ), $_ for xml.&elems('calendar')
}


#>>>>> # GENERATOR
