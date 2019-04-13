unit module MayanNumerals;

my %digits = <0 𝋠 1 𝋡 2 𝋢 3 𝋣 4 𝋤 5 𝋥 6 𝋦 7 𝋧 8 𝋨 9 𝋩
              A 𝋪 B 𝋫 C 𝋬 D 𝋭 E 𝋮 F 𝋯 G 𝋰 H 𝋱 I 𝋲 J 𝋳>;

sub mayan-numeral($number) {
  $number
    .base(20)       # Mayan is vigesimal
    .split("")      #
    .map(           # For each place
      {%digits{$_}} #  take the Mayan equivalent
    ).join          #
}
