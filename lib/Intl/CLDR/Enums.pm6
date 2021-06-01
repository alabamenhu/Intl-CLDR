unit module Enums;

package Gender {
    enum Gender (
        neuter    => 0,
        masculine => 1,
        feminine  => 2,
        animate   => 3,
        inanimate => 4,
        common    => 5,
        personal  => 6
    )
}

package Count {
    enum Count (
        zero  => 0,
        one   => 1,
        two   => 2,
        few   => 3,
        many  => 4,
        other => 5,
        0     => 6, # can mod 6 --> 0 if extended count isn't allowed
        1     => 7, # can mod 6 --> 1 if extended count isn't allowed
    )
}

package Case {
    enum Case (
        ablative           =>  0,
        accusative         =>  1,
        comitative         =>  2,
        dative             =>  3,
        ergative           =>  4,
        genitive           =>  5,
        instrumental       =>  6,
        locative           =>  7,
        locativecopulative =>  8,
        nominative         =>  9,
        oblique            => 10,
        prepositional      => 11,
        sociative          => 12,
        vocative           => 13,
        abessive           => 14, # added in CLDR 39β
        adessive           => 15, # added in CLDR 39β
        allative           => 17, # added in CLDR 39β
        causal             => 16, # added in CLDR 39
        delative           => 17, # added in CLDR 39
        elative            => 18, # added in CLDR 39
        essive             => 19, # added in CLDR 39
        illative           => 20, # added in CLDR 39
        inessive           => 21, # added in CLDR 39
        partitive          => 22, # added in CLDR 39
        sublative          => 23, # added in CLDR 39
        superessive        => 24, # added in CLDR 39
        terminative        => 25, # added in CLDR 39
        translative        => 26, # added in CLDR 39
    )
}

package Definiteness  {
    enum Definiteness (
        definite    => 0,
        indefinite  => 1,
        construct   => 2,
        unspecified => 3,
    )
}
