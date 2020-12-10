############## ⚠︎ TODO ⚠︎ ##############
# The type values from CLDR align     #
# with old style unicode identifiers  #
# (eg 'calendar') and not the current #
# two-letter designations (eg 'ca').  #
# Manual care will need to be taken   #
# to ensure full compatibility        #
#######################################


use Intl::CLDR::Immutability;

unit class CLDR-LocaleExtensionTypes is CLDR-ItemNew is CLDR-Unordered;

has $!parent;

#######################################
#  Attributes currently too variable  #
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
                StrDecode::get(blob, $offset);
    }

    self
}

##`<<<<< # GENERATOR: This method should only be uncommented out by the parsing script
method encode(%*types --> buf8) {
    use Intl::CLDR::Util::StrEncode;
    my $result = buf8.new;

    my $type-count = %*types.keys.elems;
    die "There are more than 255 type values, LocaleExtensionTypes will need to be updated"
        if $type-count > 255;
    $result.append: $type-count;

    for %*types.kv -> $code, $name {
        $result.append: StrEncode::get($code // die "Bad code value for type in extension key {%*extension.key}");
        $result.append: StrEncode::get($name // die "Bad name value for type in extension key {%*extension.key}");
    }


    $result
}
method parse(\base, \xml) {
    # handled entirely at the LocaleExtensions level
}
#>>>>> # GENERATOR
