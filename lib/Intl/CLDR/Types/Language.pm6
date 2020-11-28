use Intl::CLDR::Immutability;

unit class CLDR-Language is CLDR-Item;

use Intl::CLDR::Types::Dates;
use Intl::CLDR::Types::Delimiters;
use Intl::CLDR::Types::Layout;
use Intl::CLDR::Types::ListPatterns;


has $!parent;
#  has $.character-labels;
has CLDR-Dates        $.dates;
has CLDR-Delimeters   $.delimiters;
has CLDR-Layout       $.layout;
has CLDR-ListPatterns $.list-patterns;
#  has $.locale-display-names;
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

    $!dates         = CLDR-Dates.new:        blob, $offset, self;
    $!delimiters    = CLDR-Delimiters.new:   blob, $offset, self;
    $!layout        = CLDR-Layout.new:       blob, $offset, self;
    $!list-patterns = CLDR-ListPatterns.new: blob, $offset, self;
    $!posix         = CLDR-Posix.new:        blob, $offset, self;

    self
}


##`<<<<< # GENERATOR: This method should only be uncommented out by the parsing script
method encode(%*language) {
    my $result = buf8.new;

    $result ~= CLDR-Dates.encode(       %*language<dates>        // Hash.new);
    $result ~= CLDR-Delimiters.encode(  %*language<delimiters>   // Hash.new);
    $result ~= CLDR-Layout.encode(      %*language<layout>       // Hash.new);
    $result ~= CLDR-ListPatterns.encode(%*language<listPatterns> // Hash.new);
    $result ~= CLDR-Posix.encode(       %*language<posix>        // Hash.new);

    $result
}
method parse(\base, \xml) {
    CLDR-Dates.parse:
    CLDR-Delimiters.parse:
    CLDR-Layout.parse:
    CLDR-ListPatterns.parse:
    CLDR-Posix.new
}
#>>>>> # GENERATOR
