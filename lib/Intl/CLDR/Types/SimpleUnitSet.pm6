use Intl::CLDR::Immutability;

unit class CLDR-SimpleUnitSet is CLDR-ItemNew is Positional;
use Intl::CLDR::Enums;


has str  @!display-names;
has str  @!per-unit-patterns;
has Gender::Gender  $.gender;
has int  $!length-coefficient;
has buf8 $!length-table;
has int  $!case-coefficient;
has buf8 $!case-table;
has int  $!count-coefficient;
has buf8 $!count-table;
has Str  @!patterns;

# Forward declaration necessary for trusting
class  Selector { ... }
trusts Selector;
method !gender             { $!gender             }
method !display-names      { @!display-names      }
method !per-unit-patterns  { @!per-unit-patterns  }
method !patterns           { @!patterns           }
method !length-coefficient { $!length-coefficient }
method !length-table       { $!length-table       }
method !count-coefficient  { $!count-coefficient  }
method !count-table        { $!count-table        }
method !case-table         { $!case-table         }
method !case-coefficient   { $!case-coefficient   }

method debug {
    say "  Unit debug";
    say "    lengths: ($!length-coefficient)  ", $!length-table;
    say "    counts:  ($!count-coefficient)  ", $!count-table;
    say "    cases:   ($!case-coefficient) " ~ (' ' if $!case-coefficient < 9), $!case-table;
    say "      $_:\t" ~ @!patterns[$_] for ^@!patterns;
}
#| Creates a new CLDR-ScientificFormat object
method new(|c --> CLDR-SimpleUnitSet) {
    self.bless!bind-init: |c;
}

submethod !bind-init(\blob, uint64 $offset is rw --> CLDR-SimpleUnitSet) {
    use Intl::CLDR::Util::StrDecode;

    $offset -= 2;
    my $type = StrDecode::get(blob, $offset);

    $!gender                 = Gender::Gender(blob[$offset++]);
    @!display-names[$_]      = StrDecode::get(blob, $offset) for ^3;
    @!per-unit-patterns[$_]  = StrDecode::get(blob, $offset) for ^3;
    $!length-coefficient     = blob[$offset++];
    $!length-table           = blob.subbuf($offset, 3); $offset += 3;
    $!count-coefficient      = blob[$offset++];
    $!count-table            = blob.subbuf($offset, 8); $offset += 8;
    $!case-coefficient       = blob[$offset++];
    $!case-table             = blob.subbuf($offset, 14); $offset += 14;

    my $decode = 0;
    for ^($!length-coefficient * $!count-coefficient * $!case-coefficient) {
        @!patterns[$_] := StrDecode::get(blob, $offset)
    }
    #@!patterns = my str @[$!length-coefficient, $!count-coefficient, $!case-coefficient];
    #for ^$!length-coefficient X ^$!count-coefficient X ^$!case-coefficient -> ($length, $count, $case) {
    #    @!patterns[
    #        $length * $!length-coefficient * $!count-coefficient +
    #        $count  * $!count-coefficient +
    #        $case
    #    ] := StrDecode::get(blob, $offset);
    #    $decode++;
    #}

    self;
}

class Selector is Positional {
    has Int $!count;
    has Int $!length;
    has Int $!case;
    has CLDR-SimpleUnitSet $!parent;
    constant SUS = CLDR-SimpleUnitSet;
    method new ($parent, $length, $count, $case --> Selector) {self.bless: :$parent, :$length, :$count, :$case }
    method BUILD (:$!parent, :$!length, :$!count, :$!case) {}

    # Length methods
    method long                (--> Selector) { die if $!length ≠ -1; Selector.new: $!parent,        0, $!count, $!case }
    method short               (--> Selector) { die if $!length ≠ -1; Selector.new: $!parent,        1, $!count, $!case }
    method narrow              (--> Selector) { die if $!length ≠ -1; Selector.new: $!parent,        2, $!count, $!case }
    # Count methods
    method zero                (--> Selector) { die if $!count  ≠ -1; Selector.new: $!parent, $!length,       0, $!case }
    method one                 (--> Selector) { die if $!count  ≠ -1; Selector.new: $!parent, $!length,       1, $!case }
    method two                 (--> Selector) { die if $!count  ≠ -1; Selector.new: $!parent, $!length,       2, $!case }
    method few                 (--> Selector) { die if $!count  ≠ -1; Selector.new: $!parent, $!length,       3, $!case }
    method many                (--> Selector) { die if $!count  ≠ -1; Selector.new: $!parent, $!length,       4, $!case }
    method other               (--> Selector) { die if $!count  ≠ -1; Selector.new: $!parent, $!length,       5, $!case }
    # Case methods
    method ablative            (--> Selector) { die if $!case   ≠ -1; Selector.new: $!parent, $!length, $!count,      0 }
    method accusative          (--> Selector) { die if $!case   ≠ -1; Selector.new: $!parent, $!length, $!count,      1 }
    method comitative          (--> Selector) { die if $!case   ≠ -1; Selector.new: $!parent, $!length, $!count,      2 }
    method dative              (--> Selector) { die if $!case   ≠ -1; Selector.new: $!parent, $!length, $!count,      3 }
    method ergative            (--> Selector) { die if $!case   ≠ -1; Selector.new: $!parent, $!length, $!count,      4 }
    method genitive            (--> Selector) { die if $!case   ≠ -1; Selector.new: $!parent, $!length, $!count,      5 }
    method instrumental        (--> Selector) { die if $!case   ≠ -1; Selector.new: $!parent, $!length, $!count,      6 }
    method locative            (--> Selector) { die if $!case   ≠ -1; Selector.new: $!parent, $!length, $!count,      7 }
    method locativecopulative  (--> Selector) { die if $!case   ≠ -1; Selector.new: $!parent, $!length, $!count,      8 }
    method nominative          (--> Selector) { die if $!case   ≠ -1; Selector.new: $!parent, $!length, $!count,      9 }
    method oblique             (--> Selector) { die if $!case   ≠ -1; Selector.new: $!parent, $!length, $!count,     10 }
    method prepositional       (--> Selector) { die if $!case   ≠ -1; Selector.new: $!parent, $!length, $!count,     11 }
    method sociative           (--> Selector) { die if $!case   ≠ -1; Selector.new: $!parent, $!length, $!count,     12 }
    method vocative            (--> Selector) { die if $!case   ≠ -1; Selector.new: $!parent, $!length, $!count,     13 }

    method AT-KEY($key) {
        self."$key"();
    }

    method gender (--> Gender::Gender) {
        Gender::Gender($!parent!CLDR-SimpleUnitSet::gender)
    }
    method display-name ( --> str) {
        $!parent!CLDR-SimpleUnitSet::display-names[
            $!parent!CLDR-SimpleUnitSet::length-table[$!length == -1 ?? 1 !! $!length ]
        ]
    }
    method per-unit ( --> str) {
        $!parent!CLDR-SimpleUnitSet::per-unit-patterns[
            $!parent!CLDR-SimpleUnitSet::length-table[$!length == -1 ?? 1 !! $!length]
        ]
    }
    method pattern ( --> str) {
        $!parent!CLDR-SimpleUnitSet::patterns[
            $!parent!CLDR-SimpleUnitSet::length-table[$!length == -1 ?? 1 !! $!length]
                    * $!parent!CLDR-SimpleUnitSet::case-coefficient
                    * $!parent!CLDR-SimpleUnitSet::count-coefficient
            + $!parent!CLDR-SimpleUnitSet::count-table[$!count == -1 ?? 5 !! $!count]
                    * $!parent!CLDR-SimpleUnitSet::case-coefficient
            + $!parent!CLDR-SimpleUnitSet::case-table[$!case == -1 ?? 9 !! $!case]
        ]
    }
}


# Length methods
method long                (--> Selector) { Selector.new: self,  0, -1, -1 }
method short               (--> Selector) { Selector.new: self,  1, -1, -1 }
method narrow              (--> Selector) { Selector.new: self,  2, -1, -1 }
# Count methods
method zero                (--> Selector) { Selector.new: self, -1,  0, -1 }
method one                 (--> Selector) { Selector.new: self, -1,  1, -1 }
method two                 (--> Selector) { Selector.new: self, -1,  2, -1 }
method few                 (--> Selector) { Selector.new: self, -1,  3, -1 }
method many                (--> Selector) { Selector.new: self, -1,  4, -1 }
method other               (--> Selector) { Selector.new: self, -1,  5, -1 }
# Case method
method ablative            (--> Selector) { Selector.new: self, -1, -1,  0 }
method accusative          (--> Selector) { Selector.new: self, -1, -1,  1 }
method comitative          (--> Selector) { Selector.new: self, -1, -1,  2 }
method dative              (--> Selector) { Selector.new: self, -1, -1,  3 }
method ergative            (--> Selector) { Selector.new: self, -1, -1,  4 }
method genitive            (--> Selector) { Selector.new: self, -1, -1,  5 }
method instrumental        (--> Selector) { Selector.new: self, -1, -1,  6 }
method locative            (--> Selector) { Selector.new: self, -1, -1,  7 }
method locativecopulative  (--> Selector) { Selector.new: self, -1, -1,  8 }
method nominative          (--> Selector) { Selector.new: self, -1, -1,  9 }
method oblique             (--> Selector) { Selector.new: self, -1, -1, 10 }
method prepositional       (--> Selector) { Selector.new: self, -1, -1, 11 }
method sociative           (--> Selector) { Selector.new: self, -1, -1, 12 }
method vocative            (--> Selector) { Selector.new: self, -1, -1, 13 }

# TODO: this isn't accurate.  *sigh*
method gist (CLDR-SimpleUnitSet:D:) {
    my @lengths;
    my @counts;
    my @cases;
    @lengths.push:
        <long short narrow>[$_]
            if $!length-table[$_] for ^3;
    @counts.push:
        <zero one two few many other 0 1>[$_]
            if $!count-table[$_] for ^8;
    @cases.push:
        <lonablative accusative comitative dative ergative genitive instrumental locative
         locativecopulative nominative oblique prepositional sociative vocative>[$_]
            if $!case-table[$_] for ^14;
    '[SimpleUnitSet: ' ~ @lengths.join(',') ~ '; ' ~ @counts.join(',') ~ @cases.join(',') ~ ']'
}

##`<<<<< # GENERATOR: This method should only be uncommented out by the parsing script
method encode($pattern --> buf8) {
    use Intl::CLDR::Util::StrEncode;
    # not called, handled at a higher level
}
method parse(\base, \xml --> Nil) {
    # not called, handled at a higher level
}
#>>>>> # GENERATOR
