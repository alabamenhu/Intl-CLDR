unit class CLDR::CurrencyFormatSystem;
    use Intl::CLDR::Core;
    also does CLDR::Item;
    also does Positional; # intentional *not* CLDR::Unordered
    method of (-->Str) {} # but we can type it as Str

use Intl::CLDR::Types::NumberFormat;
use Intl::CLDR::Types::NumberFormatSet;

has CLDR::NumberFormat    $.standard;
has CLDR::NumberFormat    $.standard-accounting;
has uint                  $!length-coefficient;
has buf8                  $!length-table;
has uint                  $!currency-coefficient;
has buf8                  $!currency-table;
has uint                  $!count-coefficient;
has buf8                  $!count-table;
has CLDR::NumberFormatSet @!sets;

# Forward declaration necessary for trusting
class  Selector { ... }
trusts Selector;

method !sets                 { @!sets                 }
method !length-coefficient   { $!length-coefficient   }
method !length-table         { $!length-table         }
method !currency-coefficient { $!currency-coefficient }
method !currency-table       { $!currency-table       }
method !count-table          { $!count-table          }


#| Creates a new CLDR-CurrencyFormat object
method new(\blob, uint64 $offset is rw --> CLDR::CurrencyFormatSystem) {
    use Intl::CLDR::Util::StrDecode;

    # The odd offset pattern here allows the one-line bless, which is fastest
    self.bless:
        standard             => CLDR::NumberFormat.new(blob, $offset),
        standard-accounting  => CLDR::NumberFormat.new(blob, $offset),
        length-coefficient   => blob[$offset],                  # needs a 1 increment
        length-table         => blob.subbuf(($offset += 1), 4), # needs a 4 increment
        currency-coefficient => blob[$offset += 4],             # needs a 1 increment
        currency-table       => blob.subbuf(($offset += 1), 2), # needs a 2 increment
        count-coefficient    => blob[$offset += 2],             # needs a 1 increment
        count-table          => blob.subbuf(($offset += 1), 6), # needs a 6 increment
        sets                 => (
                                    ($offset += 6)
                                &&  (CLDR::NumberFormatSet.new(blob, $offset)
                                        for ^( $!length-coefficient
                                             * $!currency-coefficient
                                             * $!count-coefficient)
                                    )
                                );
}

class Selector is Positional {
    constant CFS = CLDR::CurrencyFormatSystem;
    has Int $!count    is built;
    has Int $!currency is built;
    has Int $!length   is built;
    has CFS $!parent   is built;

    # Length methods
    method full       { die if $!length   = -1; Selector.new: :$!count, :$!currency, :3length, :$!parent }
    method long       { die if $!length   = -1; Selector.new: :$!count, :$!currency, :2length, :$!parent }
    method medium     { die if $!length   = -1; Selector.new: :$!count, :$!currency, :1length, :$!parent }
    method short      { die if $!length   = -1; Selector.new: :$!count, :$!currency, :0length, :$!parent }
    # Currency methods
    method accounting { die if $!currency = -1; Selector.new: :$!count, :1currency, :$!length, :$!parent }
    method normal     { die if $!currency = -1; Selector.new: :$!count, :0currency, :$!length, :$!parent }
    # Count methods (XXX are they supposed to be descending?)
    method zero       { die if $!count    = -1; Selector.new: :5count, :$!currency, :$!length, :$!parent }
    method one        { die if $!count    = -1; Selector.new: :4count, :$!currency, :$!length, :$!parent }
    method two        { die if $!count    = -1; Selector.new: :3count, :$!currency, :$!length, :$!parent }
    method few        { die if $!count    = -1; Selector.new: :2count, :$!currency, :$!length, :$!parent }
    method many       { die if $!count    = -1; Selector.new: :1count, :$!currency, :$!length, :$!parent }
    method other      { die if $!count    = -1; Selector.new: :0count, :$!currency, :$!length, :$!parent }

    method EXISTS-POS (-->True ) {}
    method AT-POS ($pos) {
        $!currency //= 0;
        return $!currency == 0
                ?? $!parent.standard
                !! $!parent.standard-accounting
            without $!length;
        $!count    //= 0;
        $!currency //= 0;

        # and yet, with all this complexity, 99% of CLD sets will only provide
        # one or two currency formats lol.
        my $set = $!parent!CFS::sets[
                      $!parent!CFS::length-table[$!length]
                    * $!parent!CFS::length-coefficient
                    * $!parent!CFS::currency-coefficient
                    + $!parent!CFS::currency-table[$!currency]
                    * $!parent!CFS::currency-coefficient
                    + $!parent!CFS::count-table[$!count]
        ];

        return $!parent.standard without $set;
        # Nil if $pos < smallest
        .return with $set.AT-POS($pos);
        return $!parent.standard
    }
    method EXISTS-KEY ($key) { $key ∈ <full long medium short zero one two few many other normal accounting> }
    method AT-KEY ($key) { self."$key"() }

    method List {
        return $!parent.standard, without $!length;
        $!count //= 0;

        my $set = $!parent!CFS::sets[
                $!parent!CFS::length-table[$!length] * $!parent!CFS::length-coefficient
                + $!parent!CFS::count-table[$!count]
        ];
        $set.List
    }

    method !set-parent($!parent) {;}
}

also is Selector;
# Awful OO but no other cleaner way
method TWEAK { self!Selector::set-parent(self) }

#`<<<
# Length methods
method full   { Selector.new(self).full   }
method long   { Selector.new(self).long   }
method medium { Selector.new(self).medium }
method short  { Selector.new(self).short  }
# Length methods
method normal     { Selector.new(self).normal     }
method accounting { Selector.new(self).accounting }
# Count methods
method zero   { Selector.new(self).zero   }
method one    { Selector.new(self).one    }
method two    { Selector.new(self).two    }
method few    { Selector.new(self).few    }
method many   { Selector.new(self).many   }
method other  { Selector.new(self).other  }
>>>

##`<<<<< # GENERATOR: This method should only be uncommented out by the parsing script
method encode($pattern --> buf8) {
    use Intl::CLDR::Util::StrEncode;
    die "Need to increase max pattern size in CurrencyFormat.pm6" if $*pattern-type > 2 ** 64;
    with buf8.new {
        .reallocate(8);
        .subbuf-rw(0, 0) = StrEncode::get($pattern // ''); # <-- fallback should never happen
        .write-uint64(2, +$*pattern-type, LittleEndian);   # <-- this feels horribly inefficient for storage.
        .return;                                           # TODO change to power-of-ten iff can confirm
    }                                                      # all types for all languages are a power-of-ten
}
method parse(\base, \xml --> Nil) {
    # not called, handled at a higher level
}
#>>>>> # GENERATOR
