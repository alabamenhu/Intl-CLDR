use Intl::CLDR::Immutability;

unit class CLDR-DecimalFormatSystem;
    use Intl::CLDR::Core;
    also does CLDR::Item;
    also does Positional; # intentionally *not* CLDR::Ordered

use Intl::CLDR::Types::NumberFormat;
use Intl::CLDR::Types::NumberFormatSet;

has CLDR::NumberFormat    $.standard;
has uint                  $!length-coefficient is built;
has buf8                  $!length-table       is built;
has uint                  $!count-coefficient  is built;
has buf8                  $!count-table        is built;
has CLDR::NumberFormatSet @!sets               is built;

# Forward declaration necessary for trusting
class  Selector { ... }
trusts Selector;
method !sets               { @!sets }
method !length-coefficient { $!length-coefficient }
method !length-table       { $!length-table }
method !count-table        { $!count-table }


#| Creates a new CLDR-DecimalFormat object
method new(\blob, uint64 $offset is rw --> CLDR::DecimalFormatSystem) {
    my $standard           = CLDR::NumberFormat.new(blob, $offset);
    my $length-coefficient = blob[$offset++];
    my $length-table       = blob.subbuf($offset, 4); $offset += 4;
    my $count-coefficient  = blob[$offset++];
    my $count-table        = blob.subbuf($offset, 6); $offset += 6;
    my CLDR::NumberFormatSet @sets;
    @!sets.push: CLDR-NumberFormatSet.new(blob, $offset)
        for ^($!length-coefficient * $!count-coefficient);

    self.bless:
        :$standard, :$length-coefficient, :$length-table, :$count-coefficient, :$count-table, :@sets,
        :count(-1), :length(-1)
}

class Selector does Positional {
    constant DFS = CLDR::DecimalFormatSystem;
    has Int $!count  is built;
    has Int $!length is built;
    has DFS $!parent is built;

    # Length methods
    method full   { die if $!length != -1; Selector.new: :3length, :$!count, :$!parent }
    method long   { die if $!length != -1; Selector.new: :2length, :$!count, :$!parent }
    method medium { die if $!length != -1; Selector.new: :1length, :$!count, :$!parent }
    method short  { die if $!length != -1; Selector.new: :0length, :$!count, :$!parent }
    # Count methods
    method zero   { die if $!count != -1; Selector.new: :$!length, :5count, :$!parent }
    method one    { die if $!count != -1; Selector.new: :$!length, :4count, :$!parent }
    method two    { die if $!count != -1; Selector.new: :$!length, :3count, :$!parent }
    method few    { die if $!count != -1; Selector.new: :$!length, :2count, :$!parent }
    method many   { die if $!count != -1; Selector.new: :$!length, :1count, :$!parent }
    method other  { die if $!count != -1; Selector.new: :$!length, :0count, :$!parent }

    method EXISTS-POS (-->True ) {}
    method AT-POS ($pos) {
        return $!parent.standard without $!length;
        $!count //= 0;

        my $set = $!parent!DFS::sets[
            $!parent!DFS::length-table[$!length] * $!parent!DFS::length-coefficient
            + $!parent!DFS::count-table[$!count]
        ];

        # Nil if $pos < smallest
        .return with $set.AT-POS($pos);
        return $!parent.standard
    }
    method EXISTS-KEY ($key) { $key ∈ <full long medium short zero one two few many other> }
    method AT-KEY ($key) { self."$key"() }

    method List {
        return $!parent.standard, without $!length;
        $!count //= 0;

        my $set = $!parent!DFS::sets[
                $!parent!DFS::length-table[$!length] * $!parent!DFS::length-coefficient
                + $!parent!DFS::count-table[$!count]
        ];
        $set.List
    }

    method !set-parent($!parent) { ; }
}

also is Selector;
method TWEAK { self!Selector::set-parent(self) }

##`<<<<< # GENERATOR: This method should only be uncommented out by the parsing script
method encode($pattern --> buf8) {
    use Intl::CLDR::Util::StrEncode;
    die "Need to increase max pattern size in DecimalFormat.pm6" if $*pattern-type > 2 ** 64;
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
