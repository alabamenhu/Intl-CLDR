use Test;

use Intl::CLDR;

my $time = now;
#for <en es el jp de fr ar ie pt it> {
#    cldr-data-for-lang $_
#}
#say now - $time;
say (cldr-data-for-lang 'en').dates.timezone-names;
#say (cldr-data-for-lang 'es').calendars.gregorian.dayPeriods.stand-alone.wide.morning1;
say (cldr-data-for-lang 'en').dates.timezone-names.hour-format;
say (cldr-data-for-lang 'en').dates.timezone-names.gmt-format;
say (cldr-data-for-lang 'en').dates.timezone-names.metazones;
#say (cldr-data-for-lang 'en').calendars.gregorian.months.format.wide[1];
#say (cldr-data-for-lang 'de').calendars.gregorian.months.format.wide[1];
#say (cldr-data-for-lang 'fr').calendars.gregorian.months.format.wide[1];
#say (cldr-data-for-lang 'el').calendars.gregorian.months.format.wide[1];

# This data and associated method definitely belong somewhere else
# But since the formatter is the only one that's using it at the moment... I'm lazy

#`<<<
my %tz-meta := BEGIN do {
    my %tz-meta;
    for "resources/Metazones.data".IO.slurp.lines {
        constant DELIMITER = ',';
        my @elements = .split(DELIMITER);
        my $tz = @elements.shift;
        my @forms;
        while @elements {
            @forms.push(List.new(.shift, .shift, .shift)) with @elements;
        }
        %tz-meta{$tz} := @forms;
    }
    %tz-meta
}

sub get-meta-timezone(Str $olson, DateTime $dt = DateTime.new(now)) {
    with %tz-meta{$olson} -> @meta-list {
        my $posix = $dt.posix;
        for @meta-list -> ($name, $start, $end) {
            return $name if $start ≤ $posix < $end;
        }
    }
    $olson # Default to kicking it back.  Or should we throw?
}

say get-meta-timezone("America/Chicago");
>>>
done-testing;