#| A class representing the <unit> element.
unit class CLDR::SimpleUnitSet;
    use Intl::CLDR::Core;
    use Intl::CLDR::Enums;

    also does CLDR::Item;
    also does Positional;

has Gender::Gender $.gender    is built;
has str   @!display-names      is built;
has str   @!per-unit-patterns  is built;
has uint  $!length-coefficient is built;
has buf8  $!length-table       is built;
has uint  $!case-coefficient   is built;
has buf8  $!case-table         is built;
has uint  $!count-coefficient  is built;
has buf8  $!count-table        is built;
has Str   @!patterns           is built;

method of (--> Str ) { }

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
#| Creates a new CLDR::SimpleUnitSet object
method new(\blob, uint64 $offset is rw --> ::?CLASS) {
    use Intl::CLDR::Util::StrDecode;
    $offset -= 2;
    my $type = StrDecode::get(blob, $offset);

    my str @display-names;
    my str @per-unit-patterns;
    my str @patterns;
    my $gender                 = Gender::Gender(blob[$offset++]);
       @display-names[$_]      = StrDecode::get(blob, $offset) for ^3;
       @per-unit-patterns[$_]  = StrDecode::get(blob, $offset) for ^3;
    my $length-coefficient     = blob[$offset++];
    my $length-table           = blob.subbuf($offset, 3); $offset += 3;
    my $count-coefficient      = blob[$offset++];
    my $count-table            = blob.subbuf($offset, 8); $offset += 8;
    my $case-coefficient       = blob[$offset++];
    my $case-table             = blob.subbuf($offset, 14); $offset += 14;

    @patterns[$_] = StrDecode::get(blob, $offset)
        for ^($length-coefficient * $count-coefficient * $case-coefficient);

    self.bless: :$gender, :@display-names, :@per-unit-patterns, :$length-coefficient,
        :$count-table, :$case-coefficient, :$case-table, :$length-table, :@patterns;
}

class Selector is Positional {
    has Int $!count;
    has Int $!length;
    has Int $!case;
    has CLDR::SimpleUnitSet $!parent;
    constant SUS = CLDR::SimpleUnitSet;
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
        Gender::Gender($!parent!SUS::gender)
    }
    method display-name ( --> str) {
        $!parent!SUS::display-names[
            $!parent!SUS::length-table[$!length == -1 ?? 1 !! $!length ]
        ]
    }
    method per-unit ( --> str) {
        $!parent!SUS::per-unit-patterns[
            $!parent!SUS::length-table[$!length == -1 ?? 1 !! $!length]
        ]
    }
    method pattern ( --> str) {
        $!parent!SUS::patterns[
            $!parent!SUS::length-table[$!length == -1 ?? 1 !! $!length]
                    * $!parent!SUS::case-coefficient
                    * $!parent!SUS::count-coefficient
            + $!parent!SUS::count-table[$!count == -1 ?? 5 !! $!count]
                    * $!parent!SUS::case-coefficient
            + $!parent!SUS::case-table[$!case == -1 ?? 9 !! $!case]
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
multi method gist (::?CLASS:D:) {
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

#`<<<<<# GENERATOR: Use toggle-generators.raku to [dis|en]able this code.
method encode($pattern --> buf8) {
    use Intl::CLDR::Util::StrEncode;
    # not called, handled at a higher level
}
method parse(\base, \xml --> Nil) {
    # not called, handled at a higher level
}
>>>>># GENERATOR