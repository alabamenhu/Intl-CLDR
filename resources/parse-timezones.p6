use XML;

my $file = open "Metazones.data", :w;

my $xml = open-xml("supplemental/metaZones.xml");

my @timezones = $xml.getElementsByTagName('metaZones'   ).head.
                     getElementsByTagName('metazoneInfo').head.
                     getElementsByTagName('timezone');

sub gmt(Str \stamp) {
    # 1983-10-30 12:00
    my ($year, $month, $day, $hour, $minute) = stamp.comb(/\d+/);
    return DateTime.new(:$year, :$month, :$day, :$hour, :$minute).posix;
}
constant min = -9223372036854775808;
constant max =  9223372036854775807;
for @timezones -> $timezone {
    my $olson = $timezone<type>;
    say $olson;
    $file.print: $olson;
    for $timezone.getElementsByTagName('usesMetazone') -> $metazone {
        my $start   = $metazone<from> // "*"; # These are in GMT time, max = 9223372036854775807
        my $end     = $metazone<to>   // "*"; # These are in GMT time, min = -9223372036854775808
        my $link-to = $metazone<mzone>;

        $file.print:
                ~ ","
                ~ $link-to
                ~ ","
                ~ ($start eq '*' ?? min !! gmt($start))
                ~ ","
                ~ ($end eq '*' ?? max !! gmt($end));
    }
    $file.print: "\n";
}

$file.close;

