unit class CLDR::AppendItems;

use       Intl::CLDR::Core;
also does CLDR::Item;

###################################################
# > Some of these append items aren't in the wild #
# yet, but they are contemplated in the standard. #
# So, e.g., the hour / minute will probably be    #
# blank in most cases.                            #
# > For some weird reason, CLDR uses Pascal-Kebab #
# case for these items.                           #
###################################################

has Str $.era              is aliased-by<Era>;
has Str $.year             is aliased-by<Year>;
has Str $.quarter          is aliased-by<Quarter>;
has Str $.month            is aliased-by<Month>;
has Str $.week             is aliased-by<Week>;
has Str $.week-of-month    is aliased-by<Week-Of-Month>;
has Str $.day              is aliased-by<Day>;
has Str $.day-of-year      is aliased-by<Day-Of-Year>;
has Str $.weekday          is aliased-by<WeekDay>;
has Str $.weekday-of-month is aliased-by<Weekday-Of-Month>;
has Str $.dayperiod        is aliased-by<Dayperiod>;
has Str $.hour             is aliased-by<Hour>;
has Str $.minute           is aliased-by<Minute>;
has Str $.second           is aliased-by<Second>;
has Str $.timezone         is aliased-by<Timezone>;

#| Creates a new CLDR-Dates object
method new(\blob, uint64 $offset is rw --> ::?CLASS) {
    use Intl::CLDR::Util::StrDecode;
    self.bless:
        era              => StrDecode::get(blob, $offset),
        year             => StrDecode::get(blob, $offset),
        quarter          => StrDecode::get(blob, $offset),
        month            => StrDecode::get(blob, $offset),
        week             => StrDecode::get(blob, $offset),
        week-of-month    => StrDecode::get(blob, $offset),
        day              => StrDecode::get(blob, $offset),
        day-of-year      => StrDecode::get(blob, $offset),
        weekday          => StrDecode::get(blob, $offset),
        weekday-of-month => StrDecode::get(blob, $offset),
        dayperiod        => StrDecode::get(blob, $offset),
        hour             => StrDecode::get(blob, $offset),
        minute           => StrDecode::get(blob, $offset),
        second           => StrDecode::get(blob, $offset),
        timezone         => StrDecode::get(blob, $offset),
}

#`<<<<<# GENERATOR: Use toggle-generators.raku to [dis|en]able this code.
method encode(\hash) {
    use Intl::CLDR::Util::StrEncode;
    my $result = buf8.new;

    for <Era Year Quarter Month Week Week-Of-Month Day Day-Of-Year Weekday
          Weekday-Of-Month Dayperiod Hour Minute Second Timezone> -> $type {
        $result ~= StrEncode::get(hash{$type} // '');
    }
    $result;
}
method parse(\base, \xml) {
    use Intl::CLDR::Util::XML-Helper;
    base{.<request>} = contents $_ for xml.&elems('appendItem');
}
>>>>># GENERATOR