unit class CLDR::Database;
    use Intl::CLDR::Core;
    use Intl::CLDR::Types::Languages;

has CLDR::Languages  $.languages      = CLDR::Languages.new;  #= Per-language data
has Str              $!supplement     = "supplement!";        #= Language agnostic data (often region-based)
has Version          $.cldr-version   = v38;                  #= CLDR data release (new major version annually)
has Version          $.module-version = v0.5.2;               #= Module version (follows semantic versioning)

method supplement is aliased-by<supplemental> {
    #use Intl::CLDR::Util::StrEncode;
    #.return with $!supplement;

    #my str @strs = %?RESOURCES{"supplemental.strings"}.split(31.chr);
    #my     \blob = %?RESOURCES{"supplemental.data"}.slurp(:bin, :close);
    #my uint64 $offset = 0;
    #StrDecode::set(@strs);
    #return CLDR-Language.new: blob, @strs;

    #$!supplement = CLDR::Supplemental.new: blob, 0;
}

