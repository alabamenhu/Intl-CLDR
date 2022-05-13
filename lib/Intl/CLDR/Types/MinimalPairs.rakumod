use Intl::CLDR::Immutability;

unit class CLDR-MinimalPairs is CLDR-Item;

class CLDR-PluralMinimalPairs  { ... }
class CLDR-OrdinalMinimalPairs { ... }
class CLDR-CaseMinimalPairs    { ... }
class CLDR-GenderMinimalPairs  { ... }

has CLDR-PluralMinimalPairs  $.plural;
has CLDR-OrdinalMinimalPairs $.ordinal;
has CLDR-CaseMinimalPairs    $.case;
has CLDR-GenderMinimalPairs  $.gender;

#| Creates a new CLDR-DayPeriodContext object
method new(|c --> CLDR-MinimalPairs) {
    self.bless!bind-init: |c;
}

submethod !bind-init(\blob, uint64 $offset is rw  --> CLDR-MinimalPairs) {
    $!plural  = CLDR-PluralMinimalPairs.new:  blob, $offset;
    $!ordinal = CLDR-OrdinalMinimalPairs.new: blob, $offset;
    $!case    = CLDR-CaseMinimalPairs.new:    blob, $offset;
    $!gender  = CLDR-GenderMinimalPairs.new:  blob, $offset;
    self
}

class CLDR-PluralMinimalPairs is CLDR-Item {
    has Str $.zero;
    has Str $.one;
    has Str $.two;
    has Str $.few;
    has Str $.many;
    has Str $.other;
    method new(|c --> CLDR-PluralMinimalPairs) { self.bless!bind-init: |c }
    submethod !bind-init(\blob, uint64 $offset is rw --> CLDR-PluralMinimalPairs ) {
        use Intl::CLDR::Util::StrDecode;
        $!zero  = StrDecode::get(blob, $offset);
        $!one   = StrDecode::get(blob, $offset);
        $!two   = StrDecode::get(blob, $offset);
        $!few   = StrDecode::get(blob, $offset);
        $!many  = StrDecode::get(blob, $offset);
        $!other = StrDecode::get(blob, $offset);
        self
    }
}

class CLDR-OrdinalMinimalPairs is CLDR-Item {
    has Str $.zero;
    has Str $.one;
    has Str $.two;
    has Str $.few;
    has Str $.many;
    has Str $.other;
    method new(|c --> CLDR-OrdinalMinimalPairs) { self.bless!bind-init: |c }
    submethod !bind-init(\blob, uint64 $offset is rw --> CLDR-OrdinalMinimalPairs ) {
        use Intl::CLDR::Util::StrDecode;
        $!zero  = StrDecode::get(blob, $offset);
        $!one   = StrDecode::get(blob, $offset);
        $!two   = StrDecode::get(blob, $offset);
        $!few   = StrDecode::get(blob, $offset);
        $!many  = StrDecode::get(blob, $offset);
        $!other = StrDecode::get(blob, $offset);
        self
    }
}

class CLDR-CaseMinimalPairs is CLDR-Item {
    has Str $.ablative;
    has Str $.accusative;
    has Str $.comitative;
    has Str $.dative;
    has Str $.ergative;
    has Str $.genitive;
    has Str $.instrumental;
    has Str $.locative;
    has Str $.locativecopulative;
    has Str $.nominative;
    has Str $.oblique;
    has Str $.prepositional;
    has Str $.sociative;
    has Str $.vocative;
    method new(|c --> CLDR-CaseMinimalPairs) { self.bless!bind-init: |c }
    submethod !bind-init(\blob, uint64 $offset is rw --> CLDR-CaseMinimalPairs ) {
        use Intl::CLDR::Util::StrDecode;
        $!ablative             = StrDecode::get(blob, $offset);
        $!accusative           = StrDecode::get(blob, $offset);
        $!comitative           = StrDecode::get(blob, $offset);
        $!dative               = StrDecode::get(blob, $offset);
        $!ergative             = StrDecode::get(blob, $offset);
        $!genitive             = StrDecode::get(blob, $offset);
        $!instrumental         = StrDecode::get(blob, $offset);
        $!locative             = StrDecode::get(blob, $offset);
        $!locativecopulative   = StrDecode::get(blob, $offset);
        $!nominative           = StrDecode::get(blob, $offset);
        $!oblique              = StrDecode::get(blob, $offset);
        $!prepositional        = StrDecode::get(blob, $offset);
        $!sociative            = StrDecode::get(blob, $offset);
        $!vocative             = StrDecode::get(blob, $offset);
        self
    }
}

class CLDR-GenderMinimalPairs is CLDR-Item {
    has Str $.animate;
    has Str $.common;
    has Str $.feminine;
    has Str $.inanimate;
    has Str $.masculine;
    has Str $.neuter;
    has Str $.personal;
    method new(|c --> CLDR-GenderMinimalPairs) { self.bless!bind-init: |c }
    submethod !bind-init(\blob, uint64 $offset is rw --> CLDR-GenderMinimalPairs ) {
        use Intl::CLDR::Util::StrDecode;
        $!animate   = StrDecode::get(blob, $offset);
        $!common    = StrDecode::get(blob, $offset);
        $!feminine  = StrDecode::get(blob, $offset);
        $!inanimate = StrDecode::get(blob, $offset);
        $!masculine = StrDecode::get(blob, $offset);
        $!neuter    = StrDecode::get(blob, $offset);
        $!personal  = StrDecode::get(blob, $offset);
        self
    }
}




##`<<<<< # GENERATOR: This method should only be uncommented out by the parsing script
method encode(%*min-pairs --> buf8) {
    use Intl::CLDR::Util::StrEncode;
    my $result = buf8.new;
    for <zero one two few many other> -> $plural {
        with %*min-pairs<pluralMinimalpairs> {
            $result ~= StrEncode::get( %*min-pairs<pluralMinimalpairs>{$plural})
        } else { $result ~= StrEncode::get('') }
    }

    for <zero one two few many other> -> $ordinal {
        with %*min-pairs<ordinalMinimalpairs> {
            $result ~= StrEncode::get( %*min-pairs<ordinalMinimalpairs>{$ordinal})
        } else { $result ~= StrEncode::get('') }
    }

    for <ablative accusative comitative dative ergative genitive
         instrumental locative locativecopulative nominative
         oblique prepositional sociative vocative> -> $case {
        with %*min-pairs<caseMinimalpairs> {
            $result ~= StrEncode::get( %*min-pairs<caseMinimalpairs>{$case})
        } else { $result ~= StrEncode::get('') }
    }

    for <animate common feminine inanimate masculine neuter personal> -> $gender {
        with %*min-pairs<genderMinimalpairs> {
            $result ~= StrEncode::get( %*min-pairs<genderMinimalpairs>{$gender})
        } else { $result ~= StrEncode::get('') }
    }

    $result
}
method parse(\base, \xml) {
    use Intl::CLDR::Util::XML-Helper;
    base<pluralMinimalPairs>{ .<count>  } = contents $_ for xml.&elems('pluralMinimalPairs' );
    base<ordinalMinimalPairs>{.<ordinal>} = contents $_ for xml.&elems('ordinalMinimalPairs');
    base<caseMinimalPairs>{   .<case>   } = contents $_ for xml.&elems('caseMinimalPairs'   );
    base<genderMinimalPairs>{ .<gender> } = contents $_ for xml.&elems('genderMinimalPairs' );
}
#>>>>> # GENERATOR
