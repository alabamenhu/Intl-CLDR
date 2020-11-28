use Intl::CLDR::Immutability;

unit class CLDR-Quarters is CLDR-Item;

use Intl::CLDR::Types::QuarterContext;

has $!parent;
has CLDR-QuarterContext $.stand-alone;
has CLDR-QuarterContext $.format;

#| Creates a new CLDR-Dates object
method new(|c) {
    self.bless!bind-init: |c;
}

submethod !bind-init(\blob, uint64 $offset is rw, \parent) {
    $!parent := parent;

    self.Hash::BIND-KEY: 'stand-alone', $!stand-alone;
    self.Hash::BIND-KEY: 'standAlone',  $!stand-alone;
    self.Hash::BIND-KEY: 'format',      $!format;

    $!stand-alone = CLDR-QuarterContext.new: blob, $offset, self;
    $!format      = CLDR-QuarterContext.new: blob, $offset, self;

    self
}

##`<<<<< # GENERATOR: This method should only be uncommented out by the parsing script
method encode(%*quarters) {
    my $*quarter-context;
    my $result = buf8.new;

    $*quarter-context = 'stand-alone';
    $result ~= CLDR-QuarterContext.encode: (%*quarters<stand-alone> // Hash);
    $*quarter-context = 'format';
    $result ~= CLDR-QuarterContext.encode: (%*quarters<format>      // Hash);

    $result;
}
#>>>>> # GENERATOR
