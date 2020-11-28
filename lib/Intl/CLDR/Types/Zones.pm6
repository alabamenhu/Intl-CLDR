use Intl::CLDR::Immutability;
use Intl::CLDR::Types::Zone;

unit class CLDR-Zones is CLDR-Item;

has $!parent; #= The CLDR-TimezoneNames that contains this CLDR-Zones

#! Because names are not stable, no other attributes:
#!   hashy access is required)

#| Creates a new CLDR-Zones object
method new(|c) {
    self.bless!bind-init: |c;
}

submethod !bind-init(\blob, uint64 $offset is rw, \parent) {
    $!parent := parent;

    use Intl::CLDR::Classes::StrDecode;

    # There is not a set number, so the format is an alternation of
    # of Str, Zone, Str, Zone, and 0 terminates it.
    loop {
        my \code = blob[$offset++];
        last if code == 0;
        self.Hash::BIND-KEY:
                StrDecode::get(blob, $offset),
                CLDR-Zone.new( blob, $offset)
    }

    self
}

##`<<<<< # GENERATOR: This method should only be uncommented out by the parsing script
method encode(\hash) {
    use Intl::CLDR::Classes::StrEncode;
    use Intl::CLDR::Types::Zone;

    my buf8 $result = [~] do for hash.kv -> \tzname, \value {
        StrEncode::get(tzname) ~ CLDR-Zone.encode(value)
    } || buf8.new;

    $result.append: 0
}
#>>>>> # GENERATOR
