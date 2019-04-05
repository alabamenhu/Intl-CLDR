# CLDR for Perl 6

An attempt to bring in the data from CLDR into Perl 6.  Support is extremely
early, and currently only brings in support for one bit of CLDR data:
list formatting.   To use:

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

# Version History
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
