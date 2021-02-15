![The Cippi of Melqart with a white butterfly resting atop the words Intl::CLDR for Raku](docs/logo.png)

> *¿Cómo se diz na vuestra, na nuestra llingua, la palabra futuru?*  
— Lecciones de gramática (Berta Piñán)

# Intl::CLDR
An attempt to bring in the data from CLDR into Raku. 

The newest version (**v0.5**) aims to maintain functionality but vastly improve performance, both
mainly from a speed perspective, but also improves memory efficiency and will aide long term maintenance.

There have been slight API changes from previous versions, so as noted before, if using, please
ensure that you add version information to your use statements (at least until v.1.0);

**Do not** use anything outside of the Intl::CLDR from this branch.
Those functionalities are in the process of being spun off into their own modules.
This is primarily for obtaining more-or-less raw data with proper fallbacks.

To install, be aware that due to the number of files, you may need to increase the maximum number of open files (on most systems, the default is several thousand, but on macOS, it's a paltry 256).

```
> ulimit -n 4096
> zef install Intl::CLDR
```

## CLDR objects

Each `CLDR-*` object is a subclass of `Hash`, and attributes can generally be accessed both from 
hashy accessors (`{'foo'}`)or method/attribute accessors (`.foo`).
True attributes are defined with kebab-case, but camel-case alternates are available as well (this is because CLDR began with camel case, and now tends to prefer kebab-case).  

## Other thoughts

Because CLDR is designed to be stable, they have had to make some odd design choices for legacy compatibility.
An obvious example of this is the `<codePatterns>` vs `<localeDisplayPattern>` that really logically should go together.
This also happens with the `dateFormats`, `timeFormats`, and `dateTimeFormats`.
The latter three are currently organized exactly as in CLDR, but I may rearrange these simply to provide a more convenient method of accessing things (e.g. `calendar.formats<time date datetime interval>`)

# Version History
  * 0.5.2 (planned) 
    * Support for supplemental `<grammaticalFeatures>` and `<grammaticalDerivations>`.
  * 0.5.1
    * Updated `DecimalFormatSystem`, `CurrencyFormatSystem` and `ScientificFormatSystem` to support Hash-y access.
    * Pulled out `Intl::Format::Numbers` into its own module (as `Intl::Format::Number`)
    * Fixed an issue with `ExemplarCharacters` pre-processing, which caused a space to be added to every set
    * Pulled out `Intl::CLDR::Plural` into its own module (as `Intl::Number::Plural`)
    * Support for supplemental `<plurals>`.  (Found in new top level unit `Grammar`)
    * Fixed a bug in `SimpleUnitSet` and `CompoundUnitSet` that caused the wrong pattern to be returned
  * 0.5.0
    * Redesigned data structure, and it's all about speed
    * See docs for full details.
    * Pulled out `Intl::Format::DateTime` into its own module
    * Pulled out `Intl::Format::List` into its own module
    * **Not** backwards compatible with v.0.4.3, make sure to specify version in `use` statement
  * 0.4.3
    * Fixed install issues
    * Significant work towards fast attribute access (works on Calendar items)
  * 0.4.2
    * Added some new tokens <local-alpha>, etc.
    * Initial support for format-date and others.
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

The resources directory "cldr-common" comes directly from the Unicode CLDR data.
These files are copyrighted by Unicode, Inc., and are available and distributed
in accordance with [their terms](http://www.unicode.org/copyright.html), which are
also distributed in that directory.

Everything else (that is, all the Raku code), is licensed under the Artistic License 2.0 (see license file).
