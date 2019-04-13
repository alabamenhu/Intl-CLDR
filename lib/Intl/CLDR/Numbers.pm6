unit module Numbers;
use Intl::CLDR::Numbers::Classes;
use Intl::CLDR::Numbers::Enums;
use Intl::UserLanguage;
use Intl::CLDR::Numbers::PatternParser;


my @patterns;
my @symbols;
my %default-systems;
my %numeric-systems;
my %decimal-systems;
my %pattern-db;

BEGIN {
  @patterns = %?RESOURCES<NumberPatterns.data>.lines.map({LazyFormat.new($_)});
  @symbols  = %?RESOURCES<NumericSymbols.data>.lines.map({ SymbolSet.new($_)});
  for %?RESOURCES<NumberSystemsDefault.data>.lines {
    given .split(':') { %default-systems{.[0]} = .[1] }
  }
  for %?RESOURCES<NumberSystems.data>.lines {
    given .split(':',3) { %numeric-systems{.[0]}{.[1]} := @symbols[.[2]] }
  }
  for %?RESOURCES<DecimalSystems.data>.lines {
    given .split(':',3) { %decimal-systems{.[0]} := .[1].comb.Array }
  }
}


sub format-number(
    $number is copy,
    # The following are the general format types in order of precedence.
    :$engineering = False,
    :$scientific  = $engineering, # engineering requires exponential
    :$percent     = False,
    :$short       = False,
    :$long        = False,
    # Default to the user's top language unless otherwise passed.
    :$language    = INIT {user-language},
    # Rarely, if ever, used, could/should be obtained from -u tag as well
    :$system      = get-default-number-system($language),
    # Generally called only via localization modules
    :$count       = 'other',
    # These could be specified by the user, and should eventually be exposed
    # in a more transparent way.
    :%symbols     = get-numeric-symbols($language, :$system).symbols,
    # If specified, pattern overrides whatever may be obtained otherwise.
    # because it can be a Str or a pattern object (lazy or direct) of some sort.
    :$pattern is copy = False
    ) is export {

  unless $pattern {
    $pattern = get-number-pattern(
      $language, :$system, :$count,
      :length($scientific || $percent || (!$short && !$long)
                ?? 'standard'
                !! $long ?? 'long' !! 'short' ),
      :format($scientific
                ?? 'scientific'
                !! $percent ?? 'percent' !! 'decimal' ),
      :type(  ($long || $short)
                ?? $number > 1000
                    ?? 10 ** ($number.abs.log10.ceiling - 1) # lowest 10+
                    !! 1000 # 1, 10, 100 will error
                !! 'standard' )
    );
  }

  my %pattern; # will be guaranteed to be an accessible pattern
  if $pattern.isa(Str) {
    %pattern = parse-pattern($pattern);
  } elsif $pattern.isa(LazyFormat) {
    %pattern := $pattern.format;
  } else {
    %pattern := $pattern;
  }


  if $scientific {
    # TODO this creates a permanent change!!!  This can only be fixed when
    # we allow for modification of arbitrary values which is forthcoming
    %pattern<positive><maximum-integer-digits> = 3 if $engineering;
    return format-decimal($number, %pattern,%symbols,$system);
  } elsif $short || $long {
    die if $number > 10 ** 15 || $number < 0; # per ICU CompactDecimalFormat,
                                              # CLDR doesn't (currently) specify
                                              # higher and neg is rejected
    return format-symbols($number.floor.Str, %symbols,$system) if $number < 1000;
    my @significant = significant-digits(
                        $number.floor,
                        %pattern<positive><minimum-integer-digits> + %pattern<positive><minimum-fraction-digits>
                      ).comb; # decimal gets in the way,
    my $string;
    $string ~= @significant.shift for %pattern<positive><minimum-integer-digits>;
    $string ~= '.';
    $string ~= @significant.shift for %pattern<positive><minimum-fraction-digits>;

    return format-xfix(%pattern<positive><prefix>,%symbols) ~ format-symbols($string,%symbols,$system) ~ format-xfix(%pattern<positive><suffix>,%symbols);
  } else { # decimal or percent
    return format-decimal($percent ?? $number * 100 !! $number, %pattern, %symbols, $system);
  }
}

sub format-currency($number) { ... }

sub get-number-pattern(
  Str() $language,
  :$system = get-default-number-system($language),
  :$count  = 'other',
  :$length = 'standard',
  :$type   = 'standard',
  :$format = 'decimal'
) {
  return %pattern-db{$language}{$format}{$system}{$length}{$type}{$count}
      if %pattern-db{$language}{$format}{$system}{$length}{$type}{$count}:exists;
  # If a requested combination reaches this point, there is a high probability
  # that it will be requested again.  So (1) we attempt to determine the pattern
  # that best matches the request, and (2) bind the result to the requested
  # combination's value, to shortcircuit the process in the future with minimal
  # extra overhead.

  # I'm sure there's a way to simplify this selection process, but...
  my @subtags = $language.split('-');
  my @languages-to-try = |(@subtags[0..(@subtags-1-$_)].join('-') for ^@subtags), 'root';
  LANGUAGE:
  for @languages-to-try -> $alt-language {
    # We load each file that exists, stopping when we cannot load anymore
    # For most languages, that will mean only one or two subtags will be used,
    # but for a very few, three may be used.
    # TODO I know there is better logic here to avoid reloading
    if %pattern-db{$alt-language}:!exists {
      quietly { # The .extension test will generate a warning
        if %?RESOURCES{"NumberPatterns/{$alt-language}.data"}.extension { # this is the quick way to test to see if the file exists
          load-patterns($alt-language);
        }else{
          next LANGUAGE
        }
      }
    }

    my @formats-to-try = $format eq 'decimal' ?? ($format,'decimal') !! ($format,);

    FORMAT:
    for @formats-to-try -> $alt-format {

      my @systems-to-try = $system eq get-default-number-system($language)
                            ?? ($system,get-default-number-system($language))
                            !! ($system,);


      SYSTEM:
      for @systems-to-try -> $alt-system {

        # This could probably be simplified, as if any ONE long type isn't found
        # there is an almost 100% chance that there are no long types defined
        # for the language
        my @lengths-to-try = do given ($length) {
          when 'long'     { <long short> } # short is guaranteed in root,
          when 'short'    { <short>      } # cannot fall back to normal because
          when 'standard' { <standard>     } #   formats are incompatible
        }

        LENGTH:
        for @lengths-to-try -> $alt-length {

          # TODO this is nasty but I'm lazy
          my @types-to-try = do given ($type) { #
            when 'standard'     { <standard>       }
            when '10'                   { <10 standard> }
            when '100'                  { <100 10 standard> }
            when '1000'                 { <1000 100 10 standard> }
            when '10000'                { <10000 1000 100 10 standard> }
            when '100000'               { <100000 10000 1000 100 10 standard> }
            when '1000000'              { <1000000 100000 10000 1000 100 10 standard> }
            when '10000000'             { <10000000 1000000 100000 10000 1000 100 10 standard> }
            when '100000000'            { <100000000 10000000 1000000 100000 10000 1000 100 10 standard> }
            when '1000000000'           { <1000000000 100000000 10000000 1000000 100000 10000 1000 100 10 standard> }
            when '10000000000'          { <10000000000 1000000000 100000000 10000000 1000000 100000 10000 1000 100 10 standard> }
            when '100000000000'         { <100000000000 10000000000 1000000000 100000000 10000000 1000000 100000 10000 1000 100 10 standard> }
            when '1000000000000'        { <1000000000000 100000000000 10000000000 1000000000 100000000 10000000 1000000 100000 10000 1000 100 10 standard> }
            when '10000000000000'       { <10000000000000 1000000000000 100000000000 10000000000 1000000000 100000000 10000000 1000000 100000 10000 1000 100 10 standard> }
            when '100000000000000'      { <100000000000000 10000000000000 1000000000000 100000000000 10000000000 1000000000 100000000 10000000 1000000 100000 10000 1000 100 10 standard> }
            when '1000000000000000'     { <1000000000000000 100000000000000 10000000000000 1000000000000 100000000000 10000000000 1000000000 100000000 10000000 1000000 100000 10000 1000 100 10 standard> }
            when '10000000000000000'    { <10000000000000000 1000000000000000 100000000000000 10000000000000 1000000000000 100000000000 10000000000 1000000000 100000000 10000000 1000000 100000 10000 1000 100 10 standard> }
            when '100000000000000000'   { <100000000000000000 10000000000000000 1000000000000000 100000000000000 10000000000000 1000000000000 100000000000 10000000000 1000000000 100000000 10000000 1000000 100000 10000 1000 100 10 standard> }
            when '1000000000000000000'  { <1000000000000000000 100000000000000000 10000000000000000 1000000000000000 100000000000000 10000000000000 1000000000000 100000000000 10000000000 1000000000 100000000 10000000 1000000 100000 10000 1000 100 10 standard> }
            when '10000000000000000000' { <10000000000000000000 1000000000000000000 100000000000000000 10000000000000000 1000000000000000 100000000000000 10000000000000 1000000000000 100000000000 10000000000 1000000000 100000000 10000000 1000000 100000 10000 1000 100 10 standard> }
            when 'accounting'           { <accounting standard> }
            default                     { <standard> }
          }

          TYPE:
          for @types-to-try -> $alt-type {

            my @counts-to-try = $count eq 'other'
                                  ?? ($count,'other')
                                  !! ($count,);

            for @counts-to-try -> $alt-count {
              if %pattern-db{$alt-language}{$alt-format}{$alt-system}{$alt-length}{$alt-type}{$alt-count}:exists {
                %pattern-db{$language}{$format}{$system}{$length}{$type}{$count} :=
                  %pattern-db{$alt-language}{$alt-format}{$alt-system}{$alt-length}{$alt-type}{$alt-count};
                last LANGUAGE;
              }
            }
          }
        }
      }
    }
  }

  return %pattern-db{$language}{$format}{$system}{$length}{$type}{$count};

}




sub load-patterns($language) {
  for %?RESOURCES{"NumberPatterns/{$language}.data"}.lines {
    given .split(":",6) {
      #                     formatsystemlength type  count            pattern id
      %pattern-db{$language}{.[0]}{.[1]}{.[2]}{.[3]}{.[4]} := @patterns[.[5]];
    }
  }
}

multi sub get-numeric-symbols( 'root', :$system = "latn") {
  %numeric-systems<root>{$system}
}
multi sub get-numeric-symbols(Str() $language, :$system = "") {
  # TODO if the language tag includes a -u subtag that indicates numeric system
  # then :$system should be ignored.

  return %numeric-systems{$language}{$system}
      if (%numeric-systems{$language}:exists)
      && (%numeric-systems{$language}{$system}:exists);

  # If a requested combination reaches this point, there is a high probability
  # that it will be requested again.  So (1) we attempt to determine the system
  # that should be used, and (2) bind the result to the requested combination's
  # value, to shortcircuit the process in the future with minimal extra
  # overhead. This is particular necessary if a code like 'es-Hebr-ES-x-foo'
  # requests symbols for 'arab'.  We check in the following order:
  #    1. es-Hebr-ES-x-foo exists? NO,  remove a subtag
  #    2. es-Hebr-ES-x     exists? NO,  remove a subtag
  #    3. es-Hebr-ES       exists? NO,  remove a subtag
  #    4. es-Hebr          exists? NO,  remove a subtag
  #    5. es               exists? YES, check with system
  #    6. es + arab        exists? NO,  check the default (es+latn)
  #    7. es + latn        exists? YES  use.
  #    8. root + latn      (if es+latn did not exist)

  my @subtags = $language.split(':');

  while @subtags {
    last if %numeric-systems{@subtags.join(':')}:exists;
    @subtags.pop;
  }

  my $alt-language = @subtags ?? @subtags.join(':') !! 'root';
  my $alt-system;

  if %numeric-systems{$language}{$system}:exists {
    my $alt-system = $system;
  } else {
    $alt-system = 'latn' unless $alt-system = get-default-number-system($alt-language);
  }

  # Bind to the best match and return implicitly
  %numeric-systems{$language}{$system} := %numeric-systems{$alt-language}{$alt-system};
}

sub get-default-number-system($language) {
  return %default-systems{$language} if %default-systems{$language}:exists;
  my @subtags = $language.Str.split(':');
  while @subtags {
    last if %default-systems{@subtags.join(':')}:exists;
    @subtags.pop;
  }
  my $alt-language = @subtags ?? @subtags.join(':') !! 'root';
  %default-systems{$language} := %default-systems{$alt-language};
}

# The standard says that the padding may come before/after the prefix/suffix
# but in reality, it makes more sense to describe it as before/after the number,
# as a prefix/suffix may not otherwise be present.


sub format-xfix(@text, %symbols is copy) {
  @text.map({
      $^t<exact>:exists
        ?? $^t<exact>
        !! %symbols{$^t<replace>}
  }).join
}

sub format-symbols($text, %symbols is copy, $system? = 'latn') {
  %symbols<0 1 2 3 4 5 6 7 8 9> = %decimal-systems{$system};
  $text.comb.map({%symbols{$_}:exists ?? %symbols{$_} !! $_}).join;
}


# This sub is not intended for general use, but some developers may want to use
# it so it is exported
sub format-decimal ($number, $pattern, %symbols, $system) is export {
  my $sign = $number >= 0 ?? 'positive' !! 'negative';
  my %p;
  # the format-number already converts this to a pattern, so this may be
  # unnecessary, depending on how likely it is for people to call this directly
  if $pattern ~~ Str {
    %p = parse-pattern($pattern).{$sign};
  } elsif $pattern ~~ LazyFormat {
    %p := $pattern.format.{$sign};
  }else {
    %p := $pattern{$sign};
  }


	my $string = $number.abs.Str;

  if %p<minimum-exponent-digits> > 0 {
    my $rounded = sig-digits($number,%p<minimum-significant-digits>, %p<maximum-significant-digits>);
    my $digits = $number.abs.log10.ceiling;
    my $exponent;
    if %p<maximum-integer-digits> {
      # Min is assumed to be one per TR35
      $exponent = (($digits - 1) / %p<maximum-integer-digits>).floor * %p<maximum-integer-digits>;
    } else {
      $exponent = $digits -  %p<minimum-integer-digits>;
    }
    # TODO special case 0
    $string = ($rounded / (10 ** $exponent)) # mantissa
                ~ 'E' # will be localized later
                ~ (%symbols<+> if %p<plus-sign> && $exponent >= 0)
                ~ (%symbols<-> if $exponent < 0)
                ~ ( '0' x (%p<minimum-exponent-digits> - $exponent.abs.chars)) # zero padding
                ~ $exponent.abs; # +/- handled above

  } elsif %p<minimum-significant-digits> > 0 {
    $string = significant-digits($string, %p<minimum-significant-digits>, %p<maximum-significant-digits>)
  } else {
    my ($integer,$fraction) = $string.split('.');
    $integer = do given $integer.chars {
      when * < %p<minimum-integer-digits> {
        $integer  = ('0' x (%p<minimum-integer-digits> - $_)) ~ $integer
      }
      when * > %p<maximum-integer-digits> {
        $integer.chars, %p<maximum-integer-digits>; $integer.substr(*  - %p<maximum-integer-digits>)
      }
      default { $integer }
    }
    if $fraction && %p<maximum-fraction-digits> {
      given $fraction.chars {
        # If rounding needed, convert to decimal, round to the number of digits, (implicit str) then chop off the "0."
        when * > %p<maximum-fraction-digits> { $fraction  = (".$fraction").round(0.1 ** %p<maximum-fraction-digits>).substr(2) }
        when * < %p<minimum-fraction-digits> { $fraction ~= '0' x (%p<minimum-fraction-digits> - $_) }
      }
      $string = $integer ~ '.' ~ $fraction;
    } else { # no fraction
      $string = $integer;
    }
  }

  # Per TR35, grouping is ignored for exponential formats
  unless %p<minimum-exponential-digits> {
  	my ($integer,$fraction) = $string.Str.split('.');

  	if $fraction && %p<fractional-grouping-size> {
  		$fraction.comb(%p<fractional-grouping-size>).join: %p<grouping-separator>;
  	}

  	# TODO check if grouping is allowed (can't be defined in patterns)
  	my $integer-grouped = "";

  	if $integer.chars > %p<grouping-size> != 0 {
  		$integer-grouped = $integer.substr(* - %p<grouping-size>);
  		$integer          .= substr(0, * - %p<grouping-size>);
  	}

  	while $integer.chars > %p<secondary-grouping-size> {
  		$integer-grouped = $integer.substr(* - %p<grouping-size>) ~ ',' ~ $integer-grouped;
  		$integer        .= substr(0, * - %p<secondary-grouping-size>);
  	}

  	# Add left over digits
    if $integer-grouped {
      # left over digits and we are doing grouping, add a final one
      $integer-grouped = $integer ~ (',' ~ $integer-grouped if $integer && %p<secondary-grouping-size> != 0);
    } else {
      # we've not added anything yet so no need for a grouper
      $integer-grouped = $integer;
    }
    $string = $integer-grouped ~ (".$fraction" if $fraction)
  }

  format-xfix(%p<prefix>,%symbols)
    ~ format-symbols($string,%symbols,$system)
    ~ format-xfix(%p<suffix>,%symbols);
}


# TODO rename these subs intelligently
sub sig-digits($number,$minimum = 1,$maximum = ∞) {
  return $number if $maximum == ∞;
  my $current-digits = $number.abs.log10.ceiling;
  my $power = $maximum - $current-digits;
  my $magnitude = 10 ** $power;
  my $shifted = ($number * $magnitude).round;
  return $shifted / $magnitude
}
multi sub significant-digits (0, $minimum = 1, $?) {
  "0" ~ ('.' unless $minimum == 1) ~ ("0" x ($minimum-1))
}
multi sub significant-digits($number,$minimum = 1,$maximum = ∞) {
  return $number if $maximum == ∞; # TODO quickfix, should pad out zeros still
  my $current-digits = $number.abs.log10.ceiling;
  my $power = $maximum - $current-digits;
  my $magnitude = 10 ** $power;
  my $shifted = ($number * $magnitude).round;
  # If there are trailing 0s, then we need to add them.  This is an additional step
  # that isn't contemplated in most algorithms found online.
  my $result = ($shifted / $magnitude).Str;
  # Count the digits (anything that's not a - or .)
  my $final-digits = $result.comb.grep(* ne '.' | '-' ).elems;
  $result ~ (
              (
                ("." unless $result.contains('.')) # in case integer
                ~ ('0' x $minimum - $final-digits)
              ) if $final-digits < $minimum
            );
}


#say format-decimal(π);
#say Pattern.parse("*-f¤''oo0;k#")
