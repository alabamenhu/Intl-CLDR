use Intl::CLDR::Immutability;

unit class CLDR-DayContext is CLDR-Item;

use Intl::CLDR::Types::DayWidth;

has               $!parent;
has CLDR-DayWidth $.narrow;
has CLDR-DayWidth $.abbreviated;
has CLDR-DayWidth $.wide;

#| Creates a new CLDR-DayContext object
method new(|c) {
    self.bless!bind-init: |c;
}

submethod !bind-init(\blob, uint64 $offset is rw, \parent) {
    $!parent := parent;

    self.Hash::BIND-KEY: 'narrow',      $!narrow;
    self.Hash::BIND-KEY: 'abbreviated', $!abbreviated;
    self.Hash::BIND-KEY: 'wide',        $!wide;

    $!narrow      = CLDR-DayWidth.new: blob, $offset, self;
    $!abbreviated = CLDR-DayWidth.new: blob, $offset, self;
    $!wide        = CLDR-DayWidth.new: blob, $offset, self;

    self
}

##`<<<<< # GENERATOR: This method should only be uncommented out by the parsing script
method encode(\hash) {
    my $*day-width;
    my $result = buf8.new;

    $*day-width = 'narrow';
    $result ~= CLDR-DayWidth.encode: %*day-context<narrow> // Hash;
    $*day-width = 'abbreviated';
    $result ~= CLDR-DayWidth.encode: %*day-context<abbreviated> // Hash;
    $*day-width = 'wide';
    $result ~= CLDR-DayWidth.encode: %*day-context<wide> // Hash;

    $result;
}
method parse(\base, \xml) {
    use Intl::CLDR::Util::XML-Helper;
    CLDR-DayWidth.parse: (base{.<type>} //= Hash.new), $_ for xml.&elems('dayWidth');
}
#>>>>> # GENERATOR
