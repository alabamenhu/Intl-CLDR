![The Cippi of Melqart with a white butterfly resting atop the words Intl::CLDR for Raku](docs/logo.png)

> *¿Cómo se diz na vuestra, na nuestra llingua, la palabra futuru?*  
— Lecciones de gramática (Berta Piñán)

# Intl::CLDR
An attempt to bring in the data from CLDR into Raku. 

As of **v0.5.0**, performance was vastly improved but some slight API changes were needed.
Always ensure to use a version statement.  (at least until v.1.0)

To install, be aware that due to the number of files, you may need to increase the maximum number of open files (on most systems, the default is several thousand, but on macOS, it's a paltry 256).

```
> ulimit -n 4096
> zef install Intl::CLDR
```

## CLDR objects

Each `CLDR::*` object is `Associative`, and attributes can generally be accessed both from 
hashy accessors (`{'foo'}`) or method/attribute accessors (`.foo`).
True attributes are defined with kebab-case, but camel-case alternates are available as well (this is because CLDR began with camel case, and now tends to prefer kebab-case, and it's hard to remember when to use which).  

## Other thoughts

Because CLDR is designed to be stable, they have had to make some odd design choices for legacy compatibility.
An obvious example of this is the `<codePatterns>` vs `<localeDisplayPattern>` that really logically should go together.
This also happens with the `dateFormats`, `timeFormats`, and `dateTimeFormats`.
The latter three are currently organized exactly as in CLDR, but I may rearrange these simply to provide a more convenient/logical method of accessing things (e.g. `calendar.formats<time date datetime interval>`).

# Version History
  * 0.7.3
    * Removed embarrassing hold over of `Immutability.pm6`
  * 0.7.2 
    * Readded numbering system aliases for `CLDR::Symbols`
  * 0.7.1
    * Fixed data generation bug (users of 0.7.0 should update and recompile modules dependent on `Intl::CLDR` for correct data handling)
  * 0.7.0
    * CLDR update to v42.0
    * Completely refactored module files
      * Better long term maintenance 
      * Lower run-time overhead
    * Module reorganized 
      * Various tools moved out of `/resources` into `/tools`
    * Language loading no longer relies on hacky `%?RESOURCES` existence check, instead uses foreknowledge of processed language files.
    * New feature
      * Initial timezone data added
        * `CLDR::WindowsTimezone` (from `<windowsZones>`) to convert Windows' timezone IDs to Olson IDs
        * Forthcoming: `CLDR::Metazone` (from `<metaZone>`) converts Olson IDs to notional zones
  * 0.6.0
    * CLDR update to v39.0
    * New features
      * Added language-agnostic `CLDR::Supplement`.  Accessed via `CLDR.supplement.subdivisions`
        * Support for `<subdivisions>` tag (provides data to be fed into main language data classes)
      * Support for supplemental-ish `<grammaticalDerivations>` added (`<grammaticalFeatures>` NYI).
      * Version attributes
        * Use `CLDR.module-version` to get the current module version (currently `v0.6.0`)
        * Use `CLDR.cldr-version` to get the version of the CLDR database used (currently `v38.1`)
    * Minor changes
      * Removed redundant measurement type prefix from units (e.g. **meter** instead of **length-meter**).  
      * Hash-y access for `CompoundUnitSet::Selector`
    * Bug fixes
      * Long/narrow display-name/per-unit patterns for simple units were swapped.
      * Fixed encoding for exemplar characters that incorrect `.ellipses` and `.more-info` values to appear in `CLDR::Characters`
      * Locale display patterns `<localePattern>` (`.main`), `<localeSeparator>` (`.separator`), and `<localeKeyTypePattern>` (`.extension`) are now properly encoded
    * Code improvements
      * Transition from using the `CLDR-ItemNew` in `Immutability.pm6` (a holdover from pre-v0.5) to using `CLDR::Item` in `Core.pm6`
      * Use `CLDR::Type` instead of `CLDR-Type`
      * Use `is aliased-by` instead of `detour`
      * Use `is built` and similar instead of `!bind_init`
      * Cleaner handling of cases in `Units.pm6` (to be mirrored in other similar files in subsequent updates)
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
