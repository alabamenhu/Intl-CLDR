use Intl::CLDR::Immutability;

unit class CLDR-ContextTransforms is CLDR-Item;

use Intl::CLDR::Types::ContextTransformUsage;


has $!parent;

has CLDR-ContextTransformUsage $.language;
has CLDR-ContextTransformUsage $.script;
has CLDR-ContextTransformUsage $.territory;
has CLDR-ContextTransformUsage $.variant;
has CLDR-ContextTransformUsage $.key;
has CLDR-ContextTransformUsage $.key-value;
has CLDR-ContextTransformUsage $.month-format-except-narrow;
has CLDR-ContextTransformUsage $.month-standalone-except-narrow;
has CLDR-ContextTransformUsage $.month-narrow;
has CLDR-ContextTransformUsage $.day-format-except-narrow;
has CLDR-ContextTransformUsage $.day-standalone-except-narrow;
has CLDR-ContextTransformUsage $.day-narrow;
has CLDR-ContextTransformUsage $.era-name;
has CLDR-ContextTransformUsage $.era-abbr;
has CLDR-ContextTransformUsage $.era-narrow;
has CLDR-ContextTransformUsage $.quarter-format-wide;
has CLDR-ContextTransformUsage $.quarter-standalone-wide;
has CLDR-ContextTransformUsage $.quarter-abbreviated;
has CLDR-ContextTransformUsage $.quarter-narrow;
has CLDR-ContextTransformUsage $.calendar-field;
has CLDR-ContextTransformUsage $.zone-exemplar-city;
has CLDR-ContextTransformUsage $.zone-long;
has CLDR-ContextTransformUsage $.zone-short;
has CLDR-ContextTransformUsage $.metazone-long;
has CLDR-ContextTransformUsage $.metazone-short;
has CLDR-ContextTransformUsage $.symbol;
has CLDR-ContextTransformUsage $.currency-name;
has CLDR-ContextTransformUsage $.currency-name-count;
has CLDR-ContextTransformUsage $.relative;
has CLDR-ContextTransformUsage $.unit-pattern;
has CLDR-ContextTransformUsage $.number-spellout;


#| Creates a new CLDR-DayPeriodContext object
method new(|c) {
    self.bless!bind-init: |c;
}

submethod !bind-init(\blob, uint64 $offset is rw, \parent) {
    $!parent := parent;

    self.Hash::BIND-KEY: 'language', $!language;
    self.Hash::BIND-KEY: 'script', $!script;
    self.Hash::BIND-KEY: 'territory', $!territory;
    self.Hash::BIND-KEY: 'variant', $!variant;
    self.Hash::BIND-KEY: 'key', $!key;
    self.Hash::BIND-KEY: 'key-value', $!key-value;
    self.Hash::BIND-KEY: 'keyValue', $!key-value;
    self.Hash::BIND-KEY: 'month-format-except-narrow', $!month-format-except-narrow;
    self.Hash::BIND-KEY: 'month-standalone-except-narrow', $!month-standalone-except-narrow;
    self.Hash::BIND-KEY: 'month-narrow', $!month-narrow;
    self.Hash::BIND-KEY: 'day-format-except-narrow', $!day-format-except-narrow;
    self.Hash::BIND-KEY: 'day-standalone-except-narrow', $!day-standalone-except-narrow;
    self.Hash::BIND-KEY: 'day-narrow', $!day-narrow;
    self.Hash::BIND-KEY: 'era-name', $!era-name;
    self.Hash::BIND-KEY: 'era-abbr', $!era-abbr;
    self.Hash::BIND-KEY: 'era-narrow', $!era-narrow;
    self.Hash::BIND-KEY: 'quarter-format-wide', $!quarter-format-wide;
    self.Hash::BIND-KEY: 'quarter-standalone-wide', $!quarter-standalone-wide;
    self.Hash::BIND-KEY: 'quarter-abbreviated', $!quarter-abbreviated;
    self.Hash::BIND-KEY: 'quarter-narrow', $!quarter-narrow;
    self.Hash::BIND-KEY: 'calendar-field', $!calendar-field;
    self.Hash::BIND-KEY: 'zone-exemplar-city', $!zone-exemplar-city;
    self.Hash::BIND-KEY: 'zone-long', $!zone-long;
    self.Hash::BIND-KEY: 'zone-short', $!zone-short;
    self.Hash::BIND-KEY: 'metazone-long', $!metazone-long;
    self.Hash::BIND-KEY: 'metazone-short', $!metazone-short;
    self.Hash::BIND-KEY: 'symbol', $!symbol;
    self.Hash::BIND-KEY: 'currency-name', $!currency-name;
    self.Hash::BIND-KEY: 'currency-name-count', $!currency-name-count;
    self.Hash::BIND-KEY: 'relative', $!relative;
    self.Hash::BIND-KEY: 'unit-pattern', $!unit-pattern;
    self.Hash::BIND-KEY: 'number-spellout', $!number-spellout;

    $!language                       = CLDR-ContextTransformUsage.new: blob, $offset, self;
    $!script                         = CLDR-ContextTransformUsage.new: blob, $offset, self;
    $!territory                      = CLDR-ContextTransformUsage.new: blob, $offset, self;
    $!variant                        = CLDR-ContextTransformUsage.new: blob, $offset, self;
    $!key                            = CLDR-ContextTransformUsage.new: blob, $offset, self;
    $!key-value                      = CLDR-ContextTransformUsage.new: blob, $offset, self;
    $!month-format-except-narrow     = CLDR-ContextTransformUsage.new: blob, $offset, self;
    $!month-standalone-except-narrow = CLDR-ContextTransformUsage.new: blob, $offset, self;
    $!month-narrow                   = CLDR-ContextTransformUsage.new: blob, $offset, self;
    $!day-format-except-narrow       = CLDR-ContextTransformUsage.new: blob, $offset, self;
    $!day-standalone-except-narrow   = CLDR-ContextTransformUsage.new: blob, $offset, self;
    $!day-narrow                     = CLDR-ContextTransformUsage.new: blob, $offset, self;
    $!era-abbr                       = CLDR-ContextTransformUsage.new: blob, $offset, self;
    $!era-name                       = CLDR-ContextTransformUsage.new: blob, $offset, self;
    $!era-narrow                     = CLDR-ContextTransformUsage.new: blob, $offset, self;
    $!quarter-format-wide            = CLDR-ContextTransformUsage.new: blob, $offset, self;
    $!quarter-standalone-wide        = CLDR-ContextTransformUsage.new: blob, $offset, self;
    $!quarter-abbreviated            = CLDR-ContextTransformUsage.new: blob, $offset, self;
    $!quarter-narrow                 = CLDR-ContextTransformUsage.new: blob, $offset, self;
    $!calendar-field                 = CLDR-ContextTransformUsage.new: blob, $offset, self;
    $!zone-exemplar-city             = CLDR-ContextTransformUsage.new: blob, $offset, self;
    $!zone-long                      = CLDR-ContextTransformUsage.new: blob, $offset, self;
    $!zone-short                     = CLDR-ContextTransformUsage.new: blob, $offset, self;
    $!metazone-long                  = CLDR-ContextTransformUsage.new: blob, $offset, self;
    $!metazone-short                 = CLDR-ContextTransformUsage.new: blob, $offset, self;
    $!symbol                         = CLDR-ContextTransformUsage.new: blob, $offset, self;
    $!currency-name                  = CLDR-ContextTransformUsage.new: blob, $offset, self;
    $!currency-name-count            = CLDR-ContextTransformUsage.new: blob, $offset, self;
    $!relative                       = CLDR-ContextTransformUsage.new: blob, $offset, self;
    $!unit-pattern                   = CLDR-ContextTransformUsage.new: blob, $offset, self;
    $!number-spellout                = CLDR-ContextTransformUsage.new: blob, $offset, self;

    self
}


##`<<<<< # GENERATOR: This method should only be uncommented out by the parsing script
method encode(%*context-transforms) {
    my $result = buf8.new;

    $result ~= CLDR-ContextTransformUsage.encode(%*context-transforms<language> // Hash.new);
    $result ~= CLDR-ContextTransformUsage.encode(%*context-transforms<script> // Hash.new);
    $result ~= CLDR-ContextTransformUsage.encode(%*context-transforms<territory> // Hash.new);
    $result ~= CLDR-ContextTransformUsage.encode(%*context-transforms<variant> // Hash.new);
    $result ~= CLDR-ContextTransformUsage.encode(%*context-transforms<key> // Hash.new);
    $result ~= CLDR-ContextTransformUsage.encode(%*context-transforms<keyValue> // Hash.new);
    $result ~= CLDR-ContextTransformUsage.encode(%*context-transforms<month-format-except-narrow> // Hash.new);
    $result ~= CLDR-ContextTransformUsage.encode(%*context-transforms<month-standalone-except-narrow> // Hash.new);
    $result ~= CLDR-ContextTransformUsage.encode(%*context-transforms<month-narrow> // Hash.new);
    $result ~= CLDR-ContextTransformUsage.encode(%*context-transforms<day-format-except-narrow> // Hash.new);
    $result ~= CLDR-ContextTransformUsage.encode(%*context-transforms<day-standalone-except-narrow> // Hash.new);
    $result ~= CLDR-ContextTransformUsage.encode(%*context-transforms<day-narrow> // Hash.new);
    $result ~= CLDR-ContextTransformUsage.encode(%*context-transforms<era-abbre> // Hash.new);
    $result ~= CLDR-ContextTransformUsage.encode(%*context-transforms<era-name> // Hash.new);
    $result ~= CLDR-ContextTransformUsage.encode(%*context-transforms<era-narrow> // Hash.new);
    $result ~= CLDR-ContextTransformUsage.encode(%*context-transforms<quarter-format-wide> // Hash.new);
    $result ~= CLDR-ContextTransformUsage.encode(%*context-transforms<quarter-standalone-wide> // Hash.new);
    $result ~= CLDR-ContextTransformUsage.encode(%*context-transforms<quarter-abbreviated> // Hash.new);
    $result ~= CLDR-ContextTransformUsage.encode(%*context-transforms<quarter-narrow> // Hash.new);
    $result ~= CLDR-ContextTransformUsage.encode(%*context-transforms<calendar-field> // Hash.new);
    $result ~= CLDR-ContextTransformUsage.encode(%*context-transforms<zone-exemplarCity> // Hash.new);
    $result ~= CLDR-ContextTransformUsage.encode(%*context-transforms<zone-long> // Hash.new);
    $result ~= CLDR-ContextTransformUsage.encode(%*context-transforms<zone-short> // Hash.new);
    $result ~= CLDR-ContextTransformUsage.encode(%*context-transforms<metazone-long> // Hash.new);
    $result ~= CLDR-ContextTransformUsage.encode(%*context-transforms<metazona-short> // Hash.new);
    $result ~= CLDR-ContextTransformUsage.encode(%*context-transforms<symbol> // Hash.new);
    $result ~= CLDR-ContextTransformUsage.encode(%*context-transforms<currencyName> // Hash.new);
    $result ~= CLDR-ContextTransformUsage.encode(%*context-transforms<currencyName-count> // Hash.new);
    $result ~= CLDR-ContextTransformUsage.encode(%*context-transforms<relative> // Hash.new);
    $result ~= CLDR-ContextTransformUsage.encode(%*context-transforms<unit-pattern> // Hash.new);
    $result ~= CLDR-ContextTransformUsage.encode(%*context-transforms<number-spellout> // Hash.new);

    $result
}
method parse(\base, \xml) {
    use Intl::CLDR::Util::XML-Helper;
    CLDR-ContextTransformUsage.parse: (base{.<type>} //= Hash.new), $_ for xml.&elems('contextTransformUsage');
}
#>>>>> # GENERATOR
