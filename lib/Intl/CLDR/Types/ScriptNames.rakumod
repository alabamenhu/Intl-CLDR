unit class CLDR::ScriptNames;
    use Intl::CLDR::Core;
    also does CLDR::Item;
    also is   CLDR::Unordered;

#######################################
#  Attributes currently too numerous  #
# to define explicitly, done via hash #
#######################################

############################################
# Attribute values are Str, but they       #
# may have a roles mixed in to represent   #
# alternate values available. Only         #
# stand-alone is currently used in scripts #
############################################

role HasStandAloneForm { has    $.stand-alone          }
role NoAlternateForms  { method   stand-alone { self } }

method new(|c --> ::?CLASS) {
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
                    StrDecode::get(blob, $offset) does HasStandAloneForm(StrDecode::get(blob,$offset))
        } else {
            die "Invalid type name found"
        }
    }

    self
}

#`<<<<<# GENERATOR: Use toggle-generators.raku to [dis|en]able this code.
method encode(%*scripts --> buf8) {
    # a dynamic variable is normally used, in case fallbacks need to refer back
    use Intl::CLDR::Util::StrEncode;

    my $result = buf8.new;

    my $lang-count = %*scripts.grep({none .key ~~ '→'}).elems;

    $result.append: $lang-count div 256;
    $result.append: $lang-count mod 256;

    for %*scripts.grep({none .key ~~ '→'}) -> ( :key($tag), :value($name)) {
        # tags are guaranteed to not be variants or shorts
        # Check if a short version exists
        if %*scripts{$tag ~ '→stand-alone'}:exists {
            # then type 1
            $result.append: 1;
            $result ~= StrEncode::get($tag  // '');
            $result ~= StrEncode::get($name // '');
            $result ~= StrEncode::get(%*scripts{$tag ~ '→stand-alone'} // '');
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
    base{.<type> ~ (.<alt> ?? ('→' ~ .<alt>) !! '')} = contents $_ for xml.&elems('script');
}
>>>>># GENERATOR