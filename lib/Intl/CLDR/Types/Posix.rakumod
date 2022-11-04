unit class CLDR::Posix;
    use Intl::CLDR::Core;
    also does CLDR::Item;

use Intl::CLDR::Types::Messages;

has CLDR::Messages $.messages;

#| Creates a new CLDR-DayPeriodContext object
method new(\blob, uint64 $offset is rw --> ::?CLASS) {
    self.bless:
        messages => CLDR::Messages.new(blob, $offset);
}


#`<<<<<# GENERATOR: Use toggle-generators.raku to [dis|en]able this code.
method encode(%*posix) {
    my $result = buf8.new;

    $result ~= CLDR::Messages.encode(%*posix<messages> // Hash);

    $result
}
method parse(\base, \xml) {
    use Intl::CLDR::Util::XML-Helper;
    CLDR::Messages.parse: (base<messages> //= Hash.new), $_ with xml.&elem('messages');
}
>>>>># GENERATOR