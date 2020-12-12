![The Cippi of Melqart with a white butterfly resting atop the words Intl::CLDR for Raku](docs/logo.png)

> *¿Cómo se diz na vuestra, na nuestra llingua, la palabra futuru?*  
— Lecciones de gramática (Berta Piñán)

# Intl::CLDR
An attempt to bring in the data from CLDR into Raku.
 
This branch (*zoom-zoom*) aims to maintain functionality but vastly improve performance, both
mainly from a speed perspective, but also improves memory efficiency and will aide long term maintenance.

There have been slight API changes from the old branch, so as noted before, if using, please
ensure that you add version information to your use statements (at least until v.1.0);

**Do not** use anything outside of the Intl::CLDR from this branch.
Those functionalities will be spun off into their own modules.
This is primarily for obtaining more-or-less raw data with proper fallbacks.

For those interested in trying out this branch, focus on the classes in `Intl::CDLR::Types` and the new processing script
`resources/parse-main-file-new.p6`.  

## CLDR objects

Each `CLDR-*` object is a subclass of `Hash`, and attributes can generally be accessed both from 
hashy accessors (`{'foo'}`)or method/attribute accessors (`.foo`).
True attributes are defined with kebab-case, but camel-case alternates are available as well (this is because CLDR began with camel case, and now tends to prefer kebab-case).  
There is a noticeable performance hit because of the initial set up for this, so things may change on this front if I can't find a more efficient way to enable it.


## Mega-rewrite structure

Each new type object (in `Int::CLDR::Types::`) has roughly the same format:

```raku 
use Intl::CLDR::Inmutability; # this name will change

unit class CLDR-Foo is CLDR-Item;

has $.attribute1;
has $.attribute2;

method new(|c) { self.bless!bind-init: |c }

# using !bind-init is a holdover from when all CLDR objects were 
# hashes and could not access the BUILD phase.
submethod !bind-init(\blob, uint64 $offset is rw, \parent) {
    use Intl::CLDR::Classes::StrDecode;
    
    # read data here
    $.attribute = StrDecode::get(blob, $offset);
    
    self
}

# Not all classes use this, but CLDR is inconsistent on capitalization 
# so we enable fallbacks so users can be self-consistent.  The method
# is needed, but the constant makes for easier maintenance.  This may
# eventually end up using a technique similar to Trait::Also
constant detour = Map.new: (altAttributeName => 'attribute');
method DETOUR (--> detour) {}

method parse(\base, \xml) {
    use Intl::CLDR::Util::XML-Helper;
   
    # the base is a Hash and xml is an XML object from the XML module.
    # parsing is fairly open ended, but ideally, each parse phase does
    # only what is at its level and passing off deeper work to other
    # classes. There are a few exceptions, always noted and explained.
}

method encode(%*foo --> buf8) { 
    # a dynamic variable is normally used, in case fallbacks need to refer back
    use Intl::CLDR::Classes::StrEncode;
    
    my $result = buf8.new;
    
    # Generally the 'base' that was produced will be passed in here. 
    # The data should be stored in a binary serial format to be recovered
    # in the !bind-init method.
               
    $result
}
```

Before distribution, the `parse` and `encode` functions will be commented out, as they are not intended for end user use, but make more sense to be packaged with each class for general maintenance / development.

## Other thoughts

Because CLDR is designed to be stable, they have had to make some odd design choices for legacy compatibility.
An obvious example of this is the `<codePatterns>` vs `<localeDisplayPattern>` that really logically should go together.
This also happens with the `dateFormats`, `timeFormats`, and `dateTimeFormats`.
The latter three are currently organized exactly as in CLDR, but I may rearrange these simply to provide a more convenient method of accessing things (e.g. `calendar.formats<time date datetime interval>`)

# Version History
  * 0.5β
    * Redesigned data structure, and it's all about speed
    * See readme for full details.
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

The resources directory "main" comes directly from the Unicode CLDR data.
These files are copyrighted by Unicode, Inc., and are available and distributed
in accordance with [their terms](http://www.unicode.org/copyright.html).

Everything else (that is, all the Raku code), is licensed under the Artistic License (see license file).
