unit class CLDR::ContextTransforms;
    use Intl::CLDR::Core;
    also does CLDR::Item;

use Intl::CLDR::Types::ContextTransformUsage;

has CLDR::ContextTransformUsage $.language;
has CLDR::ContextTransformUsage $.script;
has CLDR::ContextTransformUsage $.territory;
has CLDR::ContextTransformUsage $.variant;
has CLDR::ContextTransformUsage $.key;
has CLDR::ContextTransformUsage $.key-value;
has CLDR::ContextTransformUsage $.month-format-except-narrow;
has CLDR::ContextTransformUsage $.month-standalone-except-narrow;
has CLDR::ContextTransformUsage $.month-narrow;
has CLDR::ContextTransformUsage $.day-format-except-narrow;
has CLDR::ContextTransformUsage $.day-standalone-except-narrow;
has CLDR::ContextTransformUsage $.day-narrow;
has CLDR::ContextTransformUsage $.era-name;
has CLDR::ContextTransformUsage $.era-abbr;
has CLDR::ContextTransformUsage $.era-narrow;
has CLDR::ContextTransformUsage $.quarter-format-wide;
has CLDR::ContextTransformUsage $.quarter-standalone-wide;
has CLDR::ContextTransformUsage $.quarter-abbreviated;
has CLDR::ContextTransformUsage $.quarter-narrow;
has CLDR::ContextTransformUsage $.calendar-field;
has CLDR::ContextTransformUsage $.zone-exemplar-city;
has CLDR::ContextTransformUsage $.zone-long;
has CLDR::ContextTransformUsage $.zone-short;
has CLDR::ContextTransformUsage $.metazone-long;
has CLDR::ContextTransformUsage $.metazone-short;
has CLDR::ContextTransformUsage $.symbol;
has CLDR::ContextTransformUsage $.currency-name;
has CLDR::ContextTransformUsage $.currency-name-count;
has CLDR::ContextTransformUsage $.relative;
has CLDR::ContextTransformUsage $.unit-pattern;
has CLDR::ContextTransformUsage $.number-spellout;


#| Creates a new CLDR-DayPeriodContext object
method new(|c) {
    self.bless!bind-init: |c;
}

submethod !bind-init(\blob, uint64 $offset is rw) {

    $!language                       = CLDR::ContextTransformUsage.new: blob, $offset;
    $!script                         = CLDR::ContextTransformUsage.new: blob, $offset;
    $!territory                      = CLDR::ContextTransformUsage.new: blob, $offset;
    $!variant                        = CLDR::ContextTransformUsage.new: blob, $offset;
    $!key                            = CLDR::ContextTransformUsage.new: blob, $offset;
    $!key-value                      = CLDR::ContextTransformUsage.new: blob, $offset;
    $!month-format-except-narrow     = CLDR::ContextTransformUsage.new: blob, $offset;
    $!month-standalone-except-narrow = CLDR::ContextTransformUsage.new: blob, $offset;
    $!month-narrow                   = CLDR::ContextTransformUsage.new: blob, $offset;
    $!day-format-except-narrow       = CLDR::ContextTransformUsage.new: blob, $offset;
    $!day-standalone-except-narrow   = CLDR::ContextTransformUsage.new: blob, $offset;
    $!day-narrow                     = CLDR::ContextTransformUsage.new: blob, $offset;
    $!era-abbr                       = CLDR::ContextTransformUsage.new: blob, $offset;
    $!era-name                       = CLDR::ContextTransformUsage.new: blob, $offset;
    $!era-narrow                     = CLDR::ContextTransformUsage.new: blob, $offset;
    $!quarter-format-wide            = CLDR::ContextTransformUsage.new: blob, $offset;
    $!quarter-standalone-wide        = CLDR::ContextTransformUsage.new: blob, $offset;
    $!quarter-abbreviated            = CLDR::ContextTransformUsage.new: blob, $offset;
    $!quarter-narrow                 = CLDR::ContextTransformUsage.new: blob, $offset;
    $!calendar-field                 = CLDR::ContextTransformUsage.new: blob, $offset;
    $!zone-exemplar-city             = CLDR::ContextTransformUsage.new: blob, $offset;
    $!zone-long                      = CLDR::ContextTransformUsage.new: blob, $offset;
    $!zone-short                     = CLDR::ContextTransformUsage.new: blob, $offset;
    $!metazone-long                  = CLDR::ContextTransformUsage.new: blob, $offset;
    $!metazone-short                 = CLDR::ContextTransformUsage.new: blob, $offset;
    $!symbol                         = CLDR::ContextTransformUsage.new: blob, $offset;
    $!currency-name                  = CLDR::ContextTransformUsage.new: blob, $offset;
    $!currency-name-count            = CLDR::ContextTransformUsage.new: blob, $offset;
    $!relative                       = CLDR::ContextTransformUsage.new: blob, $offset;
    $!unit-pattern                   = CLDR::ContextTransformUsage.new: blob, $offset;
    $!number-spellout                = CLDR::ContextTransformUsage.new: blob, $offset;

    self
}


##`<<<<< # GENERATOR: This method should only be uncommented out by the parsing script
method encode(%*context-transforms) {
    my $result = buf8.new;

    $result ~= CLDR::ContextTransformUsage.encode(%*context-transforms<language> // Hash.new);
    $result ~= CLDR::ContextTransformUsage.encode(%*context-transforms<script> // Hash.new);
    $result ~= CLDR::ContextTransformUsage.encode(%*context-transforms<territory> // Hash.new);
    $result ~= CLDR::ContextTransformUsage.encode(%*context-transforms<variant> // Hash.new);
    $result ~= CLDR::ContextTransformUsage.encode(%*context-transforms<key> // Hash.new);
    $result ~= CLDR::ContextTransformUsage.encode(%*context-transforms<keyValue> // Hash.new);
    $result ~= CLDR::ContextTransformUsage.encode(%*context-transforms<month-format-except-narrow> // Hash.new);
    $result ~= CLDR::ContextTransformUsage.encode(%*context-transforms<month-standalone-except-narrow> // Hash.new);
    $result ~= CLDR::ContextTransformUsage.encode(%*context-transforms<month-narrow> // Hash.new);
    $result ~= CLDR::ContextTransformUsage.encode(%*context-transforms<day-format-except-narrow> // Hash.new);
    $result ~= CLDR::ContextTransformUsage.encode(%*context-transforms<day-standalone-except-narrow> // Hash.new);
    $result ~= CLDR::ContextTransformUsage.encode(%*context-transforms<day-narrow> // Hash.new);
    $result ~= CLDR::ContextTransformUsage.encode(%*context-transforms<era-abbre> // Hash.new);
    $result ~= CLDR::ContextTransformUsage.encode(%*context-transforms<era-name> // Hash.new);
    $result ~= CLDR::ContextTransformUsage.encode(%*context-transforms<era-narrow> // Hash.new);
    $result ~= CLDR::ContextTransformUsage.encode(%*context-transforms<quarter-format-wide> // Hash.new);
    $result ~= CLDR::ContextTransformUsage.encode(%*context-transforms<quarter-standalone-wide> // Hash.new);
    $result ~= CLDR::ContextTransformUsage.encode(%*context-transforms<quarter-abbreviated> // Hash.new);
    $result ~= CLDR::ContextTransformUsage.encode(%*context-transforms<quarter-narrow> // Hash.new);
    $result ~= CLDR::ContextTransformUsage.encode(%*context-transforms<calendar-field> // Hash.new);
    $result ~= CLDR::ContextTransformUsage.encode(%*context-transforms<zone-exemplarCity> // Hash.new);
    $result ~= CLDR::ContextTransformUsage.encode(%*context-transforms<zone-long> // Hash.new);
    $result ~= CLDR::ContextTransformUsage.encode(%*context-transforms<zone-short> // Hash.new);
    $result ~= CLDR::ContextTransformUsage.encode(%*context-transforms<metazone-long> // Hash.new);
    $result ~= CLDR::ContextTransformUsage.encode(%*context-transforms<metazona-short> // Hash.new);
    $result ~= CLDR::ContextTransformUsage.encode(%*context-transforms<symbol> // Hash.new);
    $result ~= CLDR::ContextTransformUsage.encode(%*context-transforms<currencyName> // Hash.new);
    $result ~= CLDR::ContextTransformUsage.encode(%*context-transforms<currencyName-count> // Hash.new);
    $result ~= CLDR::ContextTransformUsage.encode(%*context-transforms<relative> // Hash.new);
    $result ~= CLDR::ContextTransformUsage.encode(%*context-transforms<unit-pattern> // Hash.new);
    $result ~= CLDR::ContextTransformUsage.encode(%*context-transforms<number-spellout> // Hash.new);

    $result
}
method parse(\base, \xml) {
    use Intl::CLDR::Util::XML-Helper;
    CLDR::ContextTransformUsage.parse: (base{.<type>} //= Hash.new), $_ for xml.&elems('contextTransformUsage');
}
#>>>>> # GENERATOR
