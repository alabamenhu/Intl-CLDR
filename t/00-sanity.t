use Test;
use lib 'lib';
use Intl::CLDR;


my $a = CLDR.supplement;

done-testing;
#my $*subdivisions-xml = from-xml "resources/cldr-common/common/supplemental/subdivisions.xml".IO.slurp;

#my %base;

#StrEncode::reset(); # clears encoder
#CLDR::Subdivisions.parse(%base, $);
#my $data = CLDR::Subdivisions.encode(%base);
#my uint64 $offset = 0;
#StrDecode::prepare(StrEncode::output());
#my $foo = CLDR::Subdivisions.new: $data, $offset;
