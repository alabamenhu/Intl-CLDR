unit class CLDR::DayPeriodRule;
    use Intl::CLDR::Core;
    also does CLDR::Item;

has int  $.at;     #= The exact time that the day period rule applies too (e.g. noon)
has int  $.from;   #= The time of day that the day period rule begins (inclusive)
has int  $.before; #= The time of day that the day period rule ends (exclusive)
has Bool $.used;   #= If false, this day period rule is not used for the given locale

#| Creates a new CLDR::DayPeriodRule object
method new(|c) {
    self.bless!set-time: |c;
}

submethod !set-time(\blob, uint64 $offset is rw) {
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

#`<<<<<# GENERATOR: Use toggle-generators.raku to [dis|en]able this code.
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
>>>>># GENERATOR