use Intl::CLDR::Immutability;

unit class CLDR-CyclicNameSet is CLDR-Item;

use Intl::CLDR::Types::CyclicNameContext;

has $!parent;
has CLDR-CyclicNameContext $.stand-alone;
has CLDR-CyclicNameContext $.format;

#| Creates a new CLDR-Dates object
method new(|c) {
    self.bless!bind-init: |c;
}

submethod !bind-init(\blob, uint64 $offset is rw, \parent) {
    $!parent := parent;

    self.Hash::BIND-KEY: 'stand-alone', $!stand-alone;
    self.Hash::BIND-KEY: 'standAlone',  $!stand-alone;
    self.Hash::BIND-KEY: 'format',      $!format;

    $!stand-alone = CLDR-CyclicNameContext.new: blob, $offset, self;
    $!format      = CLDR-CyclicNameContext.new: blob, $offset, self;

    self
}

##`<<<<< # GENERATOR: This method should only be uncommented out by the parsing script
method encode(%*cyclic-name-context) {
    my $result = buf8.new;

    my $*cyclic-name-context;

    $*cyclic-name-context = 'stand-alone';
    $result ~= CLDR-CyclicNameContext.encode: %*cyclic-name-context<stand-alone> // Hash;
    $*cyclic-name-context = 'format';
    $result ~= CLDR-CyclicNameContext.encode: %*cyclic-name-context<sformat> // Hash;

    $result
}
#>>>>> # GENERATOR
