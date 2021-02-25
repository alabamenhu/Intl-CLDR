use Intl::CLDR::Immutability;

#| Groups of characters used for different purposes in a language
unit class CLDR-ExemplarCharacters is CLDR-ItemNew;

has List $.standard;     #= The fundamental characters required by a language
has List $.index;        #= Index characters used in the language (e.g. dictionary headers)
has List $.auxiliary;    #= Additional characters that are frequently used by a language
has List $.numbers;      #= Symbols and digits commonly used in math
has List $.punctuation;  #= Punctuation used regularly by a language

#| Creates a new CLDR-DayPeriodContext object
method new(|c) {
    self.bless!bind-init: |c;
}

submethod !bind-init(\blob, uint64 $offset is rw) {
    use Intl::CLDR::Util::StrDecode;

    # Sometimes the character will be a combining grapheme.  This ensures we capture it separately
    # although it might not be much use ATM
    multi sub safe-split(\source) {
        return () if source eq ''; # for some languages (and root), we interpret the empty string as blank
        my @haystack = source.ords;
        constant needle   = 30; # second order delimiter

        my @results;
        my $cursor = 0;
        my $anchor = 0;

        loop {
            $cursor++ while $cursor < @haystack && @haystack[$cursor] != needle;
            @results.push: @haystack[$anchor .. $cursor - 1]>>.chr.join;
            return @results if @haystack < ($anchor = ++$cursor);
        }
        return ();
    }

    $!standard    = safe-split StrDecode::get(blob,$offset);
    $!index       = safe-split StrDecode::get(blob,$offset);
    $!auxiliary   = safe-split StrDecode::get(blob,$offset);
    $!numbers     = safe-split StrDecode::get(blob,$offset);
    $!punctuation = safe-split StrDecode::get(blob,$offset);

    self
}

##`<<<<< # GENERATOR: This method should only be uncommented out by the parsing script
method encode(%*exemplar --> blob8) {
    use Intl::CLDR::Util::StrEncode;

    my $result = buf8.new;

    for <standard index auxiliary numbers punctuation> -> $type {
        my @characters := %*exemplar{$type}<> // Array.new;

        if @characters.elems > 0 {
            @characters.push(@characters.shift) while @characters.head ~~ /^<:M>/; # avoid combiners at start
            $result ~= StrEncode::get(@characters.join: 30.chr);
        } else {
            $result ~= StrEncode::get('');
        }
    }

    #$result ~= StrEncode::get((%*exemplar<standard>    // Array.new).join: 30.chr);
    #$result ~= StrEncode::get((%*exemplar<index>       // Array.new).join: 30.chr);
    #$result ~= StrEncode::get((%*exemplar<auxiliary>   // Array.new).join: 30.chr);
    #$result ~= StrEncode::get((%*exemplar<numbers>     // Array.new).join: 30.chr);
    #$result ~= StrEncode::get((%*exemplar<punctuation> // Array.new).join: 30.chr);

    $result;
}

method parse(\base, \xml) {
    #| Parses the a set of unicode characters as used in CLDR
    grammar UnicodeSet {
        # This definition is sufficient for all characters found
        # in the Exemplar Characters section of CLDR.  There is
        # additional syntax, but as it's not needed here, it's avoided.
        rule TOP { '[' <char-seq> * ']' }
        token char-seq {
            | <range>
            | <multi>
            | <single>
        }
        rule range {
            $<start>=<single>
            '-'
            $<end>=<single>
        }
        token single      {                                       # Single character
                          || <uni-escape>                         # (escaped or else literal)
                          || <html-escape>
                          || <escape>
                          || <-[}]>                               # Literal can't be a } because of multis
                          }
        token multi       { '{' <.ws>? [<single> <.ws>?]+ '}' }   # Multiple characters
        token uni-escape  { \\u <( <[0..9a..fA..F]> ** 4 )> }     # Four digit escape
        token Uni-escape  { \\U <( <[0..9a..fA..F]> ** 6 )> }     # Six digit escape
        token html-escape { \\? '&' <( <[0..9a..zA..Z]>+ )> ';' } # \\? because of &amp;'s weird encoding
        token escape      { \\ <( . )> }                          # Special escape sequences
    }

    class UnicodeSetActions {
        method TOP ($/) {
            my @text;
            @text.append($_) for $<char-seq>>>.made;
            make @text.unique.Array;
        }
        method char-seq ($/) {
            make $<range>.made  with $<range>;
            make $<multi>.made  with $<multi>;
            make $<single>.made with $<single>;
        }
        method multi  ($/) { make $<single>>>.made.join.list }
        method uni-escape ($/) { make $/.Str.parse-base(16).chr.list }
        method Uni-escape ($/) { make $/.Str.parse-base(16).chr.list }
        method html-escape ($/) {
            given $/ {
                when 'amp'  { make '&'.list }
                when 'quot' { make '"'.list }
                default     { die "Unknown HTML escape sequence found in XML" }
            }
        }
        method escape ($/) {
            given $/.Str {
                when 'a'     { make  7.chr.list } # bel / alert
                when 'b'     { make  8.chr.list } # backspace
                when 't'     { make  9.chr.list } # tab
                when 'n'     { make 10.chr.list } # line feed
                when 'v'     { make 11.chr.list } # line tab
                when 'f'     { make 12.chr.list } # form feed
                when 'r'     { make 13.chr.list } # carriage return
                when 'p'|'P' { die "Unicode property used in exemplar character list" }
                default  { make $/.Str.list }
            }
        }
        method single ($/) {
              with $<uni-escape>  { make $<uni-escape>.made  }
            orwith $<Uni-escape>  { make $<Uni-escape>.made  }
            orwith $<html-escape> { make $<html-escape>.made }
            orwith $<escape>      { make $<escape>.made      }
              else                { make $/.Str.list         }
        }
        method range ($/) { make ($<start>.made.head .. $<end>.made.head).list }
    }

    use Intl::CLDR::Util::XML-Helper;

    with xml {
        #say "";
        #say "Processing ", (xml<type> // 'standard'), ": ", contents (xml // '');
        #say "  Valid parse string " if UnicodeSet.parse: contents(xml // '') // '[]';
        #say "  Valid result " if UnicodeSet.parse: (contents(xml // '') // '[]'), :actions(UnicodeSetActions);
        base = UnicodeSet.parse((contents(xml // '') // '[]'), :actions(UnicodeSetActions)).made;
    }
}
#>>>>> # GENERATOR
