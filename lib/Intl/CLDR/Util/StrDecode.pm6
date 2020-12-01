####### WARNING #######
# Not thread-safe atm #
#######################

unit module StrDecode;

my str @strings;

our sub prepare(Str \input, Str \delimiter = 31.chr) {
    @strings = input.split(delimiter).List;
}

our sub get(\blob, uint64 $offset is rw) {
    my \value = blob.read-uint16($offset);
    $offset += 2;
    return @strings[value];
}