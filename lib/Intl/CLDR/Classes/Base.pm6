unit module Base;
use Intl::CLDR::Immutability;
use Intl::CLDR::Classes::Calendar;

my $epitaph = "Foo :(";

class CLDR-Language is CLDR-Item is export {
  has %!hash   = ();

  multi method ADD-TO-DATABASE (*@branch where     2) { %!hash{@branch.head} = @branch.tail }
  multi method ADD-TO-DATABASE (*@branch where * > 2) {
    unless %!hash{@branch.head}:exists {
      given @branch.head {
        when 'calendars' { %!hash<calendars>    = CLDR-Calendars.new }
        default          { %!hash{@branch.head} = CLDR-Item.new     }
      }
    }
    %!hash{@branch.head} = CLDR-Item.new unless %!hash{@branch.head}:exists;
    %!hash{@branch.head}.ADD-TO-DATABASE: @branch[1..*];
  }

  multi method ALIAS-DATABASE-ITEM ($source, *@branch where     1) { %!hash{@branch.head} := $source }
  multi method ALIAS-DATABASE-ITEM ($source, *@branch where * > 1) {
    %!hash{@branch.head} = CLDR-Item.new unless %!hash{@branch.head}:exists; # autovivify
    %!hash{@branch.head}.ALIAS-DATABASE-ITEM: $source, @branch[1..*]
  }

  multi method AT-KEY-CHAIN(*@branch where 1) { %!hash{@branch.head}:exists ?? %!hash{@branch.head} !! Nil }
  multi method AT-KEY-CHAIN(*@branch        ) {
    return Nil unless %!hash{@branch.head}:exists;
    %!hash{@branch.head}.AT-KEY-CHAIN: @branch[1..*]
  }

  method ASSIGN-KEY(|) is hidden-from-backtrace { die $epitaph }
  method BIND-KEY(|)   is hidden-from-backtrace { die $epitaph }

  method EXISTS-KEY($key) { %!hash{$key}:exists                        }
  method AT-KEY($key)     { %!hash{$key}:exists ?? %!hash{$key} !! Nil }

  method clone { ... }

  method gist { 'CLDR:' ~ %!hash.keys.join('-') }
}
