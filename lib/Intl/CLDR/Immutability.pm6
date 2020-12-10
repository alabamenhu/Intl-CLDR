unit module Immutability;
# This helper module should be used for any CLDR module that returns data directly to the
# a consumer of the module.  It will prevent any changes from being done to the database.
#
# sry 4 soo many CAPS -_-
my $epitaph = "† You really shouldn't try to edit CLDR data.\n"
            ~ "  If you really know what you're doing, you can\n"
            ~ "  figure out how, but you needn't and shouldn't.";

class CLDR-ItemNew is Associative is export {
    method keys(CLDR-ItemNew:D:) {
        self.^attributes
            ==> grep *.has_accessor
            ==> map  *.name.substr: 2
            ==> sort()
    }
    method values(CLDR-ItemNew:D:) {
        self.^attributes
          ==> grep *.has_accessor
          ==> map  *.name.substr: 2
          ==> sort()
          ==> map { self."$_"() }
    }
    method kv(CLDR-ItemNew:D:) {
        die "Not yet implemented.  But this generally doesn't make sense for most items.";
    }

    multi method gist(CLDR-ItemNew:D:) {
        [~] '[', self.^name, ':', self.keys.join(','), ']'
    }
    multi method gist(CLDR-ItemNew:U:) {
        [~] '(', self.^name, ')'
    }

    # By default, no rerouting, so classes only need to implement if they want
    # different behavior
    constant \no-detour = Map.new;
    method DETOUR( --> no-detour ) {;}

    method FALLBACK($key) {
        # There are two types of fallbacks that we can do, either a substitution method
        # (e.g. 'standAlone' -> 'stand-alone') or our class might be fully Hashy.
        # That will be covered by the CLDR-Unordered which assumes purely hash access to
        # values.
        return self."$_"() with self.DETOUR{$key};
        say "Could not find $key, and don't know how to reroute you.  The options are: ", self.DETOUR.keys;
        say "I should have gotten", self.DETOUR{$key};
        X::Method::NotFound.new.throw;
    }
}



class CLDR-Item is Hash is export {
    has $!parent;

    # This is the only method that should need to be overridden in sub classes
    # unless there is a speed up to be made via attributes
    method NEW-ITEM ($key) { CLDR-Item.new }

    multi method ADD-TO-DATABASE (@branch, $offset = @branch - 1) {
        self.Hash::ASSIGN-KEY: @branch[1], @branch.[0]
            and return if $offset == 1;

        self.Hash::ASSIGN-KEY: @branch[$offset], CLDR-Item.new
            unless self.Hash::AT-KEY: @branch[$offset];

        self.Hash::AT-KEY(@branch[$offset]).ADD-TO-DATABASE: @branch, $offset - 1;
    }

    multi method ALIAS-DATABASE-ITEM ($source, @branch, $offset) {
        self.Hash::BIND-KEY(@branch[0], $source)
            if $offset == 0;

        self.Hash::AT-KEY(@branch[$offset]).ALIAS-DATABASE-ITEM
    }
    multi method ALIAS-DATABASE-ITEM ($source, +@branch where     1) { self.Hash::BIND-KEY(@branch.head,$source) }
    multi method ALIAS-DATABASE-ITEM ($source, +@branch where * > 1) {
        self.Hash::ASSIGN-KEY(@branch.head, self.AT-KEY(@branch.head) // self.NEW-ITEM(@branch.head)); # autovivify
        self.Hash::AT-KEY(@branch.shift).ALIAS-DATABASE-ITEM: $source, @branch
        #self.Hash::AT-KEY(@branch.head).ALIAS-DATABASE-ITEM: $source, @branch[1..*]
    }

    method AT-KEY-CHAIN(@branch, $offset = @branch - 1) {
        return self.Hash::AT-KEY(@branch[0])
            if $offset == 0;

        self.Hash::AT-KEY(@branch[$offset]).AT-KEY-CHAIN: @branch, $offset - 1;
    }
    #multi method AT-KEY-CHAIN(+@branch where 1) { self.Hash::AT-KEY(@branch.head) // Nil }
    #multi method AT-KEY-CHAIN(+@branch        ) {
    #    return Nil unless self.Hash::EXISTS-KEY(@branch.head);
    #    self.Hash::AT-KEY(@branch.head).AT-KEY-CHAIN: @branch[1..*]
    #}

    method ASSIGN-KEY(|) is hidden-from-backtrace { die $epitaph }
    method BIND-KEY(|)   is hidden-from-backtrace { die $epitaph }

    #method EXISTS-KEY($key) { %!hash{$key}:exists }
    #method AT-KEY($key)     { %!hash{$key}        }

    method clone { ... }

    #method keys { %!hash.keys }

    method gist { '[' ~ self.^name ~ ":" ~ self.keys.join(',') ~ ']' }

    method FALLBACK(\key) {
        self.EXISTS-KEY(key) or die "Unrecognized attribute name “{key}”.  The following undocumented attributes are available in this item: " ~ self.keys;
        self.AT-KEY(key);
    }
}

class CLDR-Ordered is Array is export {
    method ASSIGN-POS(|) is hidden-from-backtrace { die $epitaph }
    method BIND-POS(|)   is hidden-from-backtrace { die $epitaph }

    # Convert Associative ops into Positional ops
    method AT-KEY(    $key) { self.Array::AT-POS:     +$key }
    method EXISTS-KEY($key) { self.Array::EXISTS-POS: +$key }

    method gist (CLDR-Ordered:D:) { '[' ~ self.^name ~ ":" ~ self.values.join(',') ~ ']' }
}

class CLDR-Unordered is Hash is export {
    method ASSIGN-KEY(|) is hidden-from-backtrace { die $epitaph }
    method BIND-KEY(|)   is hidden-from-backtrace { die $epitaph }

    # Convert Redirect the exist calls
    method AT-KEY(    $key) { self.Hash::AT-KEY:     $key }
    method EXISTS-KEY($key) { self.Hash::EXISTS-KEY: $key }

    method keys { self.Hash::keys }

    method FALLBACK($key) { self.Hash::AT-KEY: $key or die "That key isnt available" }

    method gist (CLDR-Unordered:D:) { '[' ~ self.^name ~ ":" ~ self.Hash::values.join(',') ~ ']' }
}