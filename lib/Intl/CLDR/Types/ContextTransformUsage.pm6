use Intl::CLDR::Immutability;

unit class CLDR-ContextTransformUsage is CLDR-Item;

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

submethod !bind-init(\blob, uint64 $offset is rw, \parent) {
    $!parent := parent;

    self.Hash::BIND-KEY: 'ui-list-or-menu', $!ui-list-or-menu;
    self.Hash::BIND-KEY: 'uiListOrMenu',    $!ui-list-or-menu;
    self.Hash::BIND-KEY: 'stand-alone',     $!stand-alone;
    self.Hash::BIND-KEY: 'standAlone',      $!stand-alone;

    use Intl::CLDR::Classes::StrDecode;

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


##`<<<<< # GENERATOR: This method should only be uncommented out by the parsing script
method encode(%*context-transform-usage) {
    my $result = buf8.new;
    say %*context-transform-usage;
    use Intl::CLDR::Classes::StrEncode;

    $result ~= buf8.new: (%*context-transform-usage<uiListOrMenu> // '') eq 'titlecase-firstword' ?? 1 !! 0;
    $result ~= buf8.new: (%*context-transform-usage<stand-alone>  // '') eq 'titlecase-firstword' ?? 1 !! 0;

    $result
}
method parse(\base, \xml) {
    use Intl::CLDR::Util::XML-Helper;

    base{.<type>} = contents $_ for xml.&elems('contextTransform');
}
#>>>>> # GENERATOR
