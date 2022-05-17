############## ⚠︎ TODO ⚠︎ ##############
# The type values from CLDR align     #
# with old style unicode identifiers  #
# (eg 'calendar') and not the current #
# two-letter designations (eg 'ca').  #
# Manually care will need to be taken #
# to ensure full compatibility        #
#######################################


unit class CLDR::ExtensionNames;
    use Intl::CLDR::Core;
    also does CLDR::Item;
    also is   CLDR::Unordered;

use Intl::CLDR::Types::ExtensionName;

#######################################
#  Attributes currently too numerous  #
# to define explicitly, done via hash #
#######################################

method new(|c --> ::?CLASS ) {
    self.bless!add-items: |c
}

submethod !add-items(\blob, uint64 $offset is rw --> ::?CLASS ) {
    use Intl::CLDR::Util::StrDecode;
    my $count = blob[$offset++];

    self.Hash::BIND-KEY:
            StrDecode::get(blob, $offset),
            CLDR::ExtensionName.new(blob, $offset)
    for ^$count;

    self
}

#`<<<<<# GENERATOR: Use toggle-generators.raku to [dis|en]able this code.
method encode(%*extensions --> buf8) {
    use Intl::CLDR::Util::StrEncode;

    my $result = buf8.new;

    $result.append: %*extensions.keys.elems;

    for %*extensions<> {
        $result ~= StrEncode::get(.key || die "Odd key value for localeDisplayName extension");
        $result ~= CLDR::ExtensionName.encode: .value;
    }

    $result
}
method parse(\base, \xml) { # xml is <localeDisplayNames> element
    use Intl::CLDR::Util::XML-Helper;

    with xml.&elem('keys') -> \keys {
        for keys.&elems('key') {
            base{.<type>} //= Hash.new;
            base{.<type>}<name> = contents $_;
        }
    }
    with xml.&elem('types') -> \types {
        for types.&elems('type') {
            base{.<key>} //= Hash.new;
            base{.<key>}<types> //= Hash.new;
            base{.<key>}<types>{.<type>} = contents $_;
        }
    }
}
>>>>># GENERATOR