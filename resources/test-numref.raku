use lib 'lib';
use NumRef;

my $nr = NumRef.new;

say $nr.output: %( dates => %( foo => 5 ) );