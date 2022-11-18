unit class CLDR::Database;
    use Intl::CLDR::Core;
    use Intl::CLDR::Types::Languages;
    use Intl::CLDR::Types::Supplement;

has CLDR::Languages  $.languages      = CLDR::Languages.new;  #= Per-language data
has CLDR::Supplement $!supplement;                            #= Language agnostic data (often region-based)
has Version          $.cldr-version   = v42;                  #= CLDR data release (new major version annually)
has Version          $.module-version = v0.7.2;               #= Module version (follows semantic versioning)

#| Language agnostic data (often region-based)
method supplement is aliased-by<supplemental> {
    use Intl::CLDR::Util::StrDecode;
    .return with $!supplement;

    my str @strs = %?RESOURCES{"supplemental.strings"}.split(31.chr);
    my     \blob = %?RESOURCES{"supplemental.data"}.slurp(:bin, :close);
    my uint64 $offset = 0;
    StrDecode::set(@strs);
    #return CLDR-Supplement.new: blob, @strs;

    $!supplement = CLDR::Supplement.new: blob, $offset;
}

