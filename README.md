= CLDR for Perl 6

An attempt to bring in the data from CLDR into Perl 6.  Support is extremely
early, and currently only brings in support for one bit of CLDR data:
list formatting.   To use:

```perl6
    use Intl::CLDR::Lists;
    say format-list(<apple orange banana>);           # apple, orange, and banana
    say format-list(<apple orange banana> :type<or>); # apple, orange, or banana
```

There are five types of lists defined in CLDR (example from `en`):

  * **and**  
  1, 2, and 3
  * **or**  
  1, 2, or 3
  * **unit**  
  1, 2, 3
  * **unit-narrow**  
  1 2 3
  * **unit-short**  
  1, 2, 3

= Installation warning

On install with `zef`, the locale data is slurped up.  XML processing in Perl 6
is not exceptionally fast, and processing all 750 something languages takes time.
It is set to use `hyper` so multiprocessor machines should see some speed up.
