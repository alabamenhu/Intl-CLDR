unit module Immutability;
# This helper module should be used for any CLDR module that returns data directly to the
# a consumer of the module.  It will prevent any changes from being done to the database.
##use Intl::CLDR::Classes::Calendar;
my  $epitaph = "Modification of the CLDR database is not a good idea:\n" ~
               "  - Use .clone if you want to get a editable branch.\n" ~
               "  - If you really know what you're doing, use .ADD-TO-DATABASE";

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


class CLDR-Item is Associative is export {
  has %!hash   = ();

  # This is the only method that should need to be overridden in sub classes.
  method NEW-ITEM ($key) { CLDR-Item.new }

  multi method ADD-TO-DATABASE (*@branch where     2) { %!hash{@branch.head} = @branch.tail }
  multi method ADD-TO-DATABASE (*@branch where * > 2) {
    %!hash{@branch.head} //= self.NEW-ITEM(@branch.head);
    %!hash{@branch.head}.ADD-TO-DATABASE: @branch[1..*];
  }

  multi method ALIAS-DATABASE-ITEM ($source, *@branch where     1) { %!hash{@branch.head} := $source }
  multi method ALIAS-DATABASE-ITEM ($source, *@branch where * > 1) {
    %!hash{@branch.head} //= self.NEW-ITEM(@branch.head); # autovivify
    %!hash{@branch.head}.ALIAS-DATABASE-ITEM: $source, @branch[1..*]
  }

  multi method AT-KEY-CHAIN(*@branch where 1) { %!hash{@branch.head} // Nil }
  multi method AT-KEY-CHAIN(*@branch        ) {
    return Nil unless %!hash{@branch.head}:exists;
    %!hash{@branch.head}.AT-KEY-CHAIN: @branch[1..*]
  }

  method ASSIGN-KEY(|) is hidden-from-backtrace { die $epitaph }
  method BIND-KEY(|)   is hidden-from-backtrace { die $epitaph }

  method EXISTS-KEY($key) { %!hash{$key}:exists }
  method AT-KEY($key)     { %!hash{$key}        }

  method clone { ... }

  method keys { %!hash.keys }

  method gist { '[' ~ self.^name ~ ":" ~ %!hash.keys.join(',') ~ ']' }
}
