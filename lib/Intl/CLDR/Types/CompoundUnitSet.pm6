use Intl::CLDR::Immutability;

unit class CLDR::CompoundUnitSet;
use Intl::CLDR::Core;
also does CLDR::Item;
also does Positional;

use Intl::CLDR::Enums;

method of (-->Str) {}

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
    @patterns[$_] := StrDecode::get(blob, $offset)
        for ^($length-coefficient * $count-coefficient * $case-coefficient * $gender-coefficient);

    self.bless: :$length-coefficient, :$length-table,
                :$count-coefficient,  :$count-table,
                :$case-coefficient,   :$case-table,
                :$gender-coefficient, :$gender-table,
                :@patterns;
}

submethod !bind-init(\blob, uint64 $offset is rw --> CLDR::CompoundUnitSet) {
    use Intl::CLDR::Util::StrDecode;

    $!length-coefficient     = blob[$offset++];
    $!length-table           = blob.subbuf($offset, 3); $offset += 3;
    $!count-coefficient      = blob[$offset++];
    $!count-table            = blob.subbuf($offset, 8); $offset += 8;
    $!case-coefficient       = blob[$offset++];
    $!case-table             = blob.subbuf($offset, 14); $offset += 14;
    $!gender-coefficient     = blob[$offset++];
    $!gender-table           = blob.subbuf($offset, 7); $offset += 7;

    for ^($!length-coefficient * $!count-coefficient * $!case-coefficient * $!gender-coefficient) {
        @!patterns[$_] := StrDecode::get(blob, $offset)
    }

    #$!length-coefficient--;
    #$!count-coefficient--;
    #$!case-coefficient--;
    #$!gender-coefficient--;

    self;
}

class Selector is Positional {
    has Int $!length;
    has Int $!count;
    has Int $!case;
    has Int $!gender;
    has CLDR::CompoundUnitSet $!parent;
    constant CUS = CLDR::CompoundUnitSet;
    method new ($parent, $length, $count, $case, $gender --> Selector) {self.bless: :$parent, :$count, :$case, :$length, :$gender}
    method BUILD (:$!parent, :$!count, :$!case, :$!length, :$!gender) {}

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
}


# Length methods
method long                (--> Selector) { Selector.new: self,  0, -1, -1, -1 }
method short               (--> Selector) { Selector.new: self,  1, -1, -1, -1 }
method narrow              (--> Selector) { Selector.new: self,  2, -1, -1, -1 }
# Count methods
method zero                (--> Selector) { Selector.new: self, -1,  0, -1, -1 }
method one                 (--> Selector) { Selector.new: self, -1,  1, -1, -1 }
method two                 (--> Selector) { Selector.new: self, -1,  2, -1, -1 }
method few                 (--> Selector) { Selector.new: self, -1,  3, -1, -1 }
method many                (--> Selector) { Selector.new: self, -1,  4, -1, -1 }
method other               (--> Selector) { Selector.new: self, -1,  5, -1, -1 }
# Case method
method ablative            (--> Selector) { Selector.new: self, -1, -1,  0, -1 }
method accusative          (--> Selector) { Selector.new: self, -1, -1,  1, -1 }
method comitative          (--> Selector) { Selector.new: self, -1, -1,  2, -1 }
method dative              (--> Selector) { Selector.new: self, -1, -1,  3, -1 }
method ergative            (--> Selector) { Selector.new: self, -1, -1,  4, -1 }
method genitive            (--> Selector) { Selector.new: self, -1, -1,  5, -1 }
method instrumental        (--> Selector) { Selector.new: self, -1, -1,  6, -1 }
method locative            (--> Selector) { Selector.new: self, -1, -1,  7, -1 }
method locativecopulative  (--> Selector) { Selector.new: self, -1, -1,  8, -1 }
method nominative          (--> Selector) { Selector.new: self, -1, -1,  9, -1 }
method oblique             (--> Selector) { Selector.new: self, -1, -1, 10, -1 }
method prepositional       (--> Selector) { Selector.new: self, -1, -1, 11, -1 }
method sociative           (--> Selector) { Selector.new: self, -1, -1, 12, -1 }
method vocative            (--> Selector) { Selector.new: self, -1, -1, 13, -1 }
# gender method
method neuter              (--> Selector) { Selector.new: self, -1, -1, -1,  0 }
method masculine           (--> Selector) { Selector.new: self, -1, -1, -1,  1 }
method feminine            (--> Selector) { Selector.new: self, -1, -1, -1,  2 }
method animate             (--> Selector) { Selector.new: self, -1, -1, -1,  3 }
method inanimate           (--> Selector) { Selector.new: self, -1, -1, -1,  4 }
method common              (--> Selector) { Selector.new: self, -1, -1, -1,  5 }
method personal            (--> Selector) { Selector.new: self, -1, -1, -1,  6 }

method pattern             (-->      Str) { Selector.new( self, -1, -1, -1, -1 ).pattern }

##`<<<<< # GENERATOR: This method should only be uncommented out by the parsing script
method encode($pattern --> buf8) {
    use Intl::CLDR::Util::StrEncode;
    # not called, handled at a higher level
}
method parse(\base, \xml --> Nil) {
    # not called, handled at a higher level
}
#>>>>> # GENERATOR
