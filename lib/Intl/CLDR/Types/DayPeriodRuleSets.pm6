use Intl::CLDR::Immutability;


unit class CLDR-DayPeriodRuleSets is CLDR-ItemNew;

use Intl::CLDR::Types::DayPeriodRules;

has CLDR-DayPeriodRules $.standard;   #= Used for formatting times
has CLDR-DayPeriodRules $.selection;  #= Used for generating messages

#| Creates a new CLDR-Dates object
method new(|c) {
    self.bless!bind-init: |c;
}

submethod !bind-init(\blob, uint64 $offset is rw) {
    $!standard  = CLDR-DayPeriodRules.new: blob, $offset;
    $!selection = CLDR-DayPeriodRules.new: blob, $offset;

    self
}

##`<<<<< # GENERATOR: This method should only be uncommented out by the parsing script
method encode(\hash) {
    my $result = buf8.new;

    for <standard selection> -> $*set-type {
        $result ~= CLDR-DayPeriodRules.encode: hash{$*set-type};
        $result ~= CLDR-DayPeriodRules.encode: hash{$*set-type};
    }

    $result;
}
method parse(\base, \xml) {
    use Intl::CLDR::Util::XML-Helper;
    CLDR-DayPeriodRules.parse: (base{.<type> // 'standard'} //= Hash.new), $_ for xml.&elems('dayPeriodRuleSet')
    # TODO ^^ these fallbacks aren't fully accurate for regional variants of base languages
#    base{.<type>} = %( at => .<at>, from => .<from>, before => .<before>) for xml.&elems('dayPeriodRule')
}

#>>>>> # GENERATOR
