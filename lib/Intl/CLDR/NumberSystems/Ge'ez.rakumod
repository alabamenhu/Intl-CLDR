unit module Ge'ezNumerals;
# As far as I have found, there is no formal definition for how Ge'ez (or many
# other systems) should be handled.  I integrate several sources here to
# provide a solution that should fit most cases.  For example, Ge'ez numerals
# do not handle fractions, so all numbers are floored first.

my @numerals =
	("",    |<፲ ፳ ፴ ፵ ፶ ፷ ፸ ፹ ፺>)  # tens    go here
	X~ ("", |<፩ ፪ ፫ ፬ ፭ ፮ ፯ ፰ ፱>); # singles go here

multi sub geez-numeral(Str $geez-numeral, :$to where * eq 'decimal') {
  # This method will attempt to provide a decimal for the numeral
  ...
}

multi sub ge'ez-numeral(Num $decimal) is export { samewith $decimal.floor }
multi sub ge'ez-numeral(Rat $decimal) is export { samewith $decimal.floor }
multi sub ge'ez-numeral(Int() $decimal is copy) is export {
  my $power = 0;
  my $geez = '';
  while $decimal {
      my $unit = ($decimal mod 10 ** ($power+4)) div (10 ** $power);

      # Round numbers (1__ or 1) need special treatment
      my $segment = do given $unit {
        when *>200  { @numerals[$unit div 100] ~ '፻'
                      ~ @numerals[$unit mod 100]       }
        when *≥100  { '፻' ~ @numerals[$unit mod 100]   }
        when     1  { $power > 0 ?? '' !! '፩'          }
        default     { @numerals[$unit mod 100]         }
      }
      if $unit {
        # If the unit is 0 (that is 0000), then we add nothing
        # -- not even a myriad indicator.
        # Otherwise, unit numbers plus a myriad (፼) per power of myriad.
        $geez = $segment ~ ('፼' x $power / 4) ~ $geez
      }
      $decimal -= $unit * (10 ** $power);
      $power   += 4;
  }
  $geez
}
