unit class CLDR::ContextTransformUsage;
    use Intl::CLDR::Core;
    also does CLDR::Item;

enum Type (
    no-change            => 0,
    titlecase-first-word => 1,
);

has Type $.ui-list-or-menu is aliased-by<uiListOrMenu>;
has Type $.stand-alone     is aliased-by<standAlone>;
#`[[ these are assumed, but TODO: check if any in the future changes this
has Str $.sentence-start = 'titlecase-firstword'
has Str $.running-text   = 'no-change'
]]


#| Creates a new CLDR::ContextTransformUsage object
method new(\blob, uint64 $offset is rw) {
    # If more options are needed, can create the enum
    # directly from the integer value by using Type( blob[$offset++] )
    my $ui-list-or-menu =
        blob[$offset++] == 0
            ?? Type::no-change
            !! Type::titlecase-first-word;
    my $stand-alone =
        blob[$offset++] == 0
            ?? Type::no-change
            !! Type::titlecase-first-word;
    self.bless:
        :$ui-list-or-menu,
        :$stand-alone;
}

#`<<<<<# GENERATOR: Use toggle-generators.raku to [dis|en]able this code.
method encode(%*context-transform-usage) {
    my $result = buf8.new;
    use Intl::CLDR::Util::StrEncode;
    $result ~= buf8.new: (%*context-transform-usage<uiListOrMenu> // '') eq 'titlecase-firstword' ?? 1 !! 0;
    $result ~= buf8.new: (%*context-transform-usage<stand-alone>  // '') eq 'titlecase-firstword' ?? 1 !! 0;
    #say $result;
    $result
}
method parse(\base, \xml) {
    use Intl::CLDR::Util::XML-Helper;

    base{.<type>} = contents $_ for xml.&elems('contextTransform');
}
>>>>># GENERATOR