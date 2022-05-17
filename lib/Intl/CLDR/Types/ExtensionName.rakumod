############## ⚠︎ TODO ⚠︎ ##############
# The type values from CLDR align     #
# with old style unicode identifiers  #
# (eg 'calendar') and not the current #
# two-letter designations (eg 'ca').  #
# Manual care will need to be taken   #
# to ensure full compatibility        #
#######################################

unit class CLDR::ExtensionName;
    use Intl::CLDR::Core;
    also does CLDR::Item;

use Intl::CLDR::Types::LocaleExtensionTypes;

has Str                        $.name;
has CLDR::LocaleExtensionTypes $.types;

method new(\blob, uint64 $offset is rw --> ::?CLASS ) {
    use Intl::CLDR::Util::StrDecode;

    self.bless:
        name  => StrDecode::get(blob, $offset),
        types => CLDR::LocaleExtensionTypes.new(blob, $offset);
}

##`<<<<< # GENERATOR: This method should only be uncommented out by the parsing script
method encode(%*extension --> buf8) {
    use Intl::CLDR::Util::StrEncode;
    # extension is a Pair object
    my $result = buf8.new;

    $result ~= StrEncode::get(%*extension<name> // '');
    $result ~= CLDR::LocaleExtensionTypes.encode: %*extension<types> // Hash;

    $result
}
method parse(\base, \xml) {
    # handled entirely at the LocaleExtensions level
}
#>>>>> # GENERATOR
