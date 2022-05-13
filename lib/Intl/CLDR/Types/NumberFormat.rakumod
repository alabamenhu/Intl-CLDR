use Intl::CLDR::Immutability;

unit class CLDR-NumberFormat is CLDR-ItemNew;
has Str    $.pattern;
has uint64 $.type;

#| Creates a new CLDR-NumberFormat object
method new(|c --> CLDR-NumberFormat) {
    self.bless!bind-init: |c;
}

submethod !bind-init(\blob, uint64 $offset is rw --> CLDR-NumberFormat) {
    use Intl::CLDR::Util::StrDecode;

    $!pattern = StrDecode::get(blob, $offset);
    $!type    = my uint64 $ = blob.read-uint64($offset, LittleEndian);
    $offset  += 8;

    self
}

##`<<<<< # GENERATOR: This method should only be uncommented out by the parsing script
method encode($pattern --> buf8) {
    use Intl::CLDR::Util::StrEncode;
    die "Need to increase max pattern size in NumberFormat.pm6" if $*pattern-type > 2 ** 64;

    with buf8.new {
        .reallocate(8);
        .subbuf-rw(0, 0) = StrEncode::get($pattern // ''); # <-- fallback should never happen
        .write-uint64(2, +$*pattern-type, LittleEndian);   # <-- this feels horribly inefficient for storage.
        .return                                            #     TODO change to power-of-ten iff can confirm
    }                                                      #     all types for all languages are a power-of-ten
}
method parse(\base, \xml --> Nil) {
    # not called, handled at a higher level
}
#>>>>> # GENERATOR
