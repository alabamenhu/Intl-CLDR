# Intl::Token::*

The `Token` namespace inside of `Intl` is dedicated to specialized tokens for use in regexen and grammars.

As a rule, they all have a single positional argument that defaults to `user-language` (from `Intl::UserLanguage`).

All other options are provided by named arguments.
The most common named argument is `:broad` (corresponding to CLDR's `lenient` or `auxiliary` or `alternate`), which increases the likelihood of a match, at the cost of potentially capturing information that you don’t want.

## `<local-number: $language?>`
Currently captures anything that looks like a number in the default system for a language, but it is fairly greedy and will automatically capture percents and exponentials.
The `Match` object in number context will interpret the number for you:

```raku
my $match = 'Hay 1.234 kilos de arroz' ~~ / <local-number: 'es'> kilos /;
say +$match<local-number>; # 1234
```

Note in the above example, in Spanish, the `,` is used as the decimal operator, and `.` as the thousands separator, which is opposite to English.
But the token was converted to the correct number and can actually be passed to any function that requires a `Numeric`.

## `<local-alpha: $language?, :$broad>`
This captures anything that corresponds to the local writing system.
In English, for instance, it is equivalent to `<[a..zA..Z]>`, but in German would also capture umlauted letters and the eszett.
For Japanese, the most common 4000 or so characters are included.

Using the `:broad` option will expand the base.
In English, for instance, it's common to write *résumé* or *naïve*, and the `:broad` option will capture other commonly used letters that aren't strictly part of the system.

The characters used are defined in CLDR's exemplary character set (default) and auxiliary character set (broad).

