#| This is a class that outputs a hash from the parsed main file
unit class NumRef;

#| Creates the output, assuming that the hash represents the top level of a
#| CLDR main language file.  Errors for unknown values.
method output(%hash --> Blob[uint8]) {
    my Buf[uint8] $result = Buf[uint8].new: "RakuCLDR".encode.list;

    my %abbr = characters         => 1,
               characterLabels    => 2,
               contextTransforms  => 3,
               dates              => 4,
               delimiters         => 5,
               listPatterns       => 6,
               localeDisplayNames => 7,
               numbers            => 8,
               posix              => 9,
               typographicNames   => 10,
               units              => 11;

    for %hash.kv -> $key, %value {
        given $key {
            when 'dates' {
                $result.push: %abbr<dates>;
                $result.append: self.dates(%value).list;
            }
        }
    }

    return $result;
}


#| Generates the binary data for the CLDR top-level entry "dates"
#| which correspondes to the class CLDR-Dates
method dates(%hash --> Blob[uint8]) {
    my Buf[uint8] $result = Buf[uint8].new;

    my %abbr =  calendars     => 1,
                fields        => 2,
                timezoneNames => 3;

    for %hash.kv -> $key, %value {
        given $key {
            when 'calendars' {
                $result.push: %abbr<calendars>;
                $result.append: 11,11,11;
            }
        }
    }

    $result.push: 99;

}