use Intl::CLDR::Immutability;

use Intl::CLDR::Types::Calendar;

#| A container class holding CLDR's <calendar> elements.
unit class CLDR-Calendars is CLDR-ItemNew;

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

submethod !bind-init(\blob, uint64 $offset is rw) {

    # Note the order used in encoding, offset automatically advances
    $!buddhist         = CLDR-Calendar.new: blob, $offset;
    $!chinese          = CLDR-Calendar.new: blob, $offset;
    $!coptic           = CLDR-Calendar.new: blob, $offset;
    $!dangi            = CLDR-Calendar.new: blob, $offset;
    $!ethiopic         = CLDR-Calendar.new: blob, $offset;
    $!ethiopic-amete-alem = CLDR-Calendar.new: blob, $offset;
    $!gregorian        = CLDR-Calendar.new: blob, $offset;
    $!hebrew           = CLDR-Calendar.new: blob, $offset;
    $!indian           = CLDR-Calendar.new: blob, $offset;
    $!islamic          = CLDR-Calendar.new: blob, $offset;
    $!islamic-civil    = CLDR-Calendar.new: blob, $offset;
    $!islamic-rgsa     = CLDR-Calendar.new: blob, $offset;
    $!islamic-tbla     = CLDR-Calendar.new: blob, $offset;
    $!islamic-umalqura = CLDR-Calendar.new: blob, $offset;
    $!japanese         = CLDR-Calendar.new: blob, $offset;
    $!persian          = CLDR-Calendar.new: blob, $offset;
    $!roc              = CLDR-Calendar.new: blob, $offset;

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
