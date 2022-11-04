unit class CLDR::VariantNames;
    use Intl::CLDR::Core;
    also does CLDR::Item;
    also is   CLDR::Unordered;

#######################################
#  Attributes currently too numerous  #
# to define explicitly, done via hash #
#######################################

############################################
# At the moment I am not aware of any alt  #
# forms being available, but if they are,  #
# follow the model of LanguageNames        #
############################################

role HasVariantForm   { has $.variant; method short {self.Str} }
role HasShortForm     { has $.short; method variant {self.Str} }
role NoAlternateForms { method short { self }; method variant { self } }

method new(|c --> ::?CLASS) {
    self.bless!add-items: |c
}

submethod !add-items(\blob, uint64 $offset is rw --> ::?CLASS) {
    use Intl::CLDR::Util::StrDecode;

    my $count = blob[$offset++] * 256 + blob[$offset++];

    self.Hash::BIND-KEY:
            StrDecode::get(blob, $offset),
            StrDecode::get(blob, $offset)
    for ^$count;

    self
}

#`<<<<<# GENERATOR: Use toggle-generators.raku to [dis|en]able this code.
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
>>>>># GENERATOR