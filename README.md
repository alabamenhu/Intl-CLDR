# CLDR for Perl 6

An attempt to bring in the data from CLDR into Perl 6 and much of the functionality
of ICU as well.  The current module structure should be considered highly experimental.
Pre-1.0 I will aim to keep method names, etc, available with similar interfaces, but the
module used to import them may change.  It's best to add version information to your use statement.

The plan is to eventually spin off most of the ICU-like functionality into their own modules
directly in the `Intl::` namespace, leaving Intl::CLDR exclusively for accessing the more-or-less
raw CLDR data.

## Lists

```perl6
    use Intl::CLDR::Lists;
    say format-list(<apple orange banana>);           # apple, orange, and banana
    say format-list(<apple orange banana> :type<or>); # apple, orange, or banana
```

There are nine types of lists defined in CLDR (example from `en`):

  * **and**, **standard-short**, **standard-narrow**   
  1, 2, and 3  
  In English, this includes a comma.  Not all languages will have a dividing element
  between the final two.  CLDR does not use the word 'and' or 'standard': it is
  just the default, nameless form.  The *short* version in some languages
  is a bit more space economical and the *narrow* version is even more
  economical.  (Some Asian languages may remove spaces, for instance).  If
  *narrow* is not defined, falls back to *short*, which falls back to *and*.
  * **or**, **or-short**, **or-narrow**   
  1, 2, or 3
  In English, includes a final comma.  Not all languages will have a dividing
  element between the final two.  The *short* version in some languages
  is a bit more space economical and the *narrow* version is even more
  economical.  (Some Asian languages may remove spaces, for instance).  If
  *narrow* is not defined, falls back to *short*, which falls back to *or*.
  * **unit**, **unit-short**, **unit-narrow**  
  1, 2, 3  
  The unit version is a list that lists without prejudice (neither *and* nor *or*).  
  For most languages, this entails a delimiter between each and every item, but
  no text at the end.  The *short* version in some languages
  is a bit more space economical and the *narrow* version is even more
  economical. If *narrow* is not defined, falls back to *short*, which falls
  back to *unit* which falls back to *and*.

You may optionally pass a list of languages to be processed using `:language`
(only one language) or `:languages` (one or more) adverb:

```perl6
    say format-list(<manzana naranja plátano> :language<es>);
    # ↪︎ "manzana, naranja y plátano"
```

If no language is specified, uses `UserLanguage` to get the user's default
language preferences, and ultimately falls back to English if no better match
can be found.

## Plurals

```perl6
    use Intl::CLDR::Plurals;
    say plural-count(0, "en"); # other
    say plural-count(1, "en"); # one
    say plural-count(2, "en"); # other
```

There are six possible responses that can be retrieved from the `plural-count`
method: **zero**, **one**, **two**, **few**, **many**, **other**.  Most languages
support *one* and *other*, but some will only ever return *other* because they
do not have numeric concord.  Other more complicated ones will use all of the
ones listed.  The logic is unique to each language and will be done by
the localizer, but will be fairly opaque to the programmer and should not generally
be used upon outside of localization frameworks.

## Numbers

Easy to use number formatter.  

```perl6
use Intl::CLDR::Numbers;
format-decimal($number);
```

There are several modes of formatting currently supported beyond the standard
decimal, which can be activated adverbially

  * **:percent**  
  Multiplies by 100 and displays using a percentage sign.
  * **:scientific**  
  Uses exponential formatting, so 2019 would be 2.019E3.
  * **:engineering**  
  Uses exponential formatting, but limits the exponential values to powers of 3.
  * **:short**
  Uses extremely compact forms for numbers over 1000.  For example, 2019 is 2K,
  and 123456789 is 123M.
  * **:long**  
  Same as :short, but spells out the rounded number.  2019 is *2 thousand*, and
  123456789 is *123 million*.  Falls back to `:short` if there is no CLDR data
  for the given language.

There are also few different options for the formatting:

  * **:language**  
  A BCP47 compliant language tag or `LanguageTag` object.  If you pass a number
  system via the `-u` tag it is not currently respected.
  * **:pattern**  
  A number formatting pattern.  Its format is too complex to describe here, but
  there is a decent description in the [TR35 standard](https://unicode.org/reports/tr35/tr35-numbers.html#Number_Format_Patterns).
  Using this will not override the symbols used by the chosen language.
  * **:system**  
  Change the default numbering system which affects the symbols used and the
  digits employed.  Most languages only support a single system,
  but some may support two or three if they use several traditionally.  If a
  system isn't supported, falls back to the default system for symbols, but
  will employee the correct digits.  So for English, `format-number(1234235, :system<nkoo>)` returns
  *߁,߂߃߄,߂߃߅*.   
  * **:symbols**  
  Defines the symbols to use for formatting (the decimal indicator, etc).
  Currently has a not-easy-to-use format which will be simplified in the future.
  * **:count**  
  Some of the formats for numbers may change based on the exact number they have.
  If passed, this setting is respected, but plural rules are not *currently*
  respected though that will change in the future.  Valid values are those
  from `Intl::CLDR::Plurals` (*zero, one, two, few, many, other*).

While formatting should be fine when using default options, if you try to get
fancy, things may currently break until I can better handle certain edge cases.

Lastly, there is support for localized number mining.  While
we all have used `\d+` to try to find numbers, now you can use a localized
number token in your grammars.  Here's a quick example:

```perl6
grammar CleanupNoise {
  use Intl::CLDR::Numbers::Finder;  # ⬅ imports the token <local-number>
  token TOP   { <noise> <local-number> <noise> }
  token noise { <[a..zA..Z]>*? }
}

class CleanupNoiseActions {
  use Intl::CLDR::Numbers::Finder;
  also does Local-Numbers;  # ⬅ mixes in the method local-number();
  token TOP { make <local-number>.made }
}
say CleanupNoise.parse("asdasd1.2345E3ewreyrhhb", :args(\(%symbols))).made
# ↪︎ 1234.5  (it extracted 1.2345E3, or 1.2345 x 10³)
```

The <local-number> will default to the language obtained via UserLanguage.  If you'd
like to override the language chosen, you can simply pass the language to the
token, that is, `<local-number("ar")>"` to extract numbers in Arabic documents.

If you attach the actions via the mixed in role, the `.made` will be the value of the
number (generally Int or Rat).  In the future, I may attach additional information
(for example, if it was exponential, number of digits if zero-padded, etc) through mixins,
but for now if you want that information, you can create your own `local-number($/)` method.
The `Match` it receives should be fairly easy to understand.

## NumberSystems

Some of the algorithmic systems may be eventually spun off into different modules
because they *technically* are not defined in CLDR, just referenced.  There is
no generalized method of converting numbers yet, but I imagine the syntax will
be something like
```perl6
use Intl::CLDR::Numbers;
format-number(63, :system<ge'ez>); # ፷፫
format-number(35, :system<roman>); # XXXV
```
Different systems may have different options as well.  For right now, you can
play around with the implemented systems by using their specific modules:

```perl6
use Intl::CLDR::NumberSystems::Ge'ez;
ge'ez-numeral(48253683); # ፵፰፻፳፭፼፴፮፻፹፫
use Intl::CLDR::NumberSystems::Roman;
roman-numeral(168);                  # CLXVIII
roman-numeral(168) :j;               # CLXVIIJ (used often in medieval times)
roman-numeral(44) :additive<all>;    # XXXXIIII (most traditional)
roman-numeral(44) :additive<single>; # XLIIII (used longer)
roman-numeral(44) :additive<none>;   # XLIV, default (shouldn't be, but it's what
                                     # people today expect)
```

I haven't yet decided how best to handle numbers that can't be represented in
a given system.  Many of the older numbering systems do not allow for fractional
(less than one) values.  At the moment, these are `floor`ed and then converted.

Some options:

 * **`:fractional`** enables fraction approximation (to the 1/1728) for Roman
 numerals.  These don't case well, so a casing option may be needed in the future.
 * **`:j`** enables terminal *J* instead of *I* in Roman numerals.  These were used
frequently in medieval times.
 * **`:additive`** adjusts the properties for converting 4 and 9.  The allowed
 values are `all` (traditional, 4 is IIII, 9 is VIII, 40 is XXXX, etc), `small`
 (only 4 and 9 are added) or `none` (default, which it shouldn't be but it's
 what people today expect)
 * **`:large`** enables (preliminary) support for numbers larger than 3999 (or
   4999 if `:additive<all>`).  Because there were many ways of doing this,
   there are probably more options than necessary.  Defaults to False.

## Genders

CLDR contains some data about the way that languages combine genders.  This data
is only for combining *people* and not arbitrary objects.  To use, there are
three enum values, `Male`, `Female`, and `Other`.  Pass a list of these enums to
`group-gender`, followed by an appropriate language tag.  Currently requires a
language tag to be passed.  The result is the gender (in plural) that should be used
with the group.  (`Other` is the CLDR terminology, in many languages it might be
referred to as *neuter*)



# Version History
  * 0.4.1
    * Greatly improved support for a <local-number> token.
    * Added support for Genders (only people, as that's what CLDR data has).
  * 0.4.0
    * Initial support for importing all CLDR data into a single repository in `Intl::CLDR`
      * DateTime formatting currently uses it.
      * Number / list formatting will be updated in the near future to use it (they still maintain their own separate database ATM)
      * Not all languages are fully supported because I'm too lazy to manually add them all to the META6 file (I'll eventually automate it)
  * 0.3.0
    * Added support for formatting numbers of all types in the CLDR except for currency.
    * Added preliminary support for finding localized numbers in grammars.
  * 0.2.1
    * Added preliminary support for Ge'ez numerals.  
    * Added preliminary support for Roman numerals.  
  * 0.2.0
    * Added support for cardinal plural count.
      * Ordinal *should* be working but there's a bug somewhere
  * 0.1.0  
    * First working version.  Support for list formatting.  

# License

The resources directory "main" comes directly from the Unicode CLDR data.
These files are copyrighted by Unicode, Inc., and are available and distributed
in accordance with [their terms](http://www.unicode.org/copyright.html).

Everything else (that is, all the Perl code), is licensed under the Artistic License (see license file).
