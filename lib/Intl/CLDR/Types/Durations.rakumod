#| A class implementing CLDR's <durationUnit> element, which
#| contains information about formatting durations of time.
unit class CLDR::Durations;
    use Intl::CLDR::Core;
    also is CLDR::Item;

has Str $.hm  is built;  #= Hours and minutes
has Str $.ms  is built;  #= Minutes and seconds
has Str $.hms is built;  #= Hours minutes and seconds

#| Creates a new CLDR::Durations object
method new(\blob, uint64 $offset is rw --> ::?CLASS) {
    use Intl::CLDR::Util::StrDecode;
    my $hm  = StrDecode::get(blob, $offset);
    my $ms  = StrDecode::get(blob, $offset);
    my $hms = StrDecode::get(blob, $offset);

    self.bless: :$hm, :$ms, :$hms;
}

#`<<<<<# GENERATOR: Use toggle-generators.raku to [dis|en]able this code.
method encode(%*durations) {
    use Intl::CLDR::Util::StrEncode;
    my $result = buf8.new;

    $result ~= StrEncode::get(%*durations<hm>  // '');
    $result ~= StrEncode::get(%*durations<ms>  // '');
    $result ~= StrEncode::get(%*durations<hms> // '');

    $result
}
method parse(\base, \xml) {
    use Intl::CLDR::Util::XML-Helper;
    base{xml<type>} = contents $_ with xml.&elem('durationUnitPattern');
}
>>>>># GENERATOR