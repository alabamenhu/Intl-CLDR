unit module RomanNumerals;

# There are countless ways to convert decimals to Roman numerals.  The method
# used here allows for easier manipulation of the many different options
# available for creating them (particularly once apostrophus/etc is supported)

multi sub roman-numeral($number where 0, :$j = False, :$additive = 'none', :$level where * > 0) { '' }
multi sub roman-numeral($number is copy, :$fractional = False, :$j = False, :$additive = 'none') is export {
	return 'nulla' if $number == 0;
  die if $number > ($additive eq 'all' ?? 4999 !! 3999);
	my $offset = $number.Int % 10;
	samewith($number.Int - $offset, :$j:$additive:10level)
	~ ($additive eq 'none'
		?? ($j
			?? ("", |<J IJ IIJ   IV V IV VIJ VIIJ    IX>)[$offset]
			!! ("", |<I II III   IV V IV VII VIII    IX>)[$offset])
		!! ($j
			?? ("", |<J IJ IIJ IIIJ V IV VIJ VIIJ VIIIJ>)[$offset]
			!! ("", |<I II III IIII V IV VII VIII VIIII>)[$offset]))
	~ (roman-fraction($number - $number.Int) if $fractional)
}
multi sub roman-numeral($number where * != 0, :$j = False, :$additive = 'none', :$level where 10) {
	my $offset = ($number % 100);
	samewith($number - $offset, :$j:$additive:100level)
	~ ($additive eq 'all'
    ?? ("", |<X XX XXX XXXX L LX LXX LXXX LXXXX>)[$offset / 10]
		!! ("", |<X XX XXX   XL L LX LXX LXXX    LC>)[$offset / 10])
}
multi sub roman-numeral($number where * != 0, :$j = False, :$additive = 'none', :$level where 100) {
	my $offset = ($number % 1000);
	samewith($number - $offset, :$j:$additive:1000level)
	~ ($additive eq 'all'
    ?? ("", |<C CC CCC CCCC D DC DDC DCCC DCCCC>)[$offset / 100]
		!! ("", |<C CC CCC   CD D DC DDC DCCC    CM>)[$offset / 100])
}
multi sub roman-numeral($number where !(* % 1000), :$j = False, :$additive = 'none', :$level where 1000) {
	my $offset = ($number % 10000);#X̅ L̅ C̅ D̅ M̅
	#decimal-to-roman($number - $offset, :$j:$additive:10000level) ~
	return ($additive eq 'all'
    ?? ("", |<M MM MMM MMMM V̅ V̅M V̅MM V̅MMM V̅MMMM>)[$offset / 1000]
		!! ("", |<M MM MMM   MV̅ V̅ V̅M V̅MM V̅MMM    MX̅>)[$offset / 1000])
}


sub roman-fraction($number is copy) {
	warn "Roman Fractions best if multiple of 1/1728" if ($number + 1/1728).nude[1] > 1728;
	my $return = '';
	while $number > 1/1728 {
		say $number;
		do {$return ~= 'S'; $number -= 1/2 }   if $number >=  1/2;
		do {$return ~= '⁙'; $number -= 5/12}   if $number >=  5/12;
		do {$return ~= '∷'; $number -= 4/12}   if $number >=  4/12;
		do {$return ~= '∴'; $number -= 3/12}   if $number >=  3/12;
		do {$return ~= ':'; $number -= 2/12}   if $number >=  2/12;
		do {$return ~= '·'; $number -= 1/12}   if $number >=  1/12;
		do {$return ~= '𐆒'; $number -= 1/24}   if $number >=  1/24;
		do {$return ~= 'Ɔ'; $number -= 1/48}   if $number ==  1/48;
		do {$return ~='𐆓𐆓'; $number -= 1/36}   if $number >=  1/36;
		do {$return ~= '𐆓'; $number -= 1/72}   if $number >=  1/72;
		do {$return ~= '𐆔'; $number -= 1/144}  if $number >= 1/144;
		do {$return ~= '℈'; $number -= 1/288}  if $number  >= 1/288;
		do {$return ~= '𐆕'; $number -= 1/1728} if $number >= 1/1728;
	}
	$return;
}
