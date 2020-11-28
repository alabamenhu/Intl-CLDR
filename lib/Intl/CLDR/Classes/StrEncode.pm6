unit module StrEncode;
my @strings;

my $delimiter = 31.chr;

our sub reset  { @strings = 'CLDRStrs' } # makes for a nice header, and avoids problems with a 0 value
our sub output { @strings.join: $delimiter }

our sub list { @strings }

our sub get(Str() $string --> buf8) {
    my $index;

    with @strings.first($string, :k) {
        $index = $_;
    } else{
        @strings.push: $string;
        $index = @strings - 1;
    }

    # All import routines will need to adjust their reading too which will be a lot of work.
    die "String encoder only allows up to 65536 unique strings without special support\n"
        unless $index < 65536;

    buf8.new:
        $index mod 256,
        $index div 256
}

