use Intl::CLDR::Types::DerivationCompound;
use Intl::CLDR::Types::DerivationComponent;

#| A class implementing CLDR's <grammaticalDerivations> element, isolated to a single structure.
unit class CLDR::Derivation;
    use Intl::CLDR::Core;
    also does CLDR::Item;

has Str $.gender;
has Str $.plural-first;
has Str $.plural-second;
has Str $.case-first;
has Str $.case-second;

#| Creates a new CLDR-Dates object
method new(\blob, uint64 $offset is rw --> ::?CLASS) {
    use Intl::CLDR::Util::StrDecode;
    self.bless:
        gender        => StrDecode::get(blob, $offset),
        plural-first  => StrDecode::get(blob, $offset),
        plural-second => StrDecode::get(blob, $offset),
        case-first    => StrDecode::get(blob, $offset),
        case-second   => StrDecode::get(blob, $offset),

}

##`<<<<< # GENERATOR: This method should only be uncommented out by the parsing script
method encode(%*derivation) {
    my $result = buf8.new;

    use Intl::CLDR::Util::StrEncode;

    $result ~= StrEncode::get(%*derivation<gender> );
    $result ~= StrEncode::get(%*derivation<plural0>);
    $result ~= StrEncode::get(%*derivation<plural1>);
    $result ~= StrEncode::get(%*derivation<case0>  );
    $result ~= StrEncode::get(%*derivation<case1>  );

    $result
}
method parse(\base, \xml-array) {
    use Intl::CLDR::Util::XML-Helper;

    for xml-array<> -> $item {

        given $item.<feature> {
            when 'gender' { base<         gender> = $item<value>         }
            when 'case'   { base<  case0   case1> = $item<value0 value1> }
            when 'plural' { base<plural0 plural1> = $item<value0 value1> }
        }
    }
}
#>>>>> # GENERATOR
