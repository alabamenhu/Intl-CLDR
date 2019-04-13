use XML;
use Intl::BCP47;

grammar UnicodeXMLString {
	token TOP { <chars>+ }
	token chars { [<escaped> || <regular>] }
	token escaped { '&#x' (<[0..9A..F]>+) ';' }
	token regular { <-[&]>+ }
}

# When testing, try using just en / es / ja or something similar.
# Also note that the main file includes a ROOT file, this should be NOT be
# included in this list of language (beware if you're doing ls -1 to generate!)
my @languages = <af af_NA af_ZA agq agq_CM ak ak_GH am am_ET ar ar_001 ar_AE ar_BH ar_DJ ar_DZ ar_EG ar_EH ar_ER ar_IL ar_IQ ar_JO ar_KM ar_KW ar_LB ar_LY ar_MA ar_MR ar_OM ar_PS ar_QA ar_SA ar_SD ar_SO ar_SS ar_SY ar_TD ar_TN ar_YE as as_IN asa asa_TZ ast ast_ES az az_Cyrl az_Cyrl_AZ az_Latn az_Latn_AZ bas bas_CM be be_BY bem bem_ZM bez bez_TZ bg bg_BG bm bm_ML bn bn_BD bn_IN bo bo_CN bo_IN br br_FR brx brx_IN bs bs_Cyrl bs_Cyrl_BA bs_Latn bs_Latn_BA ca ca_AD ca_ES ca_ES_VALENCIA ca_FR ca_IT ccp ccp_BD ccp_IN ce ce_RU cgg cgg_UG chr chr_US ckb ckb_IQ ckb_IR cs cs_CZ cu cu_RU cy cy_GB da da_DK da_GL dav dav_KE de de_AT de_BE de_CH de_DE de_IT de_LI de_LU dje dje_NE dsb dsb_DE dua dua_CM dyo dyo_SN dz dz_BT ebu ebu_KE ee ee_GH ee_TG el el_CY el_GR en en_001 en_150 en_AG en_AI en_AS en_AT en_AU en_BB en_BE en_BI en_BM en_BS en_BW en_BZ en_CA en_CC en_CH en_CK en_CM en_CX en_CY en_DE en_DG en_DK en_DM en_ER en_FI en_FJ en_FK en_FM en_GB en_GD en_GG en_GH en_GI en_GM en_GU en_GY en_HK en_IE en_IL en_IM en_IN en_IO en_JE en_JM en_KE en_KI en_KN en_KY en_LC en_LR en_LS en_MG en_MH en_MO en_MP en_MS en_MT en_MU en_MW en_MY en_NA en_NF en_NG en_NL en_NR en_NU en_NZ en_PG en_PH en_PK en_PN en_PR en_PW en_RW en_SB en_SC en_SD en_SE en_SG en_SH en_SI en_SL en_SS en_SX en_SZ en_TC en_TK en_TO en_TT en_TV en_TZ en_UG en_UM en_US en_US_POSIX en_VC en_VG en_VI en_VU en_WS en_ZA en_ZM en_ZW eo eo_001 es es_419 es_AR es_BO es_BR es_BZ es_CL es_CO es_CR es_CU es_DO es_EA es_EC es_ES es_GQ es_GT es_HN es_IC es_MX es_NI es_PA es_PE es_PH es_PR es_PY es_SV es_US es_UY es_VE et et_EE eu eu_ES ewo ewo_CM fa fa_AF fa_IR ff ff_Latn ff_Latn_BF ff_Latn_CM ff_Latn_GH ff_Latn_GM ff_Latn_GN ff_Latn_GW ff_Latn_LR ff_Latn_MR ff_Latn_NE ff_Latn_NG ff_Latn_SL ff_Latn_SN fi fi_FI fil fil_PH fo fo_DK fo_FO fr fr_BE fr_BF fr_BI fr_BJ fr_BL fr_CA fr_CD fr_CF fr_CG fr_CH fr_CI fr_CM fr_DJ fr_DZ fr_FR fr_GA fr_GF fr_GN fr_GP fr_GQ fr_HT fr_KM fr_LU fr_MA fr_MC fr_MF fr_MG fr_ML fr_MQ fr_MR fr_MU fr_NC fr_NE fr_PF fr_PM fr_RE fr_RW fr_SC fr_SN fr_SY fr_TD fr_TG fr_TN fr_VU fr_WF fr_YT fur fur_IT fy fy_NL ga ga_IE gd gd_GB gl gl_ES gsw gsw_CH gsw_FR gsw_LI gu gu_IN guz guz_KE gv gv_IM ha ha_GH ha_NE ha_NG haw haw_US he he_IL hi hi_IN hr hr_BA hr_HR hsb hsb_DE hu hu_HU hy hy_AM ia ia_001 id id_ID ig ig_NG ii ii_CN is is_IS it it_CH it_IT it_SM it_VA ja ja_JP jgo jgo_CM jmc jmc_TZ jv jv_ID ka ka_GE kab kab_DZ kam kam_KE kde kde_TZ kea kea_CV khq khq_ML ki ki_KE kk kk_KZ kkj kkj_CM kl kl_GL kln kln_KE km km_KH kn kn_IN ko ko_KP ko_KR kok kok_IN ks ks_IN ksb ksb_TZ ksf ksf_CM ksh ksh_DE ku ku_TR kw kw_GB ky ky_KG lag lag_TZ lb lb_LU lg lg_UG lkt lkt_US ln ln_AO ln_CD ln_CF ln_CG lo lo_LA lrc lrc_IQ lrc_IR lt lt_LT lu lu_CD luo luo_KE luy luy_KE lv lv_LV mas mas_KE mas_TZ mer mer_KE mfe mfe_MU mg mg_MG mgh mgh_MZ mgo mgo_CM mi mi_NZ mk mk_MK ml ml_IN mn mn_MN mr mr_IN ms ms_BN ms_MY ms_SG mt mt_MT mua mua_CM my my_MM mzn mzn_IR naq naq_NA nb nb_NO nb_SJ nd nd_ZW nds nds_DE nds_NL ne ne_IN ne_NP nl nl_AW nl_BE nl_BQ nl_CW nl_NL nl_SR nl_SX nmg nmg_CM nn nn_NO nnh nnh_CM nus nus_SS nyn nyn_UG om om_ET om_KE or or_IN os os_GE os_RU pa pa_Arab pa_Arab_PK pa_Guru pa_Guru_IN pl pl_PL prg prg_001 ps ps_AF pt pt_AO pt_BR pt_CH pt_CV pt_GQ pt_GW pt_LU pt_MO pt_MZ pt_PT pt_ST pt_TL qu qu_BO qu_EC qu_PE rm rm_CH rn rn_BI ro ro_MD ro_RO rof rof_TZ ru ru_BY ru_KG ru_KZ ru_MD ru_RU ru_UA rw rw_RW rwk rwk_TZ sah sah_RU saq saq_KE sbp sbp_TZ sd sd_PK se se_FI se_NO se_SE seh seh_MZ ses ses_ML sg sg_CF shi shi_Latn shi_Latn_MA shi_Tfng shi_Tfng_MA si si_LK sk sk_SK sl sl_SI smn smn_FI sn sn_ZW so so_DJ so_ET so_KE so_SO sq sq_AL sq_MK sq_XK sr sr_Cyrl sr_Cyrl_BA sr_Cyrl_ME sr_Cyrl_RS sr_Cyrl_XK sr_Latn sr_Latn_BA sr_Latn_ME sr_Latn_RS sr_Latn_XK sv sv_AX sv_FI sv_SE sw sw_CD sw_KE sw_TZ sw_UG ta ta_IN ta_LK ta_MY ta_SG te te_IN teo teo_KE teo_UG tg tg_TJ th th_TH ti ti_ER ti_ET tk tk_TM to to_TO tr tr_CY tr_TR tt tt_RU twq twq_NE tzm tzm_MA ug ug_CN uk uk_UA ur ur_IN ur_PK uz uz_Arab uz_Arab_AF uz_Cyrl uz_Cyrl_UZ uz_Latn uz_Latn_UZ vai vai_Latn vai_Latn_LR vai_Vaii vai_Vaii_LR vi vi_VN vo vo_001 vun vun_TZ wae wae_CH wo wo_SN xh xh_ZA xog xog_UG yav yav_CM yi yi_001 yo yo_BJ yo_NG yue yue_Hans yue_Hans_CN yue_Hant yue_Hant_HK zgh zgh_MA zh zh_Hans zh_Hans_CN zh_Hans_HK zh_Hans_MO zh_Hans_SG zh_Hant zh_Hant_HK zh_Hant_MO zh_Hant_TW zu zu_ZA>;
@languages .= sort(*.chars); # cheats to do baseline codes (en) over more
                             # more specific codes (en-US).  Every language
                             # should have a version that is *just* the base
                             # language code, even if it generally needs the
                             # scripti to be specified.

my $unit-separator = 31.chr; # Unit separator, as there is a chance that other
                            # common delimiters may get used in CLDR
my $group-separator = 30.chr; # Group separator, as there is a chance that other
                             # common delimiters may get used in CLDR
my $file = open "NumberPatterns.data", :w;
put "Generating number formatting list.  Please be patient.";

my $completed = 0;
my $total = +@languages;
@languages.push("root");
my $processed;

my %symbols-storage;
my %symbols;
my %symbols-alias;

my %literals;
my @literals;
my @script-alias;
my @length-alias;
my @pattern-alias;
my %pattern-storage;

my %default-systems;

for @languages -> $language is rw {
  print "\rProcessing $language ({$completed++} of $total)";


  my $xml;
  try {
    next unless $xml = open-xml("main/{$language}.xml");
  }
  CATCH { next }
  $language .= subst("_","-"); # CLDR uses underscores, langauge tags use hyphens
  next unless my $numbers-xml = $xml.elements(:TAG<numbers>);
  my $numbers = $numbers-xml.first;
  #my $numbers = open-xml("main/root.xml").getElementsByTagName('numbers').first;


  # get the default numbering systems
  if my $default-numbering-system = $numbers.elements(:TAG<defaultNumberingSystem>) {
    $default-numbering-system = $default-numbering-system.first.contents.join;
  } else {
    $default-numbering-system = "latn"; # Latn is default default
  }
  %default-systems{$language} = $default-numbering-system;
  # To minimize memory use, each symbol set is joined with a unit separator.
  # Aliases will be sorted separately to ensure they always point to a valid
  # location.  Hard references are stored as a numeric index in the unique @symbols
  # array.  When the complete loop has been run aliases will be resolved and then
  # written to the file.
  for $numbers.getElementsByTagName('symbols') {
    # Go through each symbol set, generally just one system.
      my $script = .<numberSystem> // $default-numbering-system;
      if my $alias = has-alias($_) {
        %symbols-alias{$language}{$script} = $alias;
        next;
      }
      # if attribute 'numberSystem' is not defined, then it's for the default system
      #%symbols{$script} = parse-number-system-symbols($symbol)     if $symbol<numberSystem>;
      my $symbol-set = parse-number-system-symbols($_)<decimal group list
              percentSign minusSign plusSign exponential superscriptingExponent
              perMille infinity nan timeSeparator>.join($unit-separator);
      %symbols-storage{$symbol-set} = %symbols-storage.elems unless %symbols-storage.keys.any eq $symbol-set;
      %symbols{$language}{$script} = %symbols-storage{$symbol-set};

  }


  format:
  for <decimal scientific percent> -> $format { # skip currency for now

    my %patterns;
    script:
    for $numbers.elements(:TAG("{$format}Formats")) {#}-> $script-xml {

      my $script = .<numberSystem> // $default-numbering-system;

      if my $alias = has-alias($_) {
        @script-alias.push("sys->{$language}:{$format}:$script:$alias");
        next script;
      }

      length:
      for .getElementsByTagName("{$format}FormatLength") {
        my $length = .<type> // 'standard';

        if my $alias = has-alias($_) {
          @length-alias.push("lng->{$language}:{$format}:$script:$length:$alias");
          next length;
        }

        for .getElementsByTagName("{$format}Format") -> $format-xml {
          # I think there should only ever be one $format, but I'm not going to swear to it
          pattern:
          for $format-xml.getElementsByTagName('pattern') -> $pattern {
            # shorts are the only ones that tend to have more than one

            my $count = $pattern<count> // 'other';
            my $type  = $pattern<type>  // 'standard';
            my $p     = $pattern.first.contents.join;

            if my $alias = has-alias($pattern) {
              # I don't think this should ever hit so we'll die if it does and let
              # a future developer --probably me-- deal with it 🤷🏼‍♂️
              die;
            }
            %literals{$language}{$format}{$script}{$length}{$type}{$count} = $p;
          }
        }
      }
    }
  }
  $processed++;
}




# Resolve the symbols aliasing
# It would be possible to do a final optimization of the symbols hash.
# If the same symbol set is used for the default, it can probably be safely removed
# since things would fall back to the script default
for %symbols-alias.keys -> $language {
  for %symbols-alias{$language}.keys -> $script {
    %symbols{$language}{$script} = %symbols{$language}{  %symbols-alias{$language}{$script}  }
  }
}

$file = open "NumericSymbols.data", :w;
$file.say(%symbols-storage.pairs.sort(*.value).map(*.key).join("\n"));
$file.close;

# Each system gets printed with, basically, the line index of the previous.
# Upon import, it can be bound to the symbol sets.
$file = open "NumberSystems.data", :w;
# sorting isn't strictly necessary for the number systems.
for %symbols.keys.sort(*.chars) -> $language {
  for %symbols{$language}.keys -> $script {
    $file.say($language ~ ':' ~ $script ~ ':' ~ %symbols{$language}{$script})
  }
}
$file.close;

# Now we create a list of all pattern data.  This is to test to see just how much
# compression could potentially happen.
my @patterns = %literals.values      # languages
                .map(*.values).flat  # formats
                .map(*.values).flat  # systems
                .map(*.values).flat  # lengths
                .map(*.values).flat  # types
                .map(*.values).flat; # counts
                .map(*.values).flat; # patterns
say "There were ", @patterns.elems, " patterns in total.  ";
@patterns = @patterns.unique;
say "Of these, ", @patterns.elems, " patterns were unique.";
my %pattern-table;
   %pattern-table{$_} = $++ for @patterns;

$file = open "NumberPatterns.data", :w;
$file.say($_) for @patterns;
$file.close;

$file = open "NumberSystemsDefault.data", :w;
for %default-systems.kv -> $language, $system {
  $file.say("{$language}:{$system}");
}
$file.close;



# The next step is to create a file in resources/NumberPatterns for EACH
# language.  This will minimize the amount of data that must be loaded at
# any given time.
for %literals.kv -> $language, %lang-data {
  $file = open "NumberPatterns/{$language}.data", :w;
  for multikey(%lang-data,5,:values) -> $format, $system, $length, $type, $count, $pattern {
    $file.say: "{$format}:{$system}:{$length}:{$type}:{$count}:" ~ %pattern-table{$pattern};
  }
  $file.close;
}


#$file.say($_) for @literals;
#$file.say($_) for @length-alias.sort(*.chars);
#$file.say($_) for @script-alias.sort(*.chars);
#$file.close;
say "Finished parsing language files.  $processed languages had number data.";
say "Now parsing number systems...";
my @systems = open-xml("supplemental/numberingSystems.xml").getElementsByTagName('numberingSystem');
$file = open "DecimalSystems.data", :w;
for @systems -> $system {
  if $system<type> eq 'numeric' {
    $file.say( $system<id> ~ ':' ~ $system<digits> );
  }
}



sub has-alias ($element) {
  if my $alias = $element.elements(:TAG<alias>) {
    return $alias.first<path>.split("'")[1].subst("_","-");
  }
  return False;
}



sub parse-number-system-symbols ($symbols) {
  if my $alias = $symbols.getElementsByTagName('alias') {
    # it is aliased.  Aliases in this case take on the form of
    # <alias source="locale" path="../symbols[@numberSystem='latn']"/>
    my $path = $alias.first<path>.split("'")[1];
    #say "Alias to $path";
    return %(alias => $path);
  }
  %(                                                                     # default value from root
    decimal       => (tag-contents($symbols, 'decimal')                         // '.'),
    group         => (tag-contents($symbols, 'group')                           // ','),
    list          => (tag-contents($symbols, 'list')                            // ';'),
    percentSign   => (tag-contents($symbols, 'percentSign')                     // '%'),
    plusSign      => (tag-contents($symbols, 'plusSign')                        // '+'),
    minusSign     => (tag-contents($symbols, 'minusSign')                       // '-'),
    exponential   => (tag-contents($symbols, 'exponential')                     // 'E'),
    superscriptingExponent => (tag-contents($symbols, 'superscriptingExponent') // '×'),
    perMille      => (tag-contents($symbols, 'perMille')                        // '‰'),
    infinity      => (tag-contents($symbols, 'infinity')                        // '∞'),
    nan           => (tag-contents($symbols, 'nan')                             // 'NaN'),
    timeSeparator => (tag-contents($symbols, 'timeSeparator')                   // ':'),
  )
}

sub tag-contents($parent, $name) {
  if my $children = $parent.getElementsByTagName($name) {
    return $children.first.contents.join;
  } else {
    #say "Could not find $name";
    return Nil;
  }
}

sub multikey ($h, $levels, *@p, :$values = False) {
	gather {
		for $h.kv -> $k, $v {
			take $_ for $levels - 1
				?? multikey($v, $levels - 1, |@p, $k,:$values)
				!! (|@p, $k, ($v if $values))
		}
	}
}
