use Intl::CLDR::Immutability;

unit class CLDR-VariantNames is CLDR-Item;

has $!parent;

#######################################
#  Attributes currently too numerous  #
# to define explicitly, done via hash #
#######################################

############################################
# At the moment I am not aware of any alt  #
# forms being available, but if they are,  #
# follow the model of LanguageNames        #
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
        self.Hash::BIND-KEY:
                StrDecode::get(blob, $offset),
                StrDecode::get(blob, $offset);
    }

    self
}

##`<<<<< # GENERATOR: This method should only be uncommented out by the parsing script
method encode(%*variants --> buf8) {
    # a dynamic variable is normally used, in case fallbacks need to refer back
    use Intl::CLDR::Util::StrEncode;

    my $result = buf8.new;

    my $variant-count = %*variants.keys.elems;
    
    if %*variants.grep({.key ~~ '→'}) {
        die "Found a variant with an alt tag. Adjust VariantNames accordingly";
    }

    $result.append: $variant-count div 256;
    $result.append: $variant-count mod 256;

    for %*variants.kv -> $tag, $name {
        # tags are guaranteed to not be variants or shorts
        # Check if a short version exists
        $result ~= StrEncode::get($tag  // '');
        $result ~= StrEncode::get($name // '');

    }

    $result
}
method parse(\base, \xml) {
    use Intl::CLDR::Util::XML-Helper;
    base{.<type> ~ (.<alt> ?? ('→' ~ .<alt>) !! '')} = contents $_ for xml.&elems('variants');
}
#>>>>> # GENERATOR
