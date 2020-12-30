use Intl::CLDR::Immutability;

#| A class implementing CLDR's <listPatterns> element, containing information about creating lists.
unit class CLDR-ListPatternWidth is CLDR-ItemNew;

# See https://www.unicode.org/reports/tr35/tr35-general.html#Layout_Elements for information

has     $!parent; #= The CLDR-ListPattern object containing this CLDR-ListPatternWidth
has Str $.start;  #= Pattern to use between the first two elements
has Str $.middle; #= Pattern to use between interior elements
has Str $.end;    #= Pattern to use between the final two elements
has Str $.two;    #= Pattern for exactly two elements

#| Creates a new CLDR-Dates object
method new(|c) {
    self.bless!bind-init: |c;
}

submethod !bind-init(\blob, uint64 $offset is rw) {
    use Intl::CLDR::Util::StrDecode;

    $!start  = StrDecode::get(blob, $offset);
    $!middle = StrDecode::get(blob, $offset);
    $!end    = StrDecode::get(blob, $offset);
    $!two    = StrDecode::get(blob, $offset);

    self
}

constant detour = Map.new: (
    '2' => 'two'
);
method DETOUR (-->detour) {;}

##`<<<<< # GENERATOR: This method should only be uncommented out by the parsing script
method encode($list-pattern-width) {
    my $result = buf8.new;

    # Fallbacks here are simple: within a type, you can fallback to the next wider, and standard length should always be defined
    sub fallback {
        do given $*list-pattern-type, $list-pattern-width {
            when 'standard', 'standard' { %*list-patterns<standard>                                                                        }
            when 'standard', 'short'    { %*list-patterns<standard-short>  || %*list-patterns<standard>                                    }
            when 'standard', 'narrow'   { %*list-patterns<standard-narrow> || %*list-patterns<standard-short> || %*list-patterns<standard> }
            when 'or',       'standard' { %*list-patterns<or>                                                                              }
            when 'or',       'short'    { %*list-patterns<or-short>        || %*list-patterns<or>                                          }
            when 'or',       'narrow'   { %*list-patterns<or-narrow>       || %*list-patterns<or-short>       || %*list-patterns<or>       }
            when 'unit',     'standard' { %*list-patterns<unit>                                                                            }
            when 'unit',     'short'    { %*list-patterns<unit-short>      || %*list-patterns<unit>                                        }
            when 'unit',     'narrow'   { %*list-patterns<unit-narrow>     || %*list-patterns<unit-short>     || %*list-patterns<unit>     }
        } || Hash
    }

    use Intl::CLDR::Util::StrEncode;

    $result ~= StrEncode::get( fallback<start>  // '' );
    $result ~= StrEncode::get( fallback<middle> // '' );
    $result ~= StrEncode::get( fallback<end>    // '' );
    $result ~= StrEncode::get( fallback<2>      // '' );

    $result;
}
method parse(\base, \xml) {
    use Intl::CLDR::Util::XML-Helper;
    base{.<type>} = contents $_ for xml.&elems('listPatternPart');
}
#>>>>> # GENERATOR