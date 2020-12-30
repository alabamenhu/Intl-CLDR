use Intl::CLDR::Immutability;

unit class CLDR-ContextTransformUsage is CLDR-ItemNew;

enum Type (
    no-change            => 0,
    titlecase-first-word => 1,
);

has      $!parent;
has Type $.ui-list-or-menu;
has Type $.stand-alone;
#`[[ this are assumed, so maybe could be placed?
has Str $.sentence-start = 'titlecase-firstword'
has Str $.running-text   = 'no-change'
]]



#| Creates a new CLDR-DayPeriodContext object
method new(|c) {
    self.bless!bind-init: |c;
}

submethod !bind-init(\blob, uint64 $offset is rw) {
    use Intl::CLDR::Util::StrDecode;

    # If more options are needed, can create the enum
    # directly from the integer value by using Type( blob[$offset++] )
    $!ui-list-or-menu =
        blob[$offset++] == 0
            ?? Type::no-change
            !! Type::titlecase-first-word;
    $!stand-alone =
        blob[$offset++] == 0
            ?? Type::no-change
            !! Type::titlecase-first-word;

    self
}
constant detour = Map.new: (
   uiListOrMenu => 'ui-list-or-menu',
   standAlone   => 'stand-alone'
);
method DETOUR (--> detour) {;}


##`<<<<< # GENERATOR: This method should only be uncommented out by the parsing script
method encode(%*context-transform-usage) {
    my $result = buf8.new;
    use Intl::CLDR::Util::StrEncode;

    $result ~= buf8.new: (%*context-transform-usage<uiListOrMenu> // '') eq 'titlecase-firstword' ?? 1 !! 0;
    $result ~= buf8.new: (%*context-transform-usage<stand-alone>  // '') eq 'titlecase-firstword' ?? 1 !! 0;

    $result
}
method parse(\base, \xml) {
    use Intl::CLDR::Util::XML-Helper;

    base{.<type>} = contents $_ for xml.&elems('contextTransform');
}
#>>>>> # GENERATOR
