unit class CLDR::NumberFormatSet;
    use Intl::CLDR::Core;
    also does CLDR::Item;
    also is   CLDR::Ordered;

use Intl::CLDR::Types::NumberFormat;

method new(|c --> ::?CLASS) {
    self.bless!add-items: |c
}

submethod !add-items(\blob, uint64 $offset is rw --> ::?CLASS) {
    use Intl::CLDR::Util::StrDecode;

    my $typed-count = blob[$offset++];

    self.Array::BIND-POS:
            $_,
            CLDR::NumberFormat.new(blob, $offset)
    for ^$typed-count;
    self
}

################################
# Overriden Positional methods #
# This acts a bit funny, since #
# we *always* return something #
################################

#| The number of elements in the set (always ∞, use .List if you need the real count)
method elems { Inf }

#| Converts CLDR-NumberFormatSet into a List for access to raw CLDR-NumberFormat objects
method List  { self.Array::List }

#| Always returns true because an element will always be found
method EXISTS-POS ($ --> True) { }

#| Returns the CLDR-NumberFormat that best matches (largest .type ≤ index)
method AT-POS ($value --> CLDR::NumberFormat) {
    # The binary search may actually be slower than an one-by-one
    # approach, because the items are so few.  TODO: Test at some point
    my uint64 $find = abs $value;
    my $max  = self.Array::elems() - 1;
    my $low  = 0;
    my $high = $max;
    my $mid;

    while $low ≤ $high {
        $mid = ($high+$low) div 2;
        if $find < self.Array::AT-POS($mid).type {
            return Nil if $mid == 0;
            $high = $mid - 1;
        } else {
            last if $mid  == $max;
            last if $find  < self.Array::AT-POS($mid+1).type;
            $low = $mid + 1;
        }
    }
    self.Array::AT-POS($mid)
}

##`<<<<< # GENERATOR: This method should only be uncommented out by the parsing script
method encode(%*formats-set --> buf8) {
    use Intl::CLDR::Util::StrEncode;

    my $result = buf8.new;

    $result.append: %*formats-set.keys.elems;

    for %*formats-set.keys.sort -> $*pattern-type {
        $result ~= CLDR::NumberFormat.encode: %*formats-set{$*pattern-type}
    }

    $result
}
method parse(\base, \xml) { # xml is <decimal formats>
    # not called, handled at a higher level
}
#>>>>> # GENERATOR
