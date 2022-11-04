unit module Core;

class CLDR::Ordered   { ... }
class CLDR::Unordered { ... }
subset NotBasic where * !~~ CLDR::Unordered;

#| A role defining a base-line amount of support for accessors (both hash-y and method-y) for CLDR classes
role CLDR::Item
    does Associative
    is   export
{
    method keys(::?CLASS:D:) {
        self.^attributes
            ==> grep *.has_accessor
            ==> map  *.name.substr: 2
            ==> sort()
    }
    method values(::?CLASS:D:) {
        self.^attributes
            ==> grep *.has_accessor
            ==> map  *.name.substr: 2
            ==> sort()
            ==> map { self."$_"() }
    }

    method kv(::?CLASS:D:) {
        die "Not yet implemented.  But this generally doesn't make sense for most items.";
    }

    multi method gist(NotBasic:D:) { [~] '[yy', self.^name, ': ', self.keys.join(','), ']' }
    multi method gist(CLDR::Item:U:) { [~] '(', self.^name,                            ')' }

    multi method AT-KEY(NotBasic:D: $key) { self."$key"() }
}

#| Alias a method name to a different name (useful when Raku
#| naming conventions conflict with CLDR's multiple personalities)
multi sub trait_mod:<is> (Attribute $attr, :$aliased-by!) is export {
    return unless $aliased-by;

    if $aliased-by ~~ List {
        $attr.package.^add_method($_, anon method { $attr.get_value(self) } )
            for $aliased-by<>
    } else {
        $attr.package.^add_method: $aliased-by, anon method { $attr.get_value(self) }
    }
}

#| Alias an attribute to a different name (useful when Raku
#| naming conventions conflict with CLDR's multiple personalities)
multi sub trait_mod:<is> (Method $method, :$aliased-by!) is export {
    return unless $aliased-by;

    if $aliased-by ~~ List {
        $method.package.^add_method($_, $method )
            for $aliased-by<>
    } else {
        $method.package.^add_method: $aliased-by, $method
    }
}

#| Indicates that an attribute is loaded lazily.  This must be set up
#| specially, and is not general purpose.
multi sub trait_mod:<is> (Attribute \attr, :$lazy!) is export {
    state    Int %index;     #= holds indexing values
    constant     $start = 8; #= length of header in bytes

    # Attribute name always includes `$!`
    my Int       $index := %index{attr.package.^name}++;
    my Str       $name  := attr.name.substr(2);
    my Attribute $path  := attr.package.^attributes.grep(*.name eq '$!data-file').head;
    my Attribute $strs  := attr.package.^attributes.grep(*.name eq '@!strings'  ).head;

    attr.package.^add_method:
        $name,
        anon method {
            my $attr := attr;
            .return with $attr.get_value(self);

            # Open the file (don't forget to close after reading!)
            my $file := $path.get_value(self).open: :bin;

            # Determine where the data is:
            # - 8 byte header
            # - 4 bytes (start of 0th)
            # - 4 bytes (start of 1st)
            # - ...
            # - 4 bytes (eof)

            $file.seek($start + $index * 4);
            my blob8  $locations = $file.read(8);
            my uint32 $from      = $locations.read-uint32(0, LittleEndian);
            my uint32 $to        = $locations.read-uint32(4, LittleEndian);
            $file.seek($from, SeekFromBeginning);

            # Read the data for object creation and
            # create the object, and store it for later
            my buf8   $data    = $file.read($to - $from);
            my uint64 $offset  = 0;
            $file.close;

            use Intl::CLDR::Util::StrDecode;
            StrDecode::set($strs.get_value: self);

            my $item := $attr.type.new: $data, $offset;
            $attr.set_value:
                self,
                $item
        }

}

my $epitaph = "† You really shouldn't try to edit CLDR data.\n"
            ~ "  If you really know what you're doing, you can\n"
            ~ "  figure out how, but you needn't and shouldn't.";

#| A class to be inherited by CLDR items with ordered child elements (backed by an array)
class CLDR::Ordered is Array is export {
    method ASSIGN-POS(|) is hidden-from-backtrace { die $epitaph }
    method BIND-POS(  |) is hidden-from-backtrace { die $epitaph }

    # Convert Associative ops into Positional ops
    method AT-KEY(    $key) { self.Array::AT-POS:     +$key }
    method EXISTS-KEY($key) { self.Array::EXISTS-POS: +$key }

    multi method gist (CLDR::Ordered:D:) { '[' ~ self.^name ~ ":" ~ self.values.join(',') ~ ']' }
}

#| A class to be inherited by CLDR items whose keys/attributes are variable (backed by a hash)
class CLDR::Unordered is Hash is export {
    method ASSIGN-KEY(|) is hidden-from-backtrace { die $epitaph }
    method BIND-KEY(  |) is hidden-from-backtrace { die $epitaph }

    # Redirect to real Hash
    method AT-KEY(    $key) { self.Hash::AT-KEY:     $key }
    method EXISTS-KEY($key) { self.Hash::EXISTS-KEY: $key }

    method keys { self.Hash::keys }

    method FALLBACK($key) { self{$key} or die "The key '$key' isn’t available (returned {self.Hash::AT-KEY($key)}).  Did you mean one of these? \n    " ~ self.Hash::keys.sort.join(", ") }

    multi method gist (::?CLASS:D:) { '[' ~ self.^name ~ ": " ~ self.Hash::keys.join(',') ~ ']' }
}