unit module Genders;
use Intl::BCP47;

# The way that the CLDR data is stored for this, it only pertains to *people's* gender.
# This is why the function is named *people-gender* and not *list-gender*, although that
# function would be equally interesting for some localization frameworks.

enum Gender <Other Female Male>;
# Other genders may be included if, e.g., a third gender need to treated separately from "Other".
# I use the term "Other" to align with CLDR's terminology.  Generally, most languages refer to
# "Other" as neuter, but for languages without grammatical gender, "Other" is just default.


# Right now, does not enforce Gender type on the input.  This should change and throw an error.

subset Plural-Gender-Neutral of LanguageTag where .canonical.starts-with(
  any <af bn bg da de en et eu fa fil fi gu hu id ja kn ko ml ms no sv sw ta te th tr vi zu>
);

subset Plural-Gender-Mixed-Neutral of LanguageTag where .canonical.starts-with(
  any <el is>
);

subset Plural-Gender-Male-Taints of LanguageTag where .canonical.starts-with(
  any <ar ca cs hr es fr he hi it lt lv mr nl pl pt ro ru sk sl sr uk ur zh zh-Hant>
);


multi sub people-gender(@list, Plural-Gender-Mixed-Neutral $) is export {
  return @list.head if @list.all eq @list.head;
  Other
}
multi sub people-gender(@list, Plural-Gender-Mixed-Neutral $) is export {
  return @list.head if @list.all eq @list.head;
  Male
}
multi sub people-gender(@list, LanguageTag $) is export {
  Other
}
