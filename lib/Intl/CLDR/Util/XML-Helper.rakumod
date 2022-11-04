unit module XML-Helper;

#| Returns the text contents of an XML element
sub contents($xml) is export {
    with $xml.contents {
        return .join
    } else {
        return ''
    }
}

#| Returns the only child element of an XML element for the given tag.  Throws if more than one.
sub elem ($xml, Str() $tag, :$ignore-alt) is export {
    my @elements = $xml.elements(:TAG($tag));
    die "Fix elem for tag $tag, expected only one" if @elements > 1 && !$ignore-alt;
    @elements.head // Nil
}


#| Returns the child elements of an XML element matching the given tag.
proto sub elems (|c) is export {*}
multi sub elems ($xml            ) { my @a = $xml.elements;             @a == 0 ?? Empty !! @a }
multi sub elems ($xml, Str() $tag) { my @a = $xml.elements(:TAG($tag)); @a == 0 ?? Empty !! @a }

