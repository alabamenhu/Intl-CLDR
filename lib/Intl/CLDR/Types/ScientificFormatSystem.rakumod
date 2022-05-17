unit class CLDR::ScientificFormatSystem;
    use Intl::CLDR::Core;
    also does CLDR::Item;

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


#| Creates a new CLDR::ScientificFormatSystem object
method new(\blob, uint64 $offset is rw --> ::?CLASS) {
    use Intl::CLDR::Util::StrDecode;

    my $standard           = CLDR::NumberFormat.new(blob, $offset);
    my $length-coefficient = blob[$offset++];
    my $length-table       = blob.subbuf($offset, 4); $offset += 4;
    my $count-coefficient  = blob[$offset++];
    my $count-table        = blob.subbuf($offset, 6); $offset += 6;
    my CLDR::NumberFormatSet @sets;
    @sets.push: CLDR::NumberFormatSet.new(blob, $offset)
        for ^($!length-coefficient * $!count-coefficient);

    self.bless:
        :$standard,
        :$length-coefficient,
        :$length-table,
        :$count-coefficient,
        :$count-table,
        :@sets
}

class Selector is Positional {
    constant SFS = CLDR::ScientificFormatSystem;
    trusts SFS;
    has Int $!count;
    has Int $!length;
    has SFS $!parent;

    # Length methods
    method full   { die with $!length; Selector.new: $!count, :3length, :$!parent }
    method long   { die with $!length; Selector.new: $!count, :2length, :$!parent }
    method medium { die with $!length; Selector.new: $!count, :1length, :$!parent }
    method short  { die with $!length; Selector.new: $!count, :0length, :$!parent }
    # Count methods
    method zero   { die with $!count;  Selector.new: :5count, :$!length, :$!parent }
    method one    { die with $!count;  Selector.new: :4count, :$!length, :$!parent }
    method two    { die with $!count;  Selector.new: :3count, :$!length, :$!parent }
    method few    { die with $!count;  Selector.new: :2count, :$!length, :$!parent }
    method many   { die with $!count;  Selector.new: :1count, :$!length, :$!parent }
    method other  { die with $!count;  Selector.new: :0count, :$!length, :$!parent }

    method EXISTS-POS (-->True ) {}
    method AT-POS ($pos) {
        return $!parent.standard without $!length;
        my $count = $!count // 0;

        my $set = $!parent!SFS::sets[
                  $!parent!SFS::length-table[$!length] * $!parent!SFS::length-coefficient
                + $!parent!SFS::count-table[$count]
        ];

        return $!parent.standard without $set;
                # Nil if $pos < smallest
        .return with $set.AT-POS($pos);
        return $!parent.standard
    }

    method EXISTS-KEY ($key) { $key ∈ <full long medium short zero one two few many other> }
    method AT-KEY ($key) { self."$key"() }

    method List {
        return $!parent.standard, without $!length;
        my $count = $!count // 0;

        my $set = $!parent!SFS::sets[
                $!parent!SFS::length-table[$!length] * $!parent!SFS::length-coefficient
                + $!parent!SFS::count-table[$count]
        ];
        $set.List
    }

    method !set-parent($!parent) {;}
}

also is Selector;
# Awful OO but no other cleaner way
method TWEAK { self!Selector::set-parent(self) }

##`<<<<< # GENERATOR: This method should only be uncommented out by the parsing script
method encode($pattern --> buf8) {
    use Intl::CLDR::Util::StrEncode;
    die "Need to increase max pattern size in ScientificFormat.pm6" if $*pattern-type > 2 ** 64;
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
