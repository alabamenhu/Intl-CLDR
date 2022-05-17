unit class CLDR::CompoundUnitSet;

use       Intl::CLDR::Core;
also does CLDR::Item;
#also is   Positional;        # intentionally *not* CLDR::Ordered
method of (-->Str) {}        # but we can type it as Str

use Intl::CLDR::Enums;

has uint $!length-coefficient is built;
has buf8 $!length-table       is built;
has uint $!case-coefficient   is built;
has buf8 $!case-table         is built;
has uint $!count-coefficient  is built;
has buf8 $!count-table        is built;
has uint $!gender-coefficient is built;
has buf8 $!gender-table       is built;
has Str  @!patterns           is built;

# Forward declaration necessary for trusting
class  Selector { ... }
trusts Selector;

method !patterns            { @!patterns            }
method !length-coefficient  { $!length-coefficient  }
method !length-table        { $!length-table        }
method !count-coefficient   { $!count-coefficient   }
method !count-table         { $!count-table         }
method !case-coefficient    { $!case-coefficient    }
method !case-table          { $!case-table          }
method !gender-coefficient  { $!gender-coefficient  }
method !gender-table        { $!gender-table        }


#| Creates a new CLDR::CompoundUnitSet object
method new(\blob, uint64 $offset is rw --> ::?CLASS) {
    use Intl::CLDR::Util::StrDecode;

    my uint  $length-coefficient     = blob[$offset++];
    my blob8 $length-table           = blob.subbuf($offset, 3); $offset += 3;
    my uint  $count-coefficient      = blob[$offset++];
    my blob8 $count-table            = blob.subbuf($offset, 8); $offset += 8;
    my uint  $case-coefficient       = blob[$offset++];
    my blob8 $case-table             = blob.subbuf($offset, 14); $offset += 14;
    my uint  $gender-coefficient     = blob[$offset++];
    my blob8 $gender-table           = blob.subbuf($offset, 7); $offset += 7;
    my Str   @patterns;
    @patterns.push: StrDecode::get(blob, $offset)
        for ^($length-coefficient * $count-coefficient * $case-coefficient * $gender-coefficient);

    self.bless: :$length-coefficient, :$length-table,
                :$count-coefficient,  :$count-table,
                :$case-coefficient,   :$case-table,
                :$gender-coefficient, :$gender-table,
                :@patterns,
                :length(-1), :count(-1), :case(-1), :gender(-1);
}


class Selector is Positional {
    constant CUS = CLDR::CompoundUnitSet;
    trusts CUS;
    has Int $!length is built;
    has Int $!count  is built;
    has Int $!case   is built;
    has Int $!gender is built;
    has CUS $!parent is built;
    method new ($parent, $length, $count, $case, $gender --> Selector) {self.bless: :$parent, :$count, :$case, :$length, :$gender}

    ###############################################################################
    # Ensure that all numbers here line up with what's seen in Intl::CLDR::Enums. #
    # Unfortunately, the list of methods will grow, and I'm not sure of a way to  #
    # automate based on the enums, so they must be manually added with new CLDR.  #
    ###############################################################################

    # Length methods
    method long                (--> Selector) { die if $!length ≠ -1; Selector.new: $!parent,        0, $!count, $!case, $!gender }
    method short               (--> Selector) { die if $!length ≠ -1; Selector.new: $!parent,        1, $!count, $!case, $!gender }
    method narrow              (--> Selector) { die if $!length ≠ -1; Selector.new: $!parent,        2, $!count, $!case, $!gender }
    # Count methods
    method zero                (--> Selector) { die if $!count  ≠ -1; Selector.new: $!parent, $!length,       0, $!case, $!gender }
    method one                 (--> Selector) { die if $!count  ≠ -1; Selector.new: $!parent, $!length,       1, $!case, $!gender }
    method two                 (--> Selector) { die if $!count  ≠ -1; Selector.new: $!parent, $!length,       2, $!case, $!gender }
    method few                 (--> Selector) { die if $!count  ≠ -1; Selector.new: $!parent, $!length,       3, $!case, $!gender }
    method many                (--> Selector) { die if $!count  ≠ -1; Selector.new: $!parent, $!length,       4, $!case, $!gender }
    method other               (--> Selector) { die if $!count  ≠ -1; Selector.new: $!parent, $!length,       5, $!case, $!gender }
    # Case methods
    method ablative            (--> Selector) { die if $!case   ≠ -1; Selector.new: $!parent, $!length, $!count,      0, $!gender }
    method accusative          (--> Selector) { die if $!case   ≠ -1; Selector.new: $!parent, $!length, $!count,      1, $!gender }
    method comitative          (--> Selector) { die if $!case   ≠ -1; Selector.new: $!parent, $!length, $!count,      2, $!gender }
    method dative              (--> Selector) { die if $!case   ≠ -1; Selector.new: $!parent, $!length, $!count,      3, $!gender }
    method ergative            (--> Selector) { die if $!case   ≠ -1; Selector.new: $!parent, $!length, $!count,      4, $!gender }
    method genitive            (--> Selector) { die if $!case   ≠ -1; Selector.new: $!parent, $!length, $!count,      5, $!gender }
    method instrumental        (--> Selector) { die if $!case   ≠ -1; Selector.new: $!parent, $!length, $!count,      6, $!gender }
    method locative            (--> Selector) { die if $!case   ≠ -1; Selector.new: $!parent, $!length, $!count,      7, $!gender }
    method locativecopulative  (--> Selector) { die if $!case   ≠ -1; Selector.new: $!parent, $!length, $!count,      8, $!gender }
    method nominative          (--> Selector) { die if $!case   ≠ -1; Selector.new: $!parent, $!length, $!count,      9, $!gender }
    method oblique             (--> Selector) { die if $!case   ≠ -1; Selector.new: $!parent, $!length, $!count,     10, $!gender }
    method prepositional       (--> Selector) { die if $!case   ≠ -1; Selector.new: $!parent, $!length, $!count,     11, $!gender }
    method sociative           (--> Selector) { die if $!case   ≠ -1; Selector.new: $!parent, $!length, $!count,     12, $!gender }
    method vocative            (--> Selector) { die if $!case   ≠ -1; Selector.new: $!parent, $!length, $!count,     13, $!gender }
    method abessive            (--> Selector) { die if $!case   ≠ -1; Selector.new: $!parent, $!length, $!count,     14, $!gender }
    method adessive            (--> Selector) { die if $!case   ≠ -1; Selector.new: $!parent, $!length, $!count,     15, $!gender }
    method allative            (--> Selector) { die if $!case   ≠ -1; Selector.new: $!parent, $!length, $!count,     16, $!gender }
    method causal              (--> Selector) { die if $!case   ≠ -1; Selector.new: $!parent, $!length, $!count,     17, $!gender }
    method delative            (--> Selector) { die if $!case   ≠ -1; Selector.new: $!parent, $!length, $!count,     18, $!gender }
    method elative             (--> Selector) { die if $!case   ≠ -1; Selector.new: $!parent, $!length, $!count,     19, $!gender }
    method essive              (--> Selector) { die if $!case   ≠ -1; Selector.new: $!parent, $!length, $!count,     20, $!gender }
    method illative            (--> Selector) { die if $!case   ≠ -1; Selector.new: $!parent, $!length, $!count,     21, $!gender }
    method inessive            (--> Selector) { die if $!case   ≠ -1; Selector.new: $!parent, $!length, $!count,     22, $!gender }
    method partitive           (--> Selector) { die if $!case   ≠ -1; Selector.new: $!parent, $!length, $!count,     23, $!gender }
    method sublative           (--> Selector) { die if $!case   ≠ -1; Selector.new: $!parent, $!length, $!count,     24, $!gender }
    method superessive         (--> Selector) { die if $!case   ≠ -1; Selector.new: $!parent, $!length, $!count,     25, $!gender }
    method terminative         (--> Selector) { die if $!case   ≠ -1; Selector.new: $!parent, $!length, $!count,     26, $!gender }
    method translative         (--> Selector) { die if $!case   ≠ -1; Selector.new: $!parent, $!length, $!count,     27, $!gender }
    # Gender methods
    method neuter              (--> Selector) { die if $!count  ≠ -1; Selector.new: $!parent, $!length, $!count, $!case,        0 }
    method masculine           (--> Selector) { die if $!count  ≠ -1; Selector.new: $!parent, $!length, $!count, $!case,        1 }
    method feminine            (--> Selector) { die if $!count  ≠ -1; Selector.new: $!parent, $!length, $!count, $!case,        2 }
    method animate             (--> Selector) { die if $!count  ≠ -1; Selector.new: $!parent, $!length, $!count, $!case,        3 }
    method inanimate           (--> Selector) { die if $!count  ≠ -1; Selector.new: $!parent, $!length, $!count, $!case,        4 }
    method common              (--> Selector) { die if $!count  ≠ -1; Selector.new: $!parent, $!length, $!count, $!case,        5 }
    method personal            (--> Selector) { die if $!count  ≠ -1; Selector.new: $!parent, $!length, $!count, $!case,        6 }

    method AT-KEY($key) {
        self."$key"();
    }

    method pattern ( --> Str) {
        $!parent!CUS::patterns[
            $!parent!CUS::length-table[$!length == -1 ?? 1 !! $!length]
                * $!parent!CUS::count-coefficient
                * $!parent!CUS::case-coefficient
                * $!parent!CUS::gender-coefficient
            + $!parent!CUS::count-table[$!count == -1 ?? 5 !! $!count]
                * $!parent!CUS::case-coefficient
                * $!parent!CUS::gender-coefficient
            + $!parent!CUS::case-table[$!case == -1 ?? 9 !! $!case]
                * $!parent!CUS::gender-coefficient
            + $!parent!CUS::gender-table[$!gender == -1 ?? 0 !! $!gender] # if neuter exists, it's the default.  If not, it reroutes to masculine anyways
        ]
    }

    # Used for the CUS's creation, otherwise set naturally from the bless call
    method !set-parent ($!parent) { ; }
}

also is Selector;
# The below method feels so ... horribly bad OO, but not sure a better way to do it
method TWEAK { self!Selector::set-parent(self) }


##`<<<<< # GENERATOR: This method should only be uncommented out by the parsing script
method encode($pattern --> buf8) {
    use Intl::CLDR::Util::StrEncode;
    # not called, handled at a higher level
}
method parse(\base, \xml --> Nil) {
    # not called, handled at a higher level
}
#>>>>> # GENERATOR
