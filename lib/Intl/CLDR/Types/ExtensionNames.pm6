############## ⚠︎ TODO ⚠︎ ##############
# The type values from CLDR align     #
# with old style unicode identifiers  #
# (eg 'calendar') and not the current #
# two-letter designations (eg 'ca').  #
# Manually care will need to be taken #
# to ensure full compatibility        #
#######################################


use Intl::CLDR::Immutability;

unit class CLDR-ExtensionNames is CLDR-ItemNew is CLDR-Unordered;

use Intl::CLDR::Types::ExtensionName;

has $!parent;

#######################################
#  Attributes currently too numerous  #
# to define explicitly, done via hash #
#######################################

method new(|c) {
    self.bless!bind-init: |c
}

submethod !bind-init(\blob, uint64 $offset is rw, \parent) {
    use Intl::CLDR::Util::StrDecode;
    $!parent := parent;
    my $count = blob[$offset++];

    for ^$count {
        self.Hash::BIND-KEY:
                StrDecode::get(blob, $offset),
                CLDR-ExtensionName.new(blob, $offset, self);
    }

    self
}

##`<<<<< # GENERATOR: This method should only be uncommented out by the parsing script
method encode(%*extensions --> buf8) {
    use Intl::CLDR::Util::StrEncode;

    my $result = buf8.new;

    $result.append: %*extensions.keys.elems;

    for %*extensions<> {
        $result ~= StrEncode::get(.key || die "Odd key value for localeDisplayName extension");
        $result ~= CLDR-ExtensionName.encode: .value;
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
#>>>>> # GENERATOR
