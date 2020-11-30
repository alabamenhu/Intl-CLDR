############## ⚠︎ TODO ⚠︎ ##############
# The type values from CLDR align     #
# with old style unicode identifiers  #
# (eg 'calendar') and not the current #
# two-letter designations (eg 'ca').  #
# Manual care will need to be taken   #
# to ensure full compatibility        #
#######################################


use Intl::CLDR::Immutability;

unit class CLDR-ExtensionName is CLDR-Item;
use Intl::CLDR::Types::LocaleExtensionTypes;
has                           $!parent;
has Str                       $.name;
has CLDR-LocaleExtensionTypes $.types;

#######################################
#  Attributes currently too numerous  #
# to define explicitly, done via hash #
#######################################

method new(|c) {
    self.bless!bind-init: |c
}

submethod !bind-init(\blob, uint64 $offset is rw, \parent) {
    use Intl::CLDR::Classes::StrDecode;
    $!parent := parent;

    $!name  = StrDecode::get(blob, $offset);
    $!types = CLDR-LocaleExtensionTypes.new(blob, $offset, self);

    self
}

##`<<<<< # GENERATOR: This method should only be uncommented out by the parsing script
method encode(%*extension --> buf8) {
    use Intl::CLDR::Classes::StrEncode;
    # extension is a Pair object
    my $result = buf8.new;

    $result ~= StrEncode::get(%*extension<name> // '');
    $result ~= CLDR-LocaleExtensionTypes.encode: %*extension<types> // Hash;

    $result
}
method parse(\base, \xml) {
    # handled entirely at the LocaleExtensions level
}
#>>>>> # GENERATOR
