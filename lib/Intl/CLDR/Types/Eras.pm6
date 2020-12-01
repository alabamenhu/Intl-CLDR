use Intl::CLDR::Immutability;

unit class CLDR-Eras is CLDR-Item;

use Intl::CLDR::Types::EraWidth;

has               $!parent;
has CLDR-EraWidth $.narrow;
has CLDR-EraWidth $.abbreviated;
has CLDR-EraWidth $.wide;

#| Creates a new CLDR-EraContext object
method new(|c) {
    self.bless!bind-init: |c;
}

submethod !bind-init(\blob, uint64 $offset is rw, \parent) {
    $!parent := parent;

    self.Hash::BIND-KEY: 'narrow',      $!narrow;
    self.Hash::BIND-KEY: 'abbreviated', $!abbreviated;
    self.Hash::BIND-KEY: 'wide',        $!wide;

    $!narrow      = CLDR-EraWidth.new: blob, $offset, self;
    $!abbreviated = CLDR-EraWidth.new: blob, $offset, self;
    $!wide        = CLDR-EraWidth.new: blob, $offset, self;

    self
}

##`<<<<< # GENERATOR: This method should only be uncommented out by the parsing script
method encode(%*eras) {
    my $result = buf8.new;
    my $*era-width;
    $*era-width = 'narrow';
    $result ~= CLDR-EraWidth.encode: %*eras<narrow>      // Hash;
    $*era-width = 'abbreviated';
    $result ~= CLDR-EraWidth.encode: %*eras<abbreviated> // Hash;
    $*era-width = 'format';
    $result ~= CLDR-EraWidth.encode: %*eras<format>      // Hash;

    $result
}
method parse(\base, \xml) {
    use Intl::CLDR::Util::XML-Helper;
    CLDR-EraWidth.parse: (base<eraNames>  //= Hash.new), $_ with xml.&elem('eraNames');
    CLDR-EraWidth.parse: (base<eraAbbr>   //= Hash.new), $_ with xml.&elem('eraAbbr');
    CLDR-EraWidth.parse: (base<eraNarrow> //= Hash.new), $_ with xml.&elem('eraNarrow');
}
#>>>>> # GENERATOR
