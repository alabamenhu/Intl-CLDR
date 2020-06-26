# unit module Intl::CLDR::Token::Number
#  Formerly provided under Intl::CLDR::Numbers::NumberFinder
#  Refactored on 2020-06-21, should keep providing under both names until 2020-06-01

# Need to manually export to properly wrap the token
sub EXPORT {
    use Intl::CLDR::Numbers;

    my token negative { $( $*symbols.minus-sign   ) }
    my token positive { $( $*symbols.plus-sign    ) }
    my token decimal  { $( $*symbols.decimal      ) }
    my token group    { $( $*symbols.group        ) }
    my token digit    { @( @*digits )               }
    my token integer  { [$<groupings>=[<&digit>+]]+ % <&group> }
    my token fraction {    <&digit>+                }
    my token percent  { $( $*symbols.percent-sign ) }
    my token permille { $( $*symbols.per-mille    ) }
    my token e-symbol { $( $*symbols.exponential  ) }
    my token exponent { [
                        | $<negative> = <&negative>
                        | $<positive> = <&positive>
                        ]?
                        $<integer>=<&integer>
                      }

    #| Gives direct access to the number
    role LocalNumeric[$number] {
        method Numeric { $number }
    }

    # This is the only method we export to avoid contaminating the namespace
    my token local-number ($*locale = "en") {

        :my $*symbols = get-numeric-symbols $*locale;
        :my @*digits  = get-digits $*locale;

        [<negative> | <positive>]?
        <integer>
        [ <decimal><fraction>? ]?

        # After the base number, we can also grab a percent/permille
        # or an exponent.  These maybe should be specified individually
        # with a flag later on, but for now we grab everything
        [
            <.ws>?
            [
            | <percent>
            | <permille>
            | [ <&e-symbol> <.ws>? <exponent> ]
            ]
        ]?

        # When wrapping the token, we don't get access to sub-matches for some reason
        # This gives us that access.
        { $*match := $¢ }
    }

    &local-number.wrap(
      sub (|) {
        # When wrapping, we don't get access to sub-matches for some reason.
        # This gives us access
        my $*match;

        my \match := callsame;      # must use sigil-less because Grammars do not like containerized Matches
        return match unless match;  # immediate toss back if failed
        $/ := $*match;              # QOL

        my $number;
        $number  = +$<integer>.<groupings>.join;
        $number += +$_ / (10 ** .chars) with $<fraction>;

        # Mutually exclusive conditions
        $number *= .01  with $<percent>;
        $number *= .001 with $<permille>;
        with $<exponent> {
            my $power = +~.<integer>;
            $power   *= -1 with .<negative>;
            $number  *= 10 ** $power;
        }

        match but LocalNumeric[$number]
      }
    );

    # Export the token in its wrapped form
    Map.new( '&local-number' => &local-number )
}