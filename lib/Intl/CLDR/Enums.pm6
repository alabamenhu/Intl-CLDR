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
