unit module PatternParser;
use Intl::CLDR::Numbers::Enums;

#enum NumberPadding <no-padding  pre-prefix-padding  pre-number-padding  post-suffix-padding  post-number-padding>;
#enum CurrencyType <no-currency  standard-currency  iso-currency  name-currency  narrow-currency>;

grammar Pattern {
  token TOP { <pattern> [ ';' <negative> ]? }
  token negative       {
                        || <pattern>
                        || <prefix>? '#' <suffix>? <?{ $<prefix> || $<suffix> }> # need at least one
                       }
  token pattern {
    <padding>? # Note the pad spec can only match once.
    <prefix>?
    <padding>?
    <number>
    <exponent>?
    <padding>?
    <suffix>?
    <padding>?
    <?{ $<padding> ≤ 1}> # Enforce a single match
  }
  token number     {
                     | <integer> ['.' <fraction>]? # the decimal is needed for exponent, ignored otherwise
                     | <sig-digits>
                   }
  token prefix     { <text>+ }
  token suffix     { <text>+ }
  token text       { <quoted> || (<-[.,;E*'0..9#@]>) } # %‰¤+- have meaning, TODO TR 35 says E doesn't need to be quoted
  token quoted     { '\'' (<[-+.,;E*%‰¤0..9#@]>)? '\'' }
  token integer    {
                      <[#,]>*    # placeholder digits / grouping separators
                      <[0,]>*    # mandatory / rounding digits / grouping separators
                                 #   well, mandatory unless there's an E.  So much for
                                 #   clear standards.

                      <?{ $/.contains('0') || $/.contains('#') }> # must have a single digit
                      <!{ $/.ends-with: ',' }> # must have a single digit
                   }
  token fraction   {
                      <[0,]>*    # mandatory / rounding digits / grouping separators (rare)
                      <[#,]>*    # placeholder (generally 3) / grouping separators
                      <?{ $/.Str.chars > 0 }> # must have a single digit of some type
                   }
  token sig-digits {
                      <[#,]>*
                      <[@,]>+ # At least one @, flanked by #, all may have grouping separators
                      <[#,]>*
                   }
  token exponent   { 'E'  ('+')? ('0'+) }
  token padding    { '*' (.) }
                   # the docs say the pad character can be anything, and that
                   # that the the * escapes.  So frankly, I'm not sure why
                   # it *can't* be a single quote per the BNF,
                   # see http://unicode.org/reports/tr35/tr35-numbers.html#Padding
                   # Plus the formal definition excludes higher plane stuff which seems silly
}


class PatternActions {
  has %.symbols;
  method TOP ($/) {
    my %positive = $<pattern>.made;
    my %negative;
    if $<negative> {
      if $<negative>.made<mirror> {
        %negative = %positive;
        %negative<prefix suffix> = $<negative>.made<prefix suffix>;
      } else {
        %negative = $<negative>.made
      }
    } else {
      %negative = %positive;
      %negative<prefix> = |%negative<prefix>, (:replace('-') ); # by default, add on a negative symbol
    }
    make %(positive => %positive, negative => %negative);
  }
  method number ($/) {
    if $<integer> {
      my %number = $<integer>.made;
      if $<fraction> {
        %number{.key} = .value for $<fraction>.made
      }
      make %number;
    } else {
      make $<sig-digits>.made
    }
  }
  method pattern ($/) {
    my %result := $<number>.made.append(
      prefix => '',
      suffix => '',
      currency => no-currency
    );
    %result<prefix> = $<prefix> ?? $<prefix>.made !! ();
    %result<suffix> = $<suffix> ?? $<suffix>.made !! ();

    if $<exponent> {
      %result.append($<exponent>.made);
      # According to TR35, when using exponents, significant digits are used.
      # They are determined by a different method which is not entirely intuitive.
      # If the mantissa (in $<number>) includes a period, then...
      if $<number>.Str.contains('.') {
        # If the mantissa contains at least one 0:
        if $<number>.Str.contains('0') {
          # Use the number of 0s BEFORE the period plus number of # and 0 after
          # TODO this can be done in two statements by moving the if as a posfix
          my @split = $<number>.Str.split('.');
          %result<maximum-significant-digits> =
              @split[0].comb('0').elems
              + @split[1].comb.grep({$^a eq '#' || $^a eq '0'}).elems;
        # otherwise (no 0s)
        } else {
          # Use 1 + number of # after period
          %result<maximum-significant-digits> = 1 + $<number>.Str.split('.')[1].comb( '#' ).elems;
        }
      # otherswise (no period)
      } else {
        # if the mantissa has at least one 0, then number of 0s, otherwise infinity
        %result<maximum-significant-digits> = $<number>.Str.comb('0').elems;
        %result<maximum-significant-digits> = ∞ unless %result<maximum-significant-digits>;
      }
      # Additionally, when using exponents, the maximum number of integer digits
      # not only can be known but DEFINES exponential grouping.  This is defined
      # by the number of digits (# or 0) before the period in the mantissa.
      # Normally, the maximum digits will be 1 (a single 0 or #) but if there
      # are three, then during formatting, the powers are limited to multiples
      # of the maximum integer value.
      %result<maximum-integer-digits> =
          $<number>.Str.split('.')[0].grep({$^a eq '#' || $^a eq '0'}).elems;
    } else {
      %result<use-plus-sign> = False;
      %result<minimum-exponent-digits> = 0; # no exponential formatting
    }

    if $<padding> {
      my $padding = $<padding>[0];
      %result<pad-character> = $padding.made;
      # Pardon the nasty logic.
      %result<pad-position> =
        $padding.from < $<number>.from
          ?? $<prefix> && $padding.from < $<prefix>.from  # before number
              ?? pre-prefix-padding                         # before prefix
              !! pre-number-padding                         # after  prefix or no prefix
          !! $<suffix> && $padding.from > $<suffix>.from  # after number
              ?? pre-prefix-padding                         # after  suffix
              !! pre-number-padding                         # before suffix or no suffix
    } else {
      %result<pad-character> = '';
      %result<pad-position>  = no-padding;
    }
    make %result;

  }
  method negative ($/) {
    if $<pattern> {
      make $<pattern>.made
    } else {
      make %(
        :mirror,
        :prefix($<prefix> ?? $<prefix>.made !! ''),
        :suffix($<suffix> ?? $<suffix>.made !! ''),
      )
    }
  }
  method integer ($/) {
    my $grouping-size;
    my $secondary-grouping-size;

    my @groups = $/.Str.split(',');
    given @groups {
      when 1 { $secondary-grouping-size = $grouping-size = ∞                  }
      when 2 { $secondary-grouping-size = $grouping-size = @groups.tail.chars }
      default { # when more than 2 commas, only the two closest to the decimal
        $secondary-grouping-size = @groups[*-2].chars;        # are considered
        $grouping-size = @groups.tail.chars;
      }
    }

    # minimum integer digits defines padded 0s, so we just count the zeros in
    # the pattern string.  The maximum is not used UNLESS the pattern is all
    # zeros, and then it is set to the same as the minimum.
    my $minimum-integer-digits = @groups.join.comb('0').elems;
    my $maximum-integer-digits = @groups.head.substr(0,1) eq '0'
                                  ?? $minimum-integer-digits
                                  !! ∞;

    make %(
      :$maximum-integer-digits,
      :$minimum-integer-digits,
      :$grouping-size,
      :$secondary-grouping-size,
      :minimum-significant-digits(0), # Not used with int/frac formatting
      :maximum-significant-digits(0), # Not used with int/frac formatting
      :maximum-fraction-digits(0), # Will be overwritten if fraction exists
      :minimum-fraction-digits(0), # Will be overwritten if fraction exists
      :fraction-grouping-size(0),  # Will be overwritten if fraction exists
    );
  }
  method fraction ($/) {
    my @groups = $/.Str.split(',');

    # Based on the first element IFF there was a comma, otherwise ∞ (no separator)
    my $fraction-grouping-size = @groups > 1 ?? @groups.head.chars !! ∞;

    # Minimum fraction digits defines padded 0s, so we just count the zeros in
    # the pattern string.  The maximum is only used if the entire string is 0s,
    # otherwise it's set to 0 (ironically) to be ignored.
    my $minimum-fraction-digits = @groups.join.comb('0').elems;
    my $maximum-fraction-digits = @groups.tail.substr(*-1) eq '0'
                                    ?? $minimum-fraction-digits
                                    !! ∞;

    make %(
      :$maximum-fraction-digits,
      :$minimum-fraction-digits,
      :$fraction-grouping-size,
    );
  }
  method sig-digits ($/) {
    my $grouping-size;
    my $secondary-grouping-size;

    my @groups = $/.Str.split(',');
    given @groups {
      when 1 { $secondary-grouping-size = $grouping-size = 0                  }
      when 2 { $secondary-grouping-size = $grouping-size = @groups.tail.chars }
      default { # when more than 2 commas, only the two closest to the decimal
        $secondary-grouping-size = @groups[*-2].chars;        # are considered
        $grouping-size = @groups.tail.chars;
      }
    }

    # The minimum is the number of @ in the string.
    # The maximum is the number of trailing #, plus the @
    my $minimum-significant-digits = @groups.join.comb('@').elems;
    my $maximum-significant-digits = $minimum-significant-digits + @groups.join.split('@').tail.chars;

    make %(
      :$minimum-significant-digits,
      :$maximum-significant-digits,
      :$grouping-size,
      :$secondary-grouping-size,
      :maximum-integer-digits(0),  # Not used with sig-digit formatting
      :minimum-integer-digits(0),  # Not used with sig-digit formatting
      :maximum-fraction-digits(0), # Not used with sig-digit formatting
      :minimum-fraction-digits(0), # Not used with sig-digit formatting
      :fraction-grouping-size(0),  # Not used with sig-digit formatting, but should?
    )
  }
  method exponent ($/) {
    make %(
      :use-plus-sign(?$0),
      :minimum-exponent-digits($1.chars)
    )
  }
  method padding ($/) { make $0.Str }
  method quoted ($/)  {
    make $0 ?? :exact($0.Str) !! :exact("'") # an empty escaped string counts as a single quote
  }
  method text ($/) {
    make $<quoted>
      ?? $<quoted>.made
      !! '-E+%‰¤'.contains($0.Str) # these can be replaced in a pre/suffix
          ?? :replace($0.Str)
          !! :exact($0.Str)
  }
  method prefix ($/) {
    my @text = $<text>.map(*.made);

    # I'm fairly certain currency code will be handled elsewhere
    #my $currency;
    #if my $offset = $text.index('¤') {
    #  $currency = do given $offset {
    #    when $text.substr($offset,5) eq '¤¤¤¤¤' { die "Quintiple currency symbol currently invalid"  }
    #    when $text.substr($offset,4) eq '¤¤¤¤'  { narrow-currency   }
    #    when $text.substr($offset,3) eq '¤¤¤'   { name-currency     }
    #    when $text.substr($offset,2) eq '¤¤'    { iso-currency      }
    #    when $text.substr($offset,1) eq '¤'     { standard-currency }
    #  }
    #} else {
    #  $currency = no-currency;
    #}
    make @text;
  }
  method suffix ($/) {
    make $<text>.map(*.made);
  }
}



sub parse-pattern($pattern) is export {
  if my $match = Pattern.parse($pattern, :actions(PatternActions)) {
    return $match.made;
  }
  False;
}
