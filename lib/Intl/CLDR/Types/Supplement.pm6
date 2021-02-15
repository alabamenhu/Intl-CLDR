use Intl::CLDR::Immutability;

unit class CLDR-Supplement is CLDR-ItemNew ;

#has CLDR-Subdivisions $.subdivisions;

#| Creates a new CLDR-Supplement object
method new(|c --> CLDR-Supplement) {
    self.bless!bind-init: |c;
}

submethod !bind-init(\blob, uint64 $offset is rw --> CLDR-Supplement) {
    use Intl::CLDR::Util::StrDecode;

    #$!subdivisions = CLDR-Subdivisions.new: blob, $offset;
    # StrDecode::get(blob, $offset);

    #@!display-names[$_]      = StrDecode::get(blob, $offset) for ^3;

    self;
}

##`<<<<< # GENERATOR: This method should only be uncommented out by the parsing script
method encode(%supplement --> buf8) {
    use Intl::CLDR::Util::StrEncode;
    my $result = buf8.new;

    #$result ~= CLDR-Subdivisions.encode: %supplement<subdivisions>;

    # not called, handled at a higher level
}
method parse(\base, \xml --> Nil) {
    #base<supplemental> = CLDR-Subdivions
    # not called, handled at a higher level
}
#>>>>> # GENERATOR
