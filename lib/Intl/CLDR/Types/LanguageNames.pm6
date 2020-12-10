use Intl::CLDR::Immutability;

unit class CLDR-LanguageNames is CLDR-ItemNew is CLDR-Unordered;

has $!parent;

#######################################
#  Attributes currently too numerous  #
# to define explicitly, done via hash #
#######################################

############################################
# Attribute values are Str, but they       #
# may have one of two roles mixed in       #
# to represent alternate values available. #
# They are at present mutually exclusive.  #
############################################

role HasVariantForm { has $.variant; method short {self.Str} }
role HasShortForm   { has $.short; method variant {self.Str} }
role NoAlternateForms { method short { self}; method variant { self } }
method new(|c) {
    self.bless!bind-init: |c
}

submethod !bind-init(\blob, uint64 $offset is rw, \parent) {
    use Intl::CLDR::Util::StrDecode;
    $!parent := parent;

    my $count = blob[$offset++] * 256 + blob[$offset++];

    for ^$count {
        my $type = blob[$offset++];
        if $type == 0 {
            self.Hash::BIND-KEY:
                    StrDecode::get(blob, $offset),
                    StrDecode::get(blob, $offset) does NoAlternateForms;
        } elsif $type == 1 {
            self.Hash::BIND-KEY:
                    StrDecode::get(blob, $offset),
                    StrDecode::get(blob, $offset) does HasShortForm(StrDecode::get(blob,$offset))
        } elsif $type == 2 {
            self.Hash::BIND-KEY:
                    StrDecode::get(blob, $offset),
                    StrDecode::get(blob, $offset) does HasVariantForm(StrDecode::get(blob,$offset))
        } else {
            die "Invalid string type found in LanguageNames.pm6"
        }
    }

    self
}

##`<<<<< # GENERATOR: This method should only be uncommented out by the parsing script
method encode(%*languages --> buf8) {
    # a dynamic variable is normally used, in case fallbacks need to refer back
    use Intl::CLDR::Util::StrEncode;

    my $result = buf8.new;

    my $lang-count = %*languages.keys.elems;

    $result.append: $lang-count div 256;
    $result.append: $lang-count mod 256;

    for %*languages.grep({none .key ~~ '→'}) -> ( :key($tag), :value($name)) {
        # tags are guaranteed to not be variants or shorts
        # Check if a short version exists
        if %*languages{$tag ~ '→variant'}:exists {
            # then type 2
            $result.append: 2;
            $result ~= StrEncode::get($tag  // '');
            $result ~= StrEncode::get($name // '');
            $result ~= StrEncode::get(%*languages{$tag ~ '→variant'} // '');
        }elsif %*languages{$tag ~ '→short'}:exists {
            # then type 1
            $result.append: 1;
            $result ~= StrEncode::get($tag  // '');
            $result ~= StrEncode::get($name // '');
            $result ~= StrEncode::get(%*languages{$tag ~ '→short'} // '');
        }else {
            # then type 0
            $result.append: 0;
            $result ~= StrEncode::get($tag  // '');
            $result ~= StrEncode::get($name // '');
        }

    }

    $result
}
method parse(\base, \xml) {
    use Intl::CLDR::Util::XML-Helper;

    base{.<type> ~ (.<alt> ?? ('→' ~ .<alt>) !! '')} = contents $_ for xml.&elems('language');

}
#>>>>> # GENERATOR
