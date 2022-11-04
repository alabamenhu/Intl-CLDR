=begin pod
Tests object creation speed.  Aim to create objects using the fastest method whenever possible.

Results from Rakudo v2021.12.552.gb.47.df.1.eef (3.1 GHz Dual-Core Intel Core i5, macOS 12.1)
=================================================
0.805 A (Simple bless, no pre-assignment)
1.127 G (Simple bless, pre-assignment via binding)
1.164 H (Simple bless, no pre-assignment, all attributes required)
1.182 F (Simple bless, pre-assignment)
1.254 I (Direct assignment via TWEAK, no pre-assignment)
1.484 B (Direct assignment via submethod, no pre-assignment)
1.538 D (Direct assignment via BUILD, no pre-assignment)
1.573 C (Direct assignment via TWEAK, no pre-assignment)
4.208 E (Direct assignment in BUILD, via dynamic)
=================================================
=end pod


#| Simple bless, no pre-assignment, all attributes required
class H {
    has $.a is required;
    has $.b is required;
    has $.c is required;
    has $.d is required;
    has $.e is required;
    has $.f is required;
    has $.g is required;
    has $.h is required;
    has $.i is required;
    has $.j is required;
    has $.k is required;
    has $.l is required;

    method new (@a) {
        self.bless:
                a => @a[0], b => @a[1], c => @a[2],
                d => @a[3], e => @a[4], f => @a[5],
                g => @a[6], h => @a[7], i => @a[8],
                j => @a[9], k => @a[10], l => @a[11],
    }
}

#| Direct assignment via submethod, no pre-assignment
class B {
    has $.a; has $.b; has $.c; has $.d; has $.e; has $.f;
    has $.g; has $.h; has $.i; has $.j; has $.k; has $.l;
    method new (@b) {
        self.bless!b: @b
    }
    submethod !b (@b) {
        $!a = @b[0], $!b => @b[1], $!c => @b[2], $!d = @b[3], $!e => @b[4],  $!f => @b[5],
        $!g = @b[6], $!h => @b[7], $!i => @b[8], $!j = @b[9], $!k => @b[10], $!l => @b[11],
    }
}

#| Direct assignment via TWEAK, no pre-assignment
class C {
    has $.a; has $.b; has $.c; has $.d; has $.e; has $.f;
    has $.g; has $.h; has $.i; has $.j; has $.k; has $.l;

    method new (@c) {
        self.bless: :@c
    }
    method TWEAK (:@c) {
        $!a = @c[0], $!b => @c[1], $!c => @c[2], $!d = @c[3], $!e => @c[4], $!f => @c[5],
        $!g = @c[6], $!h => @c[7], $!i => @c[8], $!j = @c[9], $!k => @c[10], $!l => @c[11],
    }
}

#| Direct assignment via TWEAK, no pre-assignment
class I {
    has $.a; has $.b; has $.c; has $.d; has $.e; has $.f;
    has $.g; has $.h; has $.i; has $.j; has $.k; has $.l;

    method new (@i) {
        self.bless: :@i
    }
    method TWEAK (:@i) {
        my $a = @i[0]; my $b = @i[1]; my $c = @i[2]; my $d = @i[3]; my $e = @i[4];  my $f = @i[5];
        my $g = @i[6]; my $h = @i[7]; my $i = @i[8]; my $j = @i[9]; my $k = @i[10]; my $l = @i[11];
        $!a = $a; $!b = $b; $!c = $c; $!d = $d; $!e = $e; $!f = $f;
        $!g = $g; $!h = $h; $!i = $i; $!j = $j; $!k = $k; $!l = $l;
    }
}

#| Direct assignment via BUILD, no pre-assignment
class D {
    has $.a; has $.b; has $.c; has $.d; has $.e; has $.f;
    has $.g; has $.h; has $.i; has $.j; has $.k; has $.l;
    method new (@d) {
        self.bless: :@d
    }
    method BUILD (:@d) {
        $!a = @d[0], $!b => @d[1], $!c => @d[2], $!d = @d[3], $!e => @d[4],  $!f => @d[5],
        $!g = @d[6], $!h => @d[7], $!i => @d[8], $!j = @d[9], $!k => @d[10], $!l => @d[11],
    }
}

#| Direct assignment in BUILD, via dynamic
class E {
    has $.a; has $.b; has $.c; has $.d; has $.e; has $.f;
    has $.g; has $.h; has $.i; has $.j; has $.k; has $.l;
    method new (*@*e) {
        self.bless
    }

    method BUILD {
        $!a = @*e[0], $!b => @*e[1], $!c => @*e[2], $!d = @*e[3], $!e => @*e[4],  $!f => @*e[5],
        $!g = @*e[6], $!h => @*e[7], $!i => @*e[8], $!j = @*e[9], $!k => @*e[10], $!l => @*e[11],
    }
}

#| Simple bless, pre-assignment
class F {
    has $.a; has $.b; has $.c; has $.d; has $.e; has $.f;
    has $.g; has $.h; has $.i; has $.j; has $.k; has $.l;
    method new (@f) {
        my $a = @f[0]; my $b = @f[1]; my $c = @f[2]; my $d = @f[3]; my $e = @f[4];  my $f = @f[5];
        my $g = @f[6]; my $h = @f[7]; my $i = @f[8]; my $j = @f[9]; my $k = @f[10]; my $l = @f[11];
        self.bless: :$a, :$b, :$c, :$d, :$e, :$f, :$g, :$h, :$i, :$j, :$k, :$l
    }
}

#| Simple bless, pre-assignment via binding
class G {
    has $.a; has $.b; has $.c; has $.d; has $.e; has $.f;
    has $.g; has $.h; has $.i; has $.j; has $.k; has $.l;
    method new (@g) {
        my $a := @g[0]; my $b := @g[1]; my $c := @g[2]; my $d := @g[3]; my $e := @g[4];  my $f := @g[5];
        my $g := @g[6]; my $h := @g[7]; my $i := @g[8]; my $j := @g[9]; my $k := @g[10]; my $l := @g[11];
        self.bless: :$a, :$b, :$c, :$d, :$e, :$f, :$g, :$h, :$i, :$j, :$k, :$l
    }
}

#| Simple bless, no pre-assignment
class A {
    has $.a; has $.b; has $.c; has $.d; has $.e; has $.f;
    has $.g; has $.h; has $.i; has $.j; has $.k; has $.l;
    method new (@a) {
        self.bless:
            a => @a[0], b => @a[1], c => @a[2], d => @a[3], e => @a[4],  f => @a[5],
            g => @a[6], h => @a[7], i => @a[8], j => @a[9], k => @a[10], l => @a[11],
    }
}

#| Direct bless, no pre-assignment
class V {
    has $.a; has $.b; has $.c; has $.d; has $.e; has $.f;
    has $.g; has $.h; has $.i; has $.j; has $.k; has $.l;
    method BUILD (:@v) {
        $!a = @v[0], $!b => @v[1], $!c => @v[2], $!d = @v[3], $!e => @v[4],  $!f => @v[5],
        $!g = @v[6], $!h => @v[7], $!i => @v[8], $!j = @v[9], $!k => @v[10], $!l => @v[11],
    }
}

#| No new override (maybe not directly comparable)
class J {
    has $.a; has $.b; has $.c; has $.d; has $.e; has $.f;
    has $.g; has $.h; has $.i; has $.j; has $.k; has $.l;
}

my       @classes =  B; #, A, B, C, D, E, F, G, H, I, ;
my Array %times; #
my @values = ^100012;

for ^10 {
    for @classes -> \x {
        my @foo;
        my $time = now;
        @foo.push = x.new: @values[$_ .. $_ + 11] for ^100000;
        # @foo.push = x.bless: v => @values[$_ .. $_ + 11] for ^100000;
        %times{x.^name}.push: now - $time;
    }
}
#`<<<
for ^10 {
    my @foo;
    my $time = now;
    my @v;
    @v := @values[$_ .. $_ + 11] && @foo.push(
        J.new:
            a => @v[0], b => @v[1],  c => @v[2],
            d => @v[3], e => @v[4],  f => @v[5],
            g => @v[6], h => @v[7],  i => @v[8],
            j => @v[9], k => @v[10], l => @v[11]
        ) for ^100000;
    %times<J>.push: now - $time
}>>>

say %times.values.head.sum / 10;


# A: 0.787   0.796   0.791
# B: 1.359   1.752   1.313
# C: 1.295   1.330   1.308
# D: 1.241   1.228   1.529
# E: 3.614   3.223   3.278
# F: 0.836   0.910   0.859

# a 0.609
# b 1.507
# v 1.276
#for %times.sort(*.value[5..*].sum) -> (:$key, :@value) {
#    say ((@value[5..*].sum / 5).round: 0.001), " $key ({::("$key").WHY // ''})", ;
#}

say $*RAKU.compiler.version