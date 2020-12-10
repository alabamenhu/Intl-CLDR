use Intl::CLDR::Immutability;

unit class CLDR-Posix is CLDR-ItemNew;

use Intl::CLDR::Types::Messages;

has $!parent;
has CLDR-Messages $.messages;

#| Creates a new CLDR-DayPeriodContext object
method new(|c) {
    self.bless!bind-init: |c;
}

submethod !bind-init(\blob, uint64 $offset is rw) {
    $!messages = CLDR-Messages.new: blob, $offset;
    self
}


##`<<<<< # GENERATOR: This method should only be uncommented out by the parsing script
method encode(%*posix) {
    my $result = buf8.new;

    $result ~= CLDR-Messages.encode(%*posix<messages> // Hash);

    $result
}
method parse(\base, \xml) {
    use Intl::CLDR::Util::XML-Helper;
    CLDR-Messages.parse: (base<messages> //= Hash.new), $_ with xml.&elem('messages');
}
#>>>>> # GENERATOR
