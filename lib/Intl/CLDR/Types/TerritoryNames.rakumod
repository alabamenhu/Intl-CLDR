unit class CLDR::TerritoryNames;
    use Intl::CLDR::Core;
    also does CLDR::Item;
    also is   CLDR::Unordered;

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
method new(|c --> ::?CLASS ) {
    self.bless!add-items: |c
}

submethod !add-items(\blob, uint64 $offset is rw --> ::?CLASS) {
    use Intl::CLDR::Util::StrDecode;

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
            die "Invalid type name found"
        }
    }

    self
}

#`<<<<<# GENERATOR: Use toggle-generators.raku to [dis|en]able this code.
method encode(%*territories --> buf8) {
    # a dynamic variable is normally used, in case fallbacks need to refer back
    use Intl::CLDR::Util::StrEncode;

    my $result = buf8.new;

    #my $lang-count = %*territories.grep({none .key ~~ /'→'/}).elems;
    my $lang-count = 0;
    $result.append: 0, 0; # used for the count later
    #;$lang-count div 256;
    #$result.append: $lang-count mod 256;

    for %*territories.grep({none .key ~~ /'→'/}) -> ( :key($tag), :value($name)) {
        # tags are guaranteed to not be variants or shorts
        # Check if a short version exists
        $lang-count++;
        if %*territories{$tag ~ '→variant'}:exists {
            # then type 2
            $result.append: 2;
            $result ~= StrEncode::get($tag  // '');
            $result ~= StrEncode::get($name // '');
            $result ~= StrEncode::get(%*territories{$tag ~ '→variant'} // '');
        }elsif %*territories{$tag ~ '→short'}:exists {
            # then type 1
            $result.append: 1;
            $result ~= StrEncode::get($tag  // '');
            $result ~= StrEncode::get($name // '');
            $result ~= StrEncode::get(%*territories{$tag ~ '→short'} // '');
        }else {
            # then type 0
            $result.append: 0;
            $result ~= StrEncode::get($tag  // '');
            $result ~= StrEncode::get($name // '');
        }

    }
    $result[0] = $lang-count div 256;
    $result[1] = $lang-count mod 256;
    $result
}
method parse(\base, \xml) {
    use Intl::CLDR::Util::XML-Helper;
    base{.<type> ~ (.<alt> ?? ('→' ~ .<alt>) !! '')} = contents $_ for xml.&elems('territory');
}
>>>>># GENERATOR