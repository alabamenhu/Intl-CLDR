use Intl::CLDR::Immutability;

unit class CLDR-TimeFormats is CLDR-Item;

use Intl::CLDR::Types::TimeFormat;

has $!parent;
has CLDR-TimeFormat $.full;
has CLDR-TimeFormat $.long;
has CLDR-TimeFormat $.medium;
has CLDR-TimeFormat $.short;

#| Creates a new CLDR-Times object
method new(|c) {
    self.bless!bind-init: |c;
}

submethod !bind-init(\blob, uint64 $offset is rw, \parent) {
    $!parent := parent;

    self.Hash::BIND-KEY: 'full',   $!full;
    self.Hash::BIND-KEY: 'long',   $!long;
    self.Hash::BIND-KEY: 'medium', $!medium;
    self.Hash::BIND-KEY: 'short',  $!short;

    $!full   = CLDR-TimeFormat.new: blob, $offset, self;
    $!long   = CLDR-TimeFormat.new: blob, $offset, self;
    $!medium = CLDR-TimeFormat.new: blob, $offset, self;
    $!short  = CLDR-TimeFormat.new: blob, $offset, self;

    self
}

##`<<<<<#GENERATOR: This method should only be uncommented out by the parsing script
method encode(%time-formats) {
    my $result = buf8.new;

    my $*time-format-width;

    $*time-format-width = 'full';
    $result ~= CLDR-TimeFormat.encode: %time-formats<full>;
    $*time-format-width = 'long';
    $result ~= CLDR-TimeFormat.encode: %time-formats<long>;
    $*time-format-width = 'medium';
    $result ~= CLDR-TimeFormat.encode: %time-formats<medium>;
    $*time-format-width = 'short';
    $result ~= CLDR-TimeFormat.encode: %time-formats<short>;

    $result;
}
#>>>>>#GENERATOR
