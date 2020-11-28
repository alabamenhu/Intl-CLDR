use Intl::CLDR::Immutability;

use Intl::CLDR::Types::IntervalFormat;

unit class CLDR-IntervalFormats is CLDR-Item;

has $!parent; #= The CLDR-DateTimeFormats that contains this CLDR-IntervalFormats

# TODO: provide matching method here?  or just rely on other modules and hash .keys value?

#| Creates a new CLDR-IntervalFormats object
method new(|c) {
    self.bless!bind-init: |c;
}

submethod !bind-init(\blob, uint64 $offset is rw, \parent) {
    $!parent := parent;

    use Intl::CLDR::Classes::StrDecode;

    loop {
        my \code = blob[$offset++];
        last if code == 0;
        self.Hash::BIND-KEY:
                StrDecode::get(blob, $offset),
                CLDR-IntervalFormat.new(blob, $offset)
    }

    self
}

##`<<<<< # GENERATOR: This method should only be uncommented out by the parsing script
method encode(\hash) {
    use Intl::CLDR::Classes::StrEncode;

    my buf8 $result = [~] do for hash.kv -> \key, \value {
        StrEncode::get(key) ~ CLDR-IntervalFormat.encode(value)
    } || buf8.new;

    $result.append: 0
}
#>>>>> # GENERATOR
