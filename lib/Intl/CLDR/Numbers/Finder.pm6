unit module Intl::CLDR::Numbers::Finder;
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



# This is the only method we export, all others are safely
# encapsulated, and so users of the module can freely use
# methods/tokens of our names.
my token local-number ($*locale = "en") is export(:DEFAULT) {

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
}

role Local-Numbers is export {
    method local-number($/) {
        my $number;
        $number = +$<integer>.<groupings>.join;

        with $<fraction> {
            $number += +$_ / (10 ** .chars);
        }

        # These three are mutually exclusive, so we don't need an else
        $number *= .01  if $<percent>;
        $number *= .001 if $<permille>;
        if $<exponent> {
            my $power = +~$<exponent><integer>;
            $power *= -1 with $<exponent><negative>;
            $number *= 10 ** $power;
        }
        make $number;
    }
}