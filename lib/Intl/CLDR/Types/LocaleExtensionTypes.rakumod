############## ⚠︎ TODO ⚠︎ ##############
# The type values from CLDR align     #
# with old style unicode identifiers  #
# (eg 'calendar') and not the current #
# two-letter designations (eg 'ca').  #
# Manual care will need to be taken   #
# to ensure full compatibility        #
#######################################

unit class CLDR::LocaleExtensionTypes;
    use Intl::CLDR::Core;
    also does CLDR::Item;
    also is   CLDR::Unordered;

#######################################
#  Attributes currently too variable  #
# to define explicitly, done via hash #
#######################################

method new(|c --> ::?CLASS) {
    self.bless!add-items: |c
}

submethod !add-items(\blob, uint64 $offset is rw --> ::?CLASS) {
    use Intl::CLDR::Util::StrDecode;

    my $count = blob[$offset++];

    self.Hash::BIND-KEY:
            StrDecode::get(blob, $offset),
            StrDecode::get(blob, $offset)
    for ^$count;

    self
}

#`<<<<<# GENERATOR: Use toggle-generators.raku to [dis|en]able this code.
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
>>>>># GENERATOR