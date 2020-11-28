use Intl::CLDR::Immutability;

unit class CLDR-CyclicNameContext is CLDR-Item;

use Intl::CLDR::Types::CyclicNameWidth;

has                      $!parent;
has CLDR-CyclicNameWidth $.narrow;
has CLDR-CyclicNameWidth $.abbreviated;
has CLDR-CyclicNameWidth $.wide;

#| Creates a new CLDR-CyclicNameContext object
method new(|c) {
    self.bless!bind-init: |c;
}

submethod !bind-init(\blob, uint64 $offset is rw, \parent) {
    $!parent := parent;

    self.Hash::BIND-KEY: 'narrow',      $!narrow;
    self.Hash::BIND-KEY: 'abbreviated', $!abbreviated;
    self.Hash::BIND-KEY: 'wide',        $!wide;

    $!narrow      = CLDR-CyclicNameWidth.new: blob, $offset, self;
    $!abbreviated = CLDR-CyclicNameWidth.new: blob, $offset, self;
    $!wide        = CLDR-CyclicNameWidth.new: blob, $offset, self;

    self
}

##`<<<<< # GENERATOR: This method should only be uncommented out by the parsing script
method encode(%*cyclic-name-width) {
    my $result = buf8.new;

    my $*cyclic-name-width;

    $*cyclic-name-width = 'narrow';
    $result ~= CLDR-CyclicNameWidth.encode: %*cyclic-name-width<narrow> // Hash;
    $*cyclic-name-width = 'abbreviated';
    $result ~= CLDR-CyclicNameWidth.encode: %*cyclic-name-width<abbreviated> // Hash;
    $*cyclic-name-width = 'format';
    $result ~= CLDR-CyclicNameWidth.encode: %*cyclic-name-width<format> // Hash;

    $result
}
#>>>>> # GENERATOR
