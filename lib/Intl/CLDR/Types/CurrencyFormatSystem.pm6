use Intl::CLDR::Immutability;

unit class CLDR-CurrencyFormatSystem is CLDR-ItemNew is Positional;
use Intl::CLDR::Types::NumberFormat;
use Intl::CLDR::Types::NumberFormatSet;

has CLDR-NumberFormat     $.standard;
has CLDR-NumberFormat     $.standard-accounting;
has int                   $!length-coefficient;
has buf8                  $!length-table;
has int                   $!currency-coefficient;
has buf8                  $!currency-table;
has int                   $!count-coefficient;
has buf8                  $!count-table;
has CLDR-NumberFormatSet  @!sets;

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
method new(|c --> CLDR-CurrencyFormatSystem) {
    self.bless!bind-init: |c;
}

submethod !bind-init(\blob, uint64 $offset is rw --> CLDR-CurrencyFormatSystem) {
    use Intl::CLDR::Util::StrDecode;

    $!standard             = CLDR-NumberFormat.new(blob, $offset);
    $!standard-accounting  = CLDR-NumberFormat.new(blob, $offset);
    $!length-coefficient   = blob[$offset++];
    $!length-table         = blob.subbuf($offset, 4); $offset += 4;
    $!currency-coefficient = blob[$offset++];
    $!currency-table       = blob.subbuf($offset, 2); $offset += 2;
    $!count-coefficient    = blob[$offset++];
    $!count-table          = blob.subbuf($offset, 6); $offset += 6;

    @!sets.push: CLDR-NumberFormatSet.new(blob, $offset)
        for ^($!length-coefficient * $!currency-coefficient * $!count-coefficient);

    self
}

class Selector is Positional {
    has Int $!count;
    has Int $!currency;
    has Int $!length;
    has CLDR-CurrencyFormatSystem $!parent;

    method new ($parent) {self.bless: :$parent}
    method BUILD (:$!parent) {}

    # Length methods
    method full       { die with $!length;   $!length   = 3; self }
    method long       { die with $!length;   $!length   = 2; self }
    method medium     { die with $!length;   $!length   = 1; self }
    method short      { die with $!length;   $!length   = 0; self }
    # Currency methods
    method accounting { die with $!currency; $!currency = 1; self }
    method normal     { die with $!currency; $!currency = 0; self }
    # Count methods
    method zero       { die with $!count;    $!count    = 5; self }
    method one        { die with $!count;    $!count    = 4; self }
    method two        { die with $!count;    $!count    = 3; self }
    method few        { die with $!count;    $!count    = 2; self }
    method many       { die with $!count;    $!count    = 1; self }
    method other      { die with $!count;    $!count    = 0; self }

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
        my $set = $!parent!CLDR-CurrencyFormatSystem::sets[
                      $!parent!CLDR-CurrencyFormatSystem::length-table[$!length]
                    * $!parent!CLDR-CurrencyFormatSystem::length-coefficient
                    * $!parent!CLDR-CurrencyFormatSystem::currency-coefficient
                    + $!parent!CLDR-CurrencyFormatSystem::currency-table[$!currency]
                    * $!parent!CLDR-CurrencyFormatSystem::currency-coefficient
                    + $!parent!CLDR-CurrencyFormatSystem::count-table[$!count]
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

        my $set = $!parent!CLDR-CurrencyFormatSystem::sets[
        $!parent!CLDR-CurrencyFormatSystem::length-table[$!length] * $!parent!CLDR-CurrencyFormatSystem::length-coefficient
                + $!parent!CLDR-CurrencyFormatSystem::count-table[$!count]
        ];
        $set.List
    }
}


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
