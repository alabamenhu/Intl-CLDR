use Intl::CLDR::Immutability;

unit class CLDR::CompoundUnits;
    use Intl::CLDR::Core;
    also does CLDR::Item;
    also is   CLDR::Unordered;

use Intl::CLDR::Types::CompoundUnitSet; # for encode only
use Intl::CLDR::Enums;

method of (--> CLDR::CompoundUnitSet) { }

#| Creates a new CLDR::CompoundUnits object
method new(\blob, uint64 $offset is rw --> ::?CLASS) {
    my \new-self = self.bless;

    my $type-count = blob[$offset++];

    use Intl::CLDR::Util::StrDecode;
    new-self.Hash::BIND-KEY:
        StrDecode::get(           blob, $offset),
        CLDR::CompoundUnitSet.new(blob, $offset)
    for ^$type-count;

    new-self;
}

#`<<<<<# GENERATOR: Use toggle-generators.raku to [dis|en]able this code.
method encode(%*simples) {
    use Intl::CLDR::Util::StrEncode;
    my $result = buf8.new: 0; # 0 will be adjusted at end

    my $encoded-units = 0;

    my @lengths = <long short narrow>;
    my @counts  = <zero one two few many other 0 1 >;
    my @cases   = <ablative accusative comitative dative ergative genitive instrumental locative
                   locativecopulative nominative oblique prepositional sociative vocative>;
    my @genders = <neuter masculine feminine animate inanimate common personal>;

    for %*simples.kv -> $type, %*simple {

        my Int @length-table;
        my Int @count-table;
        my Int @case-table;
        my Int @gender-table;
        my Int $length-total;
        my Int $count-total;
        my Int $case-total;
        my Int $gender-total;
        my Str $gender;

        # these should be calculated separated on a per-length basis
        sub check-length($length) { %*simple{$length}.keys > 0 }
        sub check-count( $count ) { return True if %*simple{$_}{$count}.keys  > 0 for @lengths; False}
        sub check-case(  $case  ) { return True if %*simple{.[0]}{.[1]}{$case}.keys > 0 for @lengths X @counts; False }
        sub check-gender($gender) { return True if %*simple{.[0]}{.[1]}{.[2]}{$gender}.keys > 0 for @lengths X @counts X @cases; False }

        @length-table = [
            check-length('long'),
            check-length('short'),
            check-length('narrow')
        ];
        @count-table = [
            check-count('zero'), check-count('one'  ), check-count('two'), check-count('few'),
            check-count('many'), check-count('other'), check-count('0'  ), check-count('1'  ),
        ];
        @case-table = [
            check-case('ablative'), check-case('accusative'), check-case('comitative'  ), check-case('dative'  ),
            check-case('ergative'), check-case('genitive'  ), check-case('instrumental'), check-case('locative'),
            check-case('locativecopulative'),                 check-case('nominative'  ), check-case('oblique' ),
            check-case('prepositional'     ),                 check-case('sociative'   ), check-case('vocative'),
        ];
        my $default-gender = %*simple{ * ; 'gender'}.first('neuter') // 'masculine';
        .{$default-gender} = (.<unspecified>:delete) if .<unspecified> for %*simple{*;*;*;};
        @gender-table = [
            check-gender('neuter'), check-gender('masculine'), check-gender('feminine'), check-gender('animate'),
            check-gender('inanimate'), check-gender('common'), check-gender('personal'),
        ];

        $length-total = sum @length-table;
        $count-total  = sum @count-table;
        $case-total   = sum @case-table;
        $gender-total = sum @gender-table;

        my buf8 $length-trans = buf8.new:
                0, # guaranteed to be zero
                @length-table[0] + @length-table[1] == 2 ?? 1 !! 0, # if long exists, then it's 1
                @length-table[2] ?? @length-table[1] + 1 !! @length-table[1];

        # count should always exist
        my $real-idx = 0;
        my buf8 $count-trans = buf8.new: 255,255,255,255,255,255,255,255;
        for ^8 { $count-trans[$_] = $real-idx++ if @count-table[$_]}             # unused == 255
        for ^5 { $count-trans[$_] = $count-trans[5] if $count-trans[$_] == 255}  # unused now gets aliased, default = other, ^5 is intentional
        $count-trans[6] = $count-trans[0] if $count-trans[6] == 255;             # special handling for literal one/zero
        $count-trans[7] = $count-trans[1] if $count-trans[7] == 255;

        $real-idx = 0;
        my buf8 $case-trans = buf8.new: 255,255,255,255,255,255,255,255,255,255,255,255,255,255;
        for ^14 { $case-trans[$_] = $real-idx++ if @case-table[$_]}           # unused == 255
        for ^14 { $case-trans[$_] = $case-trans[9] if $case-trans[$_] == 255}  # unused now gets aliased, default = nominative

        $real-idx = 0;
        my buf8 $gender-trans = buf8.new: 255,255,255,255,255,255,255;
        for ^7 { $gender-trans[$_] = $real-idx++ if @gender-table[$_]}           # unused == 255
        for ^7 { $gender-trans[$_] = $gender-trans[ $default-gender eq 'neuter' ?? 0 !! 1 ] if $gender-trans[$_] == 255}  # unused now gets aliased, default = nominative

        # general data first
        $result ~= StrEncode::get($type);

        # then our table data
        $result.append: @length-table.sum;        # lengths in this system
        $result.append: $length-trans>>.Int.Slip; # length conversion table
        $result.append: @count-table.sum;         # counts in this system
        $result.append: $count-trans>>.Int.Slip;  # count conversion table
        $result.append: @case-table.sum;          # cases in this system
        $result.append: $case-trans>>.Int.Slip;   # cases conversion table
        $result.append: @gender-table.sum;          # genders in this system
        $result.append: $gender-trans>>.Int.Slip;   # gender conversion table


        # then the patterns
        my $forms = 0;
        my &valid = { .head if .tail };
        for (@lengths Z @length-table).map(&valid)
          X (@counts  Z @count-table ).map(&valid)
          X (@cases   Z @case-table  ).map(&valid)
          X (@genders Z @gender-table).map(&valid)
        -> ($length, $count, $case, $gender) {

            my
            $pattern   = %*simple{$length}{$count}{     $case}{$gender eq 'unspecified' ?? $default-gender !! $gender};
            $pattern //= %*simple{$length}{$count}{     $case}{$default-gender};
            $pattern //= %*simple{$length}{$count}<nominative>{$gender eq 'unspecified' ?? $default-gender !! $gender};
            $pattern //= %*simple{$length}{$count}<nominative>{$default-gender};
            $pattern //= %*simple{$length}< other>{     $case}{$gender eq 'unspecified' ?? $default-gender !! $gender};
            $pattern //= %*simple{$length}< other>{     $case}{$default-gender};
            $pattern //= %*simple{$length}< other><nominative>{$gender eq 'unspecified' ?? $default-gender !! $gender};
            $pattern //= %*simple{$length}< other><nominative>{$default-gender};
            $pattern //= %*simple<  short>{$count}{     $case}{$gender eq 'unspecified' ?? $default-gender !! $gender};
            $pattern //= %*simple<  short>{$count}{     $case}{$default-gender};
            $pattern //= %*simple<  short>{$count}<nominative>{$gender eq 'unspecified' ?? $default-gender !! $gender};
            $pattern //= %*simple<  short>{$count}<nominative>{$default-gender};
            $pattern //= %*simple<  short>< other>{     $case}{$gender eq 'unspecified' ?? $default-gender !! $gender};
            $pattern //= %*simple<  short>< other>{     $case}{$default-gender};
            $pattern //= %*simple<  short>< other><nominative>{$gender eq 'unspecified' ?? $default-gender !! $gender};
            $pattern //= %*simple<  short>< other><nominative>{$default-gender};
            $pattern //= ''; # <-- should never reach this

            $result   ~= StrEncode::get($pattern);
            $forms++;
        }

        die if $forms != $count-total * $length-total * $case-total * $gender-total;

        $encoded-units++;
    }
    die "Add support for > 255 units in CompoundUnits.pm6" if $encoded-units > 255;
    $result[0] = $encoded-units; # insert final system cmunt

    $result
}
method parse(\base, \xml) {
    use Intl::CLDR::Util::XML-Helper;

    my $*type  = xml<type>;

    # At this level, there are four lengths (long, medium, short, narrow) of which only two are currently used
    # (long and short), as well as a fifth pseudo length (no type) that is considered to be the defacto standard.
    for xml.&elems('compoundUnitPattern') {
        base{$*type}{$*length}{.<count> // 'other'}{.<case> // 'nominative'}{.<gender> // 'unspecified'} = contents $_;
    }
    for xml.&elems('compoundUnitPattern1') {
        base{$*type}{$*length}{.<count> // 'other'}{.<case> // 'nominative'}{.<gender> // 'unspecified'} = contents $_;
    }
    for xml.&elems('unitPrefixPattern') {
        base{$*type}{$*length}{.<count> // 'other'}{.<case> // 'nominative'}{.<gender> // 'unspecified'} = contents $_;
    }
}
>>>>># GENERATOR