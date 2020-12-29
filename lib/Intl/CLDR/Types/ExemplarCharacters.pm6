use Intl::CLDR::Immutability;

unit class CLDR-ExemplarCharacters is CLDR-ItemNew;

has List $.standard;
has List $.index;
has List $.auxiliary;
has List $.numbers;
has List $.punctuation;

#| Creates a new CLDR-DayPeriodContext object
method new(|c) {
    self.bless!bind-init: |c;
}

submethod !bind-init(\blob, uint64 $offset is rw) {
    use Intl::CLDR::Util::StrDecode;

    # Sometimes the character will be a combining grapheme.  This ensures we capture it separately
    # although it might not be much use ATM
    sub safe-split(\source) {
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
        my @characters = %*exemplar{$type}<> // Array.new;
        if @characters {
            @characters.push(@characters.shift) while @characters.head ~~ /^<:M>/; # avoid combiners at start
            $result ~= StrEncode::get(@characters.join: 30.chr);
        }else{
            $result ~= StrEncode::get('');
        }
    }

    $result ~= StrEncode::get((%*exemplar<standard>    // Array.new).join: 30.chr);
    $result ~= StrEncode::get((%*exemplar<index>       // Array.new).join: 30.chr);
    $result ~= StrEncode::get((%*exemplar<auxiliary>   // Array.new).join: 30.chr);
    $result ~= StrEncode::get((%*exemplar<numbers>     // Array.new).join: 30.chr);
    $result ~= StrEncode::get((%*exemplar<punctuation> // Array.new).join: 30.chr);

    $result;
}
method parse(\base, \xml) {
    grammar UnicodeSet {
        rule TOP { '[' <char-seq>* ']' }
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
        token multi   { '{' <.ws>? [<single> <.ws>?]+ '}' }
        token single { <uni-escape> || <html-escape> || <escape> || . }
        token uni-escape { \\u <( <[0..9a..fA..F]> ** 4 )> }
        token Uni-escape { \\U <( <[0..9a..fA..F]> ** 6 )> }
        token html-escape { \\? '&' <( <[0..9a..zA..Z]>+ )> ';' } # \\? because of &amp;'s weird encoding
        token escape { \\ <( . )> }
    }

    class UnicodeSetActions {
        method TOP ($/) {
            my @text;
            @text.append($_) for $<char-seq>>>.made;
            make @text.unique
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
              with $<uni-escape>  { make $<uni-escape>.made }
            orwith $<Uni-escape>  { make $<Uni-escape>.made }
            orwith $<html-escape> { make $<html-escape>.made }
            orwith $<escape>      { make $<escape>.made }
            else                { make $/.Str.list    }
        }
        method range ($/) { make ($<start>.made.head .. $<end>.made.head).list }
    }

    use Intl::CLDR::Util::XML-Helper;

    with xml {
        base = UnicodeSet.parse((contents(xml // '') // '[]'), :actions(UnicodeSetActions)).made.eager;
    }
}
#>>>>> # GENERATOR
