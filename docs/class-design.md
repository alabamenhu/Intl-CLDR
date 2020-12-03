#### Class design

Each class in the Intl::CLDR namespace should have an almost identical structure.
This document serves to describe and document it.

```
=begin pod
    The POD section should describe any design decisions that were
    made for the class particularly as it may differ from other 
    implementations.  For instance, if the class ignores an alternate 
    type in its import/export process, modifies an element or type's
    name (e.g. "-1" as "one-less"), or only provides hashy/listy 
    access, describe it here with an example.
=end pod

#| Explanation of the class 
#| Relate it directly to a CLDR element.
class CLDR-Foo is CLDR-Item {

    # Every class (except Base) has a parent.  To avoid circular dependencies
    # this is untyped, so type information should be included in declarator POD
    has $!parent; #= The CLDR-Bar that contains this CLDR-Foo
    
    # Then include each logical attribute, typing it accordingly
    has Xyz $.attribute; #= Use POD to give it information
    
    #| Creates a new CLDR-Foo
    method new(\blob, $offset is raw) {
        # If any attributes are strings, use the string coder
        use Intl::CLDR::Util::StringCoder;
        use Intl::CLDR::Xyz; # and of course each class represented 
        
        
        
        
    }
    
    
    # The generator methods are by default commented out.  They MUST be surrounded 
    # by the initial text that you see.  When updating the CLDR database, the 
    # code will be uncommented out (ironically, but commenting out the comment ha)
    # This process keeps the methods out of distribution.
    
    #`<<<<< GENERATOR METHODS
    #| Binary encodes a CLDR-Foo from a flattened CLDR Hash
    method encode(\hash --> buf8) {
        # This method creates a binary encoding, and returns a buf8.
        # It can store things however it wants, so long as the new method
        # can interpret it.  The following is a rough outline of how it's
        # normally done:
        
        my $result = buf8.new;
        for hash.kv -> \key, \value {
            given key {
                                        #  ↙︎ A unique identifier for decoding
                when 'a' { CLDR-A.encode(value).prepend: 1 }
                when 'b' { CLDR-B.encode(value).prepend: 2 }
                when 'c' { CLDR-B.encode(value).prepend: 3 }
                when 's' { StringBuilder::get(value).prepend: 4 }
                default  { die "Unknown value passed to CLDR-Dates encoder" }
            }
        }
        # Using a 0 is the easiest way to create things
        return $result.append: 0
    }
    
    
    
    
    >>>>># GENERATOR METHODS

}
``` 