use XML;
use Intl::BCP47;

# When testing, try using just en / es / ja or something similar.
# Also note that the main file includes a ROOT file, this should be NOT be
# included in this list of language (beware if you're doing ls -1 to generate!)
my @languages = <af af_NA af_ZA agq agq_CM ak ak_GH am am_ET ar ar_001 ar_AE ar_BH ar_DJ ar_DZ ar_EG ar_EH ar_ER ar_IL ar_IQ ar_JO ar_KM ar_KW ar_LB ar_LY ar_MA ar_MR ar_OM ar_PS ar_QA ar_SA ar_SD ar_SO ar_SS ar_SY ar_TD ar_TN ar_YE as as_IN asa asa_TZ ast ast_ES az az_Cyrl az_Cyrl_AZ az_Latn az_Latn_AZ bas bas_CM be be_BY bem bem_ZM bez bez_TZ bg bg_BG bm bm_ML bn bn_BD bn_IN bo bo_CN bo_IN br br_FR brx brx_IN bs bs_Cyrl bs_Cyrl_BA bs_Latn bs_Latn_BA ca ca_AD ca_ES ca_ES_VALENCIA ca_FR ca_IT ccp ccp_BD ccp_IN ce ce_RU cgg cgg_UG chr chr_US ckb ckb_IQ ckb_IR cs cs_CZ cu cu_RU cy cy_GB da da_DK da_GL dav dav_KE de de_AT de_BE de_CH de_DE de_IT de_LI de_LU dje dje_NE dsb dsb_DE dua dua_CM dyo dyo_SN dz dz_BT ebu ebu_KE ee ee_GH ee_TG el el_CY el_GR en en_001 en_150 en_AG en_AI en_AS en_AT en_AU en_BB en_BE en_BI en_BM en_BS en_BW en_BZ en_CA en_CC en_CH en_CK en_CM en_CX en_CY en_DE en_DG en_DK en_DM en_ER en_FI en_FJ en_FK en_FM en_GB en_GD en_GG en_GH en_GI en_GM en_GU en_GY en_HK en_IE en_IL en_IM en_IN en_IO en_JE en_JM en_KE en_KI en_KN en_KY en_LC en_LR en_LS en_MG en_MH en_MO en_MP en_MS en_MT en_MU en_MW en_MY en_NA en_NF en_NG en_NL en_NR en_NU en_NZ en_PG en_PH en_PK en_PN en_PR en_PW en_RW en_SB en_SC en_SD en_SE en_SG en_SH en_SI en_SL en_SS en_SX en_SZ en_TC en_TK en_TO en_TT en_TV en_TZ en_UG en_UM en_US en_US_POSIX en_VC en_VG en_VI en_VU en_WS en_ZA en_ZM en_ZW eo eo_001 es es_419 es_AR es_BO es_BR es_BZ es_CL es_CO es_CR es_CU es_DO es_EA es_EC es_ES es_GQ es_GT es_HN es_IC es_MX es_NI es_PA es_PE es_PH es_PR es_PY es_SV es_US es_UY es_VE et et_EE eu eu_ES ewo ewo_CM fa fa_AF fa_IR ff ff_Latn ff_Latn_BF ff_Latn_CM ff_Latn_GH ff_Latn_GM ff_Latn_GN ff_Latn_GW ff_Latn_LR ff_Latn_MR ff_Latn_NE ff_Latn_NG ff_Latn_SL ff_Latn_SN fi fi_FI fil fil_PH fo fo_DK fo_FO fr fr_BE fr_BF fr_BI fr_BJ fr_BL fr_CA fr_CD fr_CF fr_CG fr_CH fr_CI fr_CM fr_DJ fr_DZ fr_FR fr_GA fr_GF fr_GN fr_GP fr_GQ fr_HT fr_KM fr_LU fr_MA fr_MC fr_MF fr_MG fr_ML fr_MQ fr_MR fr_MU fr_NC fr_NE fr_PF fr_PM fr_RE fr_RW fr_SC fr_SN fr_SY fr_TD fr_TG fr_TN fr_VU fr_WF fr_YT fur fur_IT fy fy_NL ga ga_IE gd gd_GB gl gl_ES gsw gsw_CH gsw_FR gsw_LI gu gu_IN guz guz_KE gv gv_IM ha ha_GH ha_NE ha_NG haw haw_US he he_IL hi hi_IN hr hr_BA hr_HR hsb hsb_DE hu hu_HU hy hy_AM ia ia_001 id id_ID ig ig_NG ii ii_CN is is_IS it it_CH it_IT it_SM it_VA ja ja_JP jgo jgo_CM jmc jmc_TZ jv jv_ID ka ka_GE kab kab_DZ kam kam_KE kde kde_TZ kea kea_CV khq khq_ML ki ki_KE kk kk_KZ kkj kkj_CM kl kl_GL kln kln_KE km km_KH kn kn_IN ko ko_KP ko_KR kok kok_IN ks ks_IN ksb ksb_TZ ksf ksf_CM ksh ksh_DE ku ku_TR kw kw_GB ky ky_KG lag lag_TZ lb lb_LU lg lg_UG lkt lkt_US ln ln_AO ln_CD ln_CF ln_CG lo lo_LA lrc lrc_IQ lrc_IR lt lt_LT lu lu_CD luo luo_KE luy luy_KE lv lv_LV mas mas_KE mas_TZ mer mer_KE mfe mfe_MU mg mg_MG mgh mgh_MZ mgo mgo_CM mi mi_NZ mk mk_MK ml ml_IN mn mn_MN mr mr_IN ms ms_BN ms_MY ms_SG mt mt_MT mua mua_CM my my_MM mzn mzn_IR naq naq_NA nb nb_NO nb_SJ nd nd_ZW nds nds_DE nds_NL ne ne_IN ne_NP nl nl_AW nl_BE nl_BQ nl_CW nl_NL nl_SR nl_SX nmg nmg_CM nn nn_NO nnh nnh_CM nus nus_SS nyn nyn_UG om om_ET om_KE or or_IN os os_GE os_RU pa pa_Arab pa_Arab_PK pa_Guru pa_Guru_IN pl pl_PL prg prg_001 ps ps_AF pt pt_AO pt_BR pt_CH pt_CV pt_GQ pt_GW pt_LU pt_MO pt_MZ pt_PT pt_ST pt_TL qu qu_BO qu_EC qu_PE rm rm_CH rn rn_BI ro ro_MD ro_RO rof rof_TZ ru ru_BY ru_KG ru_KZ ru_MD ru_RU ru_UA rw rw_RW rwk rwk_TZ sah sah_RU saq saq_KE sbp sbp_TZ sd sd_PK se se_FI se_NO se_SE seh seh_MZ ses ses_ML sg sg_CF shi shi_Latn shi_Latn_MA shi_Tfng shi_Tfng_MA si si_LK sk sk_SK sl sl_SI smn smn_FI sn sn_ZW so so_DJ so_ET so_KE so_SO sq sq_AL sq_MK sq_XK sr sr_Cyrl sr_Cyrl_BA sr_Cyrl_ME sr_Cyrl_RS sr_Cyrl_XK sr_Latn sr_Latn_BA sr_Latn_ME sr_Latn_RS sr_Latn_XK sv sv_AX sv_FI sv_SE sw sw_CD sw_KE sw_TZ sw_UG ta ta_IN ta_LK ta_MY ta_SG te te_IN teo teo_KE teo_UG tg tg_TJ th th_TH ti ti_ER ti_ET tk tk_TM to to_TO tr tr_CY tr_TR tt tt_RU twq twq_NE tzm tzm_MA ug ug_CN uk uk_UA ur ur_IN ur_PK uz uz_Arab uz_Arab_AF uz_Cyrl uz_Cyrl_UZ uz_Latn uz_Latn_UZ vai vai_Latn vai_Latn_LR vai_Vaii vai_Vaii_LR vi vi_VN vo vo_001 vun vun_TZ wae wae_CH wo wo_SN xh xh_ZA xog xog_UG yav yav_CM yi yi_001 yo yo_BJ yo_NG yue yue_Hans yue_Hans_CN yue_Hant yue_Hant_HK zgh zgh_MA zh zh_Hans zh_Hans_CN zh_Hans_HK zh_Hans_MO zh_Hans_SG zh_Hant zh_Hant_HK zh_Hant_MO zh_Hant_TW zu zu_ZA>;

@languages .= sort(*.chars); # cheats to do baseline codes (en) over more
                             # more specific codes (en-US).  Every language
                             # should have a version that is *just* the base
                             # language code, even if it generally needs the
                             # scripti to be specified.
my $file = open "ListFormatting.data", :w;
put "Generating language list.  Please be patient.";
my $completed = 0;
my $total = +@languages;

my $start-vals = 0;
my $middle-vals = 0;
my $end-vals = 0;

my %data;

for @languages -> $language {
  print "\r{$completed++} of $total: $language";
  my $language-tag = LanguageTag.new($language.subst("_","-",:g)).canonical;
  my $xml;
  try {
    $xml = open-xml("main/{$language}.xml");
  }
  # Skip if the XML file is invalid or if the ListPattern element is not found
  next unless $xml;
  next unless my @listPatterns = $xml.getElementsByTagName('listPatterns');

  my @types = @listPatterns.first.getElementsByTagName('listPattern');
  my %lang-data;
  if !(my $offset = $language-tag.rindex('-')) {
    # Base language codes should have all available information
    #say "Language $language does not have six format types! (found {+@types})" unless @types == 6;
    # this is the ROOT data, which is the default
    %lang-data = (
      and => %(
        start  => ", ",
        middle => ", ",
        end    => ", ",
        2      => ", "
      ),
      or => %(
        start  => ", "   ,
        middle => ", "   ,
        end    => ", or ",
        2      =>  " or "
      )
    );
  }else{
    # Regional / etc should copy over the data from the base local before modifying.
    # For some weird reason .clone wasn't working — even when doing a psuedo-deep clone.
    # So we just manually populate it string by string. =\
    if %data{$language-tag.substr(0,$offset)}:exists {
      for %data{$language-tag.substr(0,$offset)}.keys -> $type {
        for %data{$language-tag.substr(0,$offset)}{$type}.keys -> $format {
          %lang-data{$type}{$format} = ~%data{$language-tag.substr(0,$offset)}{$type}{$format};
        }
      }
    }else{
      # use root data if not available
      %lang-data = (
        and => %(
          start  => ", ",
          middle => ", ",
          end    => ", ",
          2      => ", "
        ),
        or => %(
          start  => ", "   ,
          middle => ", "   ,
          end    => ", or ",
          2      =>  " or "
        )
      );
    }
  }



  for @types -> $type {
    my $style-type = $type.attribs<type> // 'and';
    my @formats = $type.getElementsByTagName('listPatternPart');
    for @formats -> $format {
      my $format-type = $format.attribs<type>;
      my $pattern = $format.nodes.first.Str;

      $pattern  ~~ (/'{'(\d+)'}'/);

      # Only ONE language uses a reverse order. (ur-IN)
      # I am 99.99% sure that this is an error, because the two are consistently
      # swapped in all definitions.  Therefore, while I check for this for
      # parsing completeness, it won't be stored or used in formatting.
      my $logical-order = $0 eq '0';
      say "\rLanguage $language has a ListFormatting reverse order. "              unless $logical-order;
      say "  * ListFormatting parser must be updated if not a mistake in the XML." unless $logical-order;

      # No language has any text before the {0} element.  But just in case,
      # we check for it and output an warning.
      my $start  = $pattern.substr(0,$/.from);
      say "\rLanguage $language has a ListFormatting start string: '$start' (code {$start.ords.join(" ")})" if $start;
      say "  * ListFormatting parser must be updated if not a mistake in the XML."                if $start;

      $pattern  .= substr($/.to);
      $pattern  ~~ (/'{'(\d+)'}'/);
      my $middle = $pattern.substr(0,$/.from);

      # Only ONE language has any text before the {1} element (am).
      # I am 99.99% sure that this is an error, because it's a BOM (U+FEFF)
      # found in two of definitions.  Therefore, while I check for this for
      # parsing completeness, it won't be stored or used in formatting.
      my $end    = $pattern.substr($/.to);
      say "\rLanguage $language has a ListFormatting end string: '$end' (codes {$end.ords.join(" ")})" if $end;
      say "  * ListFormatting parser must be updated if not a mistake in the XML."        if $end;

      # As mentioned elsewhere in the comments, ultimately this is the only
      # string we need for the languages in CLDR at the time of writing the
      # parser.
      %lang-data{$style-type}{$format-type} = $middle;

      %data{$language-tag} = %lang-data;
    }
  }
}
say "\r$total of $total: XML parsing complete.";
print "Generating ListFormatting.data file … ";
for %data.keys -> $language {
  for %data{$language}.keys -> $style {
    for %data{$language}{$style}.keys -> $type {
        $file.say("$language:$style:$type:", %data{$language}{$style}{$type})
    }
  }
}
say "Done.";
$file.close;
