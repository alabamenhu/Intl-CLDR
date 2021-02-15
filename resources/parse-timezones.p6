=begin pod
This file is a temporary stop-gap until CLDR's metazone information
is handled either in CLDR itself or in DateTime::Timezones.

This script assumes that the metaZones.xml file from CLDR is in the same directory.
=end pod

use XML;
use DateTime::Timezones;

my IO::Handle $file = open "Metazones.data", :w;

my $xml = open-xml("metaZones.xml");

my @timezones = $xml.getElementsByTagName('metaZones'   ).head.
                     getElementsByTagName('metazoneInfo').head.
                     getElementsByTagName('timezone');

sub gmt(Str \stamp, $timezone) {
    # 1983-10-30 12:00
    my ($year, $month, $day, $hour, $minute) = stamp.comb(/\d+/);
    return DateTime.new(:$year, :$month, :$day, :$hour, :$minute, :$timezone).posix;
}
constant min = -9223372036854775808; # int64 min
constant max =  9223372036854775807; # int64 max
for @timezones -> $timezone {
    my $olson = $timezone<type>;
    say "Processing $olson";;
    $file.print: $olson;
    for $timezone.getElementsByTagName('usesMetazone') -> $metazone {
        my $start   = $metazone<from> // "*"; # These are in GMT time, max = 9223372036854775807
        my $end     = $metazone<to>   // "*"; # These are in GMT time, min = -9223372036854775808
        my $link-to = $metazone<mzone>;

        try {
            CATCH { .say }
            $file.print:
                     ","
                            ~ $link-to
                            ~ ","
                            ~ ($start eq '*' ?? min !! gmt($start, $olson))
                            ~ ","
                    ~ ($end eq '*' ?? max !! gmt($end, $olson));
        }
    }
    $file.print: "\n";
}

$file.close;

