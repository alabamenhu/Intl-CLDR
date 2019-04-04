% CLDR for Perl 6

An attempt to bring in the data from CLDR into Perl 6.  Support is extremely
early, and currently only brings in support for one bit of CLDR data:
list formatting.   To use:

```perl6
    use Intl::CLDR::Lists;
    say format-list(<apple orange banana>);           # apple, orange, and banana
    say format-list(<apple orange banana> :type<or>); # apple, orange, or banana
```

There are nine types of lists defined in CLDR (example from `en`):

  * **and**  
  1, 2, and 3  
  In English, this includes a comma.  Not all languages will have a dividing element
  between the final two.  CLDR does not use the word 'and', this is just the
  default, nameless form.  This form can also be called 'standard' in Perl 6.
  * **standard-short**  
  1, 2, and 3
  In English, this also includes a comma.  Some languages may have a way to save
  a bit of space, perhaps by foregoing a final divider.
  * **standard-narrow**  
  1, 2, and 3
  In English, same as the previous.  But some languages may forego spaces to
  save an extreme amount of space.
  * **or**  
  1, 2, or 3
  In English, includes a final comma.
  * **or-short**  
  1, 2, or 3
  In English, same as standard or.  Some languages may be slightly more
  economical with respect to space than the standard or.
  * **or**  
  1, 2, or 3
  In English, same as standard or.  Some languages may be able to greatly
  reduce the space by, e.g., removing spaces.
  * **unit**  
  1, 2, 3  
  The unit version is a list that does not contemplate union or exclusivity.  
  For most languages, this entails a delimiter between each and every item, but
  no text at the end.
  * **unit-short**  
  1, 2, 3
  In English there is no difference, but in other languages, this may be
  slightly more economical in space than the main unit.
  * **unit-narrow**  
  1 2 3  
  Same as before, but with an extreme space minimization.  For most languages
  that will be just a space, but for some that may mean no space at all!

You may optionally pass a list of languages to be processed using `:languages`
parameter.  Note that if no list data is found, it will currently fall back
to English.

% Installation warning

On install with `zef`, the locale data is slurped up.  XML processing in Perl 6
is not exceptionally fast, and processing all 750 something languages takes time.
(No, really.  Go watch a TV show.  I'll speed it up eventually, somehow).
It is set to use `hyper` so multiprocessor machines should see some speed up.
This is ONLY done ONCE.

% Version History
  * 0.1.0  
    * First working version.  Support for list formatting.  

% License

The resources directory "main" comes directly from the Unicode CLDR data.
These files are copyrighted by Unicode, Inc., and are available and distributed
in accordance with [their terms](http://www.unicode.org/copyright.html).

Everything else (that is, all the Perl code), is licensed under the Artistic License (see license file).
