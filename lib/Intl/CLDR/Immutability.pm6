unit module Immutability;
# This helper module should be used for any CLDR module that returns data directly to the
# a consumer of the module.  It will prevent any changes from being done to the database.
#
# sry 4 soo many CAPS -_-

my  $epitaph = "Modification of the CLDR database is not a good idea:\n" ~
               "  - Use .clone (NYI) if you want to get a editable branch.\n" ~
               "  - If you really know what you're doing, use .ADD-TO-DATABASE";

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

    #method keys { %!hash.keys }

    method gist { '[' ~ self.^name ~ ":" ~ self.keys.join(',') ~ ']' }

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

    method gist { '[' ~ self.^name ~ ":" ~ self.values.join(',') ~ ']' }
}

# OLD CODE; to be deleted soon
role Immutable is export {
  method AT-KEY(|)     { immutable callsame }
  method AT-POS(|)     { immutable callsame }
  method ASSIGN-KEY(|) {
    die "Data directly returned from the CLDR cannot be modified.\nIf you need to modify it, you should .clone returned data first.";
  }
  method ASSIGN-POS(|) {
    die "Data directly returned from the CLDR cannot be modified.\nIf you need to modify it, you should .clone returned data first.";
  }
  multi method clone (Positional:) { ;
    # Add mutable code here
  }
  multi method clone (Associative:) { ;
    # Add mutable code here
  }
  multi method clone {
    callsame
  }
}

multi immutable(Positional  \p) is export { p but Immutable }
multi immutable(Associative \a) is export { a but Immutable }
multi immutable(            \o) is export { o               }

class ProtectedHash is Associative is export {
  has %!hash;
  has $.module;
  method EXISTS-KEY ($key)         { %!hash{$key}:exists   }
  method ASSIGN-KEY ($key, \value) {
    if Backtrace.new.list[2..*]
        .map(*.file)
        .grep( { !(.contains('::src/core') || .contains('Intl/CLDR/Immutability.pm6') || .contains('CORE.setting.moarcvm') ) } ).head eq $!module {
    #if Backtrace.new.list.[2..*].grep({ !( $_.file.Str.contains('::src/core') || $_.file.Str.contains('Intl/CLDR/Immutability.pm6') || $_.file.Str.contains( 'CORE.setting.moarcvm' ))}).first.file eq $module {
      %!hash{$key} := value;
    } else {
      die "Data directly returned from the CLDR cannot be modified.\n If you need to modify it, you should .clone returned data first."
    }
  }
  method BIND-KEY ($key, \value) {
    if Backtrace.new.list[2..*]
        .map(*.file)
        .grep( { !(.contains('::src/core') || .contains('Intl/CLDR/Immutability.pm6') || .contains('CORE.setting.moarcvm') ) } ).head eq $!module {
    #if Backtrace.new.list.[2..*].grep({ !( $_.file.Str.contains('::src/core') || $_.file.Str.contains('Intl/CLDR/Immutability.pm6') || $_.file.Str.contains( 'CORE.setting.moarcvm' ))}).first.file eq $!module {
      %!hash{$key} := value;
    } else {
      die "Data directly returned from the CLDR cannot be modified.\n If you need to modify it, you should .clone returned data first."
    }
  }
  method AT-KEY ($key) {

    unless %!hash{$key}:exists {
      given $key {
#        when    'calendars'  { use Intl::CLDR::Classes::Calendar; %!hash{$key} := CLDR-Calendar.new($!module) }
        default              {                                    %!hash{$key} :=   ProtectedHash.new($!module) }
      }
    }
    %!hash{$key};
  }
  method gist { %!hash.gist }
  multi method new ( $module is required ) { self.bless(:$module) }
  multi method new {
    my $module = Backtrace.new.list.[2..*].grep({ !( $_.file.Str.contains('::src/core') || $_.file.Str.contains('Intl/CLDR/Immutability.pm6') || $_.file.Str.contains( 'CORE.setting.moarcvm' ))}).first.file;
    self.bless(:$module);
  }
}


