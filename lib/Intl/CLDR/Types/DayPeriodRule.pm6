use Intl::CLDR::Immutability;


unit class CLDR-DayPeriodRule is CLDR-ItemNew;

has int  $.at;     #= The special name of 12:00 noon
has int  $.from;   #= The special name of 0:00/24:00 midnight
has int  $.before; #= The name for an (early) morning period
has Bool $.used;   #= The name for an (early) morning period

#| Creates a new CLDR-Dates object
method new(|c) {
    self.bless!bind-init: |c;
}

submethod !bind-init(\blob, uint64 $offset is rw) {
    my $start-hour = blob[$offset++];

    if $start-hour != 25 {
        my $start-minute = blob[$offset++];
        my $end-hour     = blob[$offset++];
        my $end-minute   = blob[$offset++];

        if $start-hour   == $end-hour
        && $start-minute == $end-minute {
            $!at     = $start-hour * 60 + $start-minute;
            $!from   = -1;
            $!before = -1;
        } else {
            $!at     = -1;
            $!from   = $start-hour * 60 + $start-minute;
            $!before = $end-hour   * 60 + $end-minute;
        }
        $!used = True;
    }else{
        $!used   = False;
        $!at     = -1;
        $!from   = -1;
        $!before = -1;
    }

    self
}

##`<<<<< # GENERATOR: This method should only be uncommented out by the parsing script
method encode(\hash) {
    my $result = buf8.new;

    if hash {
        my $start = hash<from>   // hash<at>;
        my $end   = hash<before> // hash<at>;

        $result.append: $start.substr(0,2).Int;
        $result.append: $start.substr(3,2).Int;
        $result.append: $end.substr(  0,2).Int;
        $result.append: $end.substr(  3,2).Int;
    } else {
        $result.append: 25;
    }

    $result;
}
method parse(\base, \xml) {
    # handled at higher level
}
#>>>>> # GENERATOR
