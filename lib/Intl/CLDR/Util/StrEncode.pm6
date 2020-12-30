####### WARNING #######
# Not thread-safe atm #
#######################
unit module StrEncode;

my @strings;
constant DELIMITER = 31.chr;

#| Resets the string encoding collection
our sub reset  {
    # The first string is always CLDRStrs, which at 8bytes is a perfect header.
    @strings = 'CLDRStrs'
}

# Generate the string to be interpreted by StrDecode::prepare()
our sub output (\delimiter = DELIMITER --> Str) {
    @strings.join: delimiter
}

#| Generate a two-byte code that StrDecode::get() can use to recover the string
our sub get(Str() $string --> buf8) {
    my $index;

    # Horribly inefficient, but not time-critical
    with @strings.first($string, :k) {
        $index = $_;
    } else{
        @strings.push: $string;
        $index = @strings - 1;
    }

    # If this happens, also update StrDecode
    die "StrEncoder.pm6 only allows up to 65536 unique strings without special support\n"
        unless $index < 65536;

    # Most systems these days are SmallEndian, so default to that
    buf8.new:
        $index mod 256,
        $index div 256
}

