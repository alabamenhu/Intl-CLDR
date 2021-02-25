#| A class allowing for selection of the <unit> elements.
#| The keys omit the measurement type, e.g., 'meter' not 'length-meter'
unit class CLDR::SimpleUnits;
    use Intl::CLDR::Core;

    also does CLDR::Item;
    also is   CLDR::Unordered;

use Intl::CLDR::Types::SimpleUnitSet;
use Intl::CLDR::Enums;

#| Creates a new CLDR::SimpleUnits object
method new(\blob, uint64 $offset is rw  --> ::?CLASS) {
    my \new-self = self.bless;

    my $type-count = blob[$offset++];
    use Intl::CLDR::Util::StrDecode;
    new-self.Hash::BIND-KEY:
        StrDecode::get(        blob, $offset),
        CLDR::SimpleUnitSet.new(blob, $offset)
            for ^$type-count;

    new-self;
}

##`<<<<< # GENERATOR: This method should only be uncommented out by the parsing script
method encode(%*simples) {
    use Intl::CLDR::Util::StrEncode;

    # The initial value here is will be set to the
    # total number of elements.
    my $result = buf8.new: 0; # 0 will be adjusted at end

    my $encoded-units = 0;

    my @lengths = <long short narrow>;
    my @counts  = <zero one two few many other 0 1 >;
    my @cases   = <ablative accusative comitative dative ergative genitive instrumental locative
                   locativecopulative nominative oblique prepositional sociative vocative>;

    for %*simples.kv -> $type, %*simple {

        my Int @length-table;
        my Int @count-table;
        my Int @case-table;
        my Int $length-total;
        my Int $count-total;
        my Int $case-total;
        my Str $gender;

        # these should be calculated separated on a per-length basis
        sub check-length($length) { %*simple{$length}.keys > 0 }
        sub check-count( $count ) { return True if %*simple{$_}<unitPatterns>{$count}.keys  > 0 for @lengths; False}
        sub check-case(  $case  ) { return True if %*simple{.[0]}<unitPatterns>{.[1]}{$case}.keys > 0 for @lengths X @counts; False }

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
        $length-total = sum @length-table;
        $count-total  = sum @count-table;
        $case-total   = sum @case-table;
        $gender       = %*simple{ * ; 'gender'}.first('neuter') // 'masculine';

        my buf8 $length-trans = buf8.new:
                0, # guaranteed to be zero
                @length-table[0] ?? 1 !! 0, # if long exists, then it's 1
                @length-table[2] ?? @length-table[0] + 1 !! @length-table[0];

        # count should always exist
        my $real-idx = 0;
        my buf8 $count-trans = buf8.new: 255,255,255,255,255,255,255,255;
        for ^8 { $count-trans[$_] = $real-idx++ if @count-table[$_]}             # unused == 255
        for ^5 { $count-trans[$_] = $count-trans[5] if $count-trans[$_] == 255}  # unused now gets aliased, default = other
        $count-trans[6] = $count-trans[0] if $count-trans[6] == 255;             # special handling for literal one/zero
        $count-trans[7] = $count-trans[1] if $count-trans[7] == 255;

        $real-idx = 0;
        my buf8 $case-trans = buf8.new: 255,255,255,255,255,255,255,255,255,255,255,255,255,255;
        for ^14 { $case-trans[$_] = $real-idx++ if @case-table[$_]}           # unused == 255
        for ^14 { $case-trans[$_] = $case-trans[9] if $case-trans[$_] == 255}  # unused now gets aliased, default = nominative


        # general data first
        # unit name
        # gender
        # display name (x3 for length)
        # per-unit     (x3 for length)

        # The short type removes the 'volume-' or 'length-' prefix which is
        # redundant and not easily predictable for compound units
        my $short-type = $type.match: / <alpha>+ '-' <( .* )> /;
        $result ~= StrEncode::get(~$short-type);
        $result.append: Gender::{$gender}.Int;
        $result ~= StrEncode::get( %*simple< long ><displayName>    // %*simple<short><displayName>    // '');
        $result ~= StrEncode::get(                                     %*simple<short><displayName>    // '');
        $result ~= StrEncode::get( %*simple<narrow><displayName>    // %*simple<short><displayName>    // '');
        $result ~= StrEncode::get( %*simple< long ><perUnitPattern> // %*simple<short><perUnitPattern> // '');
        $result ~= StrEncode::get(                                     %*simple<short><perUnitPattern> // '');
        $result ~= StrEncode::get( %*simple<narrow><perUnitPattern> // %*simple<short><perUnitPattern> // '');

        # then our table data
        $result.append: @length-table.sum;        # lengths in this system
        $result.append: $length-trans>>.Int.Slip; # length conversion table
        $result.append: @count-table.sum;         # counts in this system
        $result.append: $count-trans>>.Int.Slip;  # count conversion table
        $result.append: @case-table.sum;          # cases in this system
        $result.append: $case-trans>>.Int.Slip;   # cases conversion table


        # then the patterns
        my $forms = 0;
        my &valid = { .head if .tail };
        for (@lengths Z @length-table).map(&valid)
          X (@counts  Z @count-table ).map(&valid)
          X (@cases   Z @case-table  ).map(&valid)
         -> ($length, $count, $case) {

            # This shows the fallback order:
            # Highest priority to length, second to count, and lastly to case.
            my
            $pattern   = %*simple{$length}<unitPatterns>{$count}{$case};
            $pattern //= %*simple{$length}<unitPatterns>{$count}<nominative>;
            $pattern //= %*simple{$length}<unitPatterns>< other>{$case};
            $pattern //= %*simple{$length}<unitPatterns>< other><nominative>;
            $pattern //= %*simple<  short><unitPatterns>{$count}{$case};
            $pattern //= %*simple<  short><unitPatterns>{$count}<nominative>;
            $pattern //= %*simple<  short><unitPatterns>< other>{$case};
            $pattern //= %*simple<  short><unitPatterns>< other><nominative>;
            $pattern //= ''; # <-- should never reach this

            $result   ~= StrEncode::get($pattern);
            $forms++;
        }

        die if $forms != $count-total * $length-total * $case-total;

        $encoded-units++;
    }
    die "Add support for > 255 units in SimpleUnits.pm6" if $encoded-units > 255;
    $result[0] = $encoded-units++; # insert final system cmunt
    $result
}
method parse(\base, \xml) {
    use Intl::CLDR::Util::XML-Helper;

    my $*type  = xml<type>;

    base{$*type}{$*length}<gender>         = contents $_ with xml.&elem('gender');
    base{$*type}{$*length}<displayName>    = contents $_ with xml.&elem('displayName');
    base{$*type}{$*length}<perUnitPattern> = contents $_ with xml.&elem('perUnitPattern');

    # At this level, there are four lengths (long, medium, short, narrow) of which only two are currently used
    # (long and short), as well as a fifth pseudo length (no type) that is considered to be the defacto standard.
    for xml.&elems('unitPattern') {
        base{$*type}{$*length}<unitPatterns>{.<count> // 'other'}{.<case> // 'nominative'} = contents $_;
    }
}
#>>>>> # GENERATOR
