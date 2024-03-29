unit class CLDR::MiscellaneousPatternSet;
    use Intl::CLDR::Core;
    also does CLDR::Item;

has Str $.approximately; #= The pattern used to represent approximate values (≈1.23)
has Str $.at-most;       #= The pattern used to represent values up to and including a number (≤10)
has Str $.at-least;      #= The pattern used to represent values up to and including a number (10+)
has Str $.range;         #= The pattern used to represent a range of values (10–20)


#| Creates a new CLDR-DayPeriodContext object
method new(\blob, uint64 $offset is rw --> ::?CLASS) {
    use Intl::CLDR::Util::StrDecode;
    self.bless:
        approximately => StrDecode::get(blob, $offset),
        at-most       => StrDecode::get(blob, $offset),
        at-least      => StrDecode::get(blob, $offset),
        range         => StrDecode::get(blob, $offset),
}

#`<<<<<# GENERATOR: Use toggle-generators.raku to [dis|en]able this code.
method encode(%*pattern-set) {
    my $result = buf8.new;

    use Intl::CLDR::Util::StrEncode;

    $result ~= StrEncode::get(%*pattern-set<approximately> // %*misc-patterns<latn><approximately>);
    $result ~= StrEncode::get(%*pattern-set<atMost>        // %*misc-patterns<latn><atMost>       );
    $result ~= StrEncode::get(%*pattern-set<atLeast>       // %*misc-patterns<latn><atLeast>      );
    $result ~= StrEncode::get(%*pattern-set<range>         // %*misc-patterns<latn><range>        );

    $result
}
method parse(\base, \xml) {
    # the xml passed here is just the <numbers> main element, since we combine two subelements
    use Intl::CLDR::Util::XML-Helper;
    base{.<type>} = contents $_ for xml.&elems('pattern');
}
>>>>># GENERATOR