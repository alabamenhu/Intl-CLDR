use Intl::CLDR::Immutability;

unit class CLDR-Language is CLDR-Item;

use Intl::CLDR::Types::ContextTransforms;
use Intl::CLDR::Types::Dates;
use Intl::CLDR::Types::Delimiters;
use Intl::CLDR::Types::Layout;
use Intl::CLDR::Types::ListPatterns;
use Intl::CLDR::Types::LocaleDisplayNames;
use Intl::CLDR::Types::Posix;

#    with $file.&elem('characters'        ) { parse-dates (base<dates> //= Hash.new), $_ }
#    with $file.&elem('numbers'           ) { CLDR-Numbers.parse: (base<numbers> //= Hash.new), $_ }
#    with $file.&elem('units'             ) { parse-dates (base<dates> //= Hash.new), $_ }
#    with $file.&elem('characterLabels'   ) { parse-dates (base<dates> //= Hash.new), $_ }
#    with $file.&elem('typographicNames'  ) { parse-dates (base<dates> //= Hash.new), $_ }

has $!parent;
#  has $.character-labels;
has CLDR-ContextTransforms  $.context-transforms;
has CLDR-Dates              $.dates;
has CLDR-Delimiters         $.delimiters;
has CLDR-Layout             $.layout;
has CLDR-ListPatterns       $.list-patterns;
has CLDR-LocaleDisplayNames $.locale-display-names;
#  has $.numbers;
has CLDR-Posix        $.posix;
#  has $.typographic-names;
#  has $.units;

#| Creates a new CLDR-DayPeriodContext object
method new(|c) {
    self.bless!bind-init: |c;
}

submethod !bind-init(\blob, uint64 $offset is rw, \parent) {
    $!parent := parent;

    self.Hash::BIND-KEY: 'dates',         $!dates;
    self.Hash::BIND-KEY: 'delimiters',    $!delimiters;
    self.Hash::BIND-KEY: 'layout',        $!layout;
    self.Hash::BIND-KEY: 'list-patterns', $!list-patterns;
    self.Hash::BIND-KEY: 'listPatterns',  $!list-patterns;
    self.Hash::BIND-KEY: 'posix',         $!posix;
    # ...
    # ...

    $!context-transforms = CLDR-ContextTransforms.new: blob, $offset, self;
    $!dates              = CLDR-Dates.new:             blob, $offset, self;
    $!delimiters         = CLDR-Delimiters.new:        blob, $offset, self;
    $!layout             = CLDR-Layout.new:            blob, $offset, self;
    $!list-patterns      = CLDR-ListPatterns.new:      blob, $offset, self;
    $!posix              = CLDR-Posix.new:             blob, $offset, self;

    self
}


##`<<<<< # GENERATOR: This method should only be uncommented out by the parsing script
method encode(%*language) {
    my $result = buf8.new;

    $result ~= CLDR-ContextTransforms.encode( %*language<dates>        // Hash.new);
    $result ~= CLDR-Dates.encode(             %*language<dates>        // Hash.new);
    $result ~= CLDR-Delimiters.encode(        %*language<delimiters>   // Hash.new);
    $result ~= CLDR-Layout.encode(            %*language<layout>       // Hash.new);
    $result ~= CLDR-ListPatterns.encode(      %*language<listPatterns> // Hash.new);
    $result ~= CLDR-Posix.encode(             %*language<posix>        // Hash.new);

    $result
}
method parse(\base, \xml) {
    use Intl::CLDR::Util::XML-Helper;
    CLDR-ContextTransforms.parse: (base<contextTransforms> //= Hash.new), $_ with xml.&elem('contextTransforms');
    CLDR-Dates.parse:             (base<dates>             //= Hash.new), $_ with xml.&elem('dates');
    CLDR-Delimiters.parse:        (base<delimiters>        //= Hash.new), $_ with xml.&elem('delimiters');
    CLDR-Layout.parse:            (base<layout>            //= Hash.new), $_ with xml.&elem('layout');
    CLDR-ListPatterns.parse:      (base<listPatterns>      //= Hash.new), $_ with xml.&elem('listPatterns');
    CLDR-Posix.parse:             (base<posix>             //= Hash.new), $_ with xml.&elem('posix');
}
#>>>>> # GENERATOR
