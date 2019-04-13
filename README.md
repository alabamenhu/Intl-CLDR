# CLDR for Perl 6

An attempt to bring in the data from CLDR into Perl 6.  Support is extremely
early, and currently only brings in support for one bit of CLDR data:
list formatting.   To use:

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

Currently only decimal formatting is supported, although percentage / scientific /
currency formatting will be soon supported.  If the language tag includes any
`-u` subtags they will not honored presently, but such support is planned.
**WARNING** the interface is not stable yet and may change.

```perl6
use Intl::CLDR::Numbers;
format-decimal($number);
```

There are a few different options for the formatting:

  * **:language**  
  A BCP47 compliant language tag or `LanguageTag` object.  

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

# Version History
  * 0.2.1
  * Added support for Ge'ez numerals.  
  * Added support for Roman numerals.  
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
