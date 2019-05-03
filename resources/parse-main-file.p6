use XML;
use MONKEY-SEE-NO-EVAL;
use Intl::BCP47;
# With apologies to anyone who has to read this.  Because of the way that the CLDR XML file is
# written, it's not possible to just quickly flatten it.  The <alias> tag could be resolved
# fully, but then the data files will be much larger (and upon import, much larger).  But because
# some of the elements are redundant (<decimalFormat>) and others need to be grouped by tag name
# *and* type (<decimalFormats>), the import isn't fully straightforward.
# Additionally, some of the elements (in characters, for instance), are better to be preprocessed
# here rather than written wholesale.
#
# There are a number of subs used here to keep things simple:
#  - elem $xml, $tag
#    Returns a single child element matching the tag when we know there will be only one element.
#  - elems $xml, $tags
#    Returns a child elements matching the tag
#  - contents $xml
#    Returns the text content of the tag
#  - check-alias $xml
#    If the tag is an alias, returns its selection elements (the initial path is, thankfully,
#    predictable.
#  - safe %hash, *@keys
#    Originally developed when I loaded base languages over the root (which isn't actually as
#    predictable as one might want), this ensures that a scalar value is suppressed and replaced
#    with an Hash to ensure nested assignments work properly.
#
# In many cases, I have left certain die commands in areas where it's theoretically possible for
# values to exist, but I have not encountered them yet (this is particularly notable with the
# elem($xml,$tag) sub, which will die if it detects more than one element.

my %results;

my $sep  = 31.chr; # These separators are used to avoid clashing with any
my $sep2 = 30.chr; # character that might actually be used (colons, commas,
my $sep3 = 29.chr; # spaces, etc).  Use $sep whenever possible, $sep2 for nested
my $sep4 = 28.chr; # data, $sep3 for double nested, and so on.

class Alias {
  has @.components;
  method new(*@components) { self.bless(:@components) }
  method gist {
    "\e[2m→ " ~ @.components.grep(* !~~ ::('Tags')).join('→') ~ "\e[0m"
  }
}
enum Tags <
    alias
    localeDisplayNames
        localeDisplayPattern
            localePattern localeSeparator localeKeyTypePattern
        measurementSystemNames measurementSystemName
        codePatterns codePattern
        languages language
        scripts script
        territories territory
        variants variant
    layout orientation
        characterOrder lineOrder
    characters
        exemplarCharacters ellipsis
        moreInformation parseLenients parseLenient
    delimiters
        quotationStart quotationEnd alternateQuotationStart alternateQuotationEnd
    dates
        calendars calendar
            months month
                monthContext monthWidth
                monthPatterns monthPattern monthPatternContext monthPatternWidth
            days day
                dayContext dayWidth
            quarters quarter
                quarterContext quarterWidth
            dayPeriods dayPeriod
                dayPeriodContext dayPeriodWidth
            eras era
                eraAbbr eraNames eraNarrow
            cyclicNameSets cyclicNameSet
                cyclicNameContext cyclicNameWidth
            dateFormats dateFormat dateFormatLength
            timeFormats timeFormat timeFormatLength
            dateTimeFormats dateTimeFormat dateTimeFormatLength
                availableFormats
                pattern patterns dateFormatItem
                appendItems appendItem
            intervalFormats intervalFormatItem intervalFormatFallback greatestDifference
        fields field
            displayName
            relative relativeTime relativeTimePattern
        timeZoneNames
            hourFormat gmtFormat gmtZeroFormat regionFormat fallbackFormat
            zone short exemplarCity
    numbers
        defaultNumberingSystem
        otherNumberingSystems
            native traditional finance
        minimumGroupingDigits
        symbols
            decimal group list percentSign plusSign minusSign exponential
            superscriptingExponent perMille infinity nan timeSeparator
        decimalFormats decimalFormat decimalFormatLength
        scientificFormats scientificFormat scientificFormatLength
        percentFormats percentFormat percentFormatLength
        currencyFormats currencyFormat currencyFormatLength
            currencySpacing beforeCurrency afterCurrency currencyMatch surroundingMatch insertBetween
        currencies
            currency symbol
        miscPatterns
        minimalPairs pluralMinimalPairs ordinalMinimalPairs
    units
        unitLength
        compoundUnit compoundUnitPattern
        unit unitPattern perUnitPattern
        coordinateUnit coordinateUnitPattern
        durationUnit durationUnitPattern
    listPatterns
        listPattern listPatternPart
    posix
        messages yesstr nostr
    characterLabels
        characterLabel characterLabelPattern
    typographicNames
        axisName styleName featureName


>; # ^^ All the tags after the space are actually ones that are extremely common and should be
   #    abbreviated to save space down the road.

my @languages = <af af_NA af_ZA agq agq_CM ak ak_GH am am_ET ar ar_001 ar_AE ar_BH ar_DJ ar_DZ ar_EG ar_EH ar_ER ar_IL ar_IQ ar_JO ar_KM ar_KW ar_LB ar_LY ar_MA ar_MR ar_OM ar_PS ar_QA ar_SA ar_SD ar_SO ar_SS ar_SY ar_TD ar_TN ar_YE as as_IN asa asa_TZ ast ast_ES az az_Cyrl az_Cyrl_AZ az_Latn az_Latn_AZ bas bas_CM be be_BY bem bem_ZM bez bez_TZ bg bg_BG bm bm_ML bn bn_BD bn_IN bo bo_CN bo_IN br br_FR brx brx_IN bs bs_Cyrl bs_Cyrl_BA bs_Latn bs_Latn_BA ca ca_AD ca_ES ca_ES_VALENCIA ca_FR ca_IT ccp ccp_BD ccp_IN ce ce_RU cgg cgg_UG chr chr_US ckb ckb_IQ ckb_IR cs cs_CZ cu cu_RU cy cy_GB da da_DK da_GL dav dav_KE de de_AT de_BE de_CH de_DE de_IT de_LI de_LU dje dje_NE dsb dsb_DE dua dua_CM dyo dyo_SN dz dz_BT ebu ebu_KE ee ee_GH ee_TG el el_CY el_GR en en_001 en_150 en_AG en_AI en_AS en_AT en_AU en_BB en_BE en_BI en_BM en_BS en_BW en_BZ en_CA en_CC en_CH en_CK en_CM en_CX en_CY en_DE en_DG en_DK en_DM en_ER en_FI en_FJ en_FK en_FM en_GB en_GD en_GG en_GH en_GI en_GM en_GU en_GY en_HK en_IE en_IL en_IM en_IN en_IO en_JE en_JM en_KE en_KI en_KN en_KY en_LC en_LR en_LS en_MG en_MH en_MO en_MP en_MS en_MT en_MU en_MW en_MY en_NA en_NF en_NG en_NL en_NR en_NU en_NZ en_PG en_PH en_PK en_PN en_PR en_PW en_RW en_SB en_SC en_SD en_SE en_SG en_SH en_SI en_SL en_SS en_SX en_SZ en_TC en_TK en_TO en_TT en_TV en_TZ en_UG en_UM en_US en_US_POSIX en_VC en_VG en_VI en_VU en_WS en_ZA en_ZM en_ZW eo eo_001 es es_419 es_AR es_BO es_BR es_BZ es_CL es_CO es_CR es_CU es_DO es_EA es_EC es_ES es_GQ es_GT es_HN es_IC es_MX es_NI es_PA es_PE es_PH es_PR es_PY es_SV es_US es_UY es_VE et et_EE eu eu_ES ewo ewo_CM fa fa_AF fa_IR ff ff_Latn ff_Latn_BF ff_Latn_CM ff_Latn_GH ff_Latn_GM ff_Latn_GN ff_Latn_GW ff_Latn_LR ff_Latn_MR ff_Latn_NE ff_Latn_NG ff_Latn_SL ff_Latn_SN fi fi_FI fil fil_PH fo fo_DK fo_FO fr fr_BE fr_BF fr_BI fr_BJ fr_BL fr_CA fr_CD fr_CF fr_CG fr_CH fr_CI fr_CM fr_DJ fr_DZ fr_FR fr_GA fr_GF fr_GN fr_GP fr_GQ fr_HT fr_KM fr_LU fr_MA fr_MC fr_MF fr_MG fr_ML fr_MQ fr_MR fr_MU fr_NC fr_NE fr_PF fr_PM fr_RE fr_RW fr_SC fr_SN fr_SY fr_TD fr_TG fr_TN fr_VU fr_WF fr_YT fur fur_IT fy fy_NL ga ga_IE gd gd_GB gl gl_ES gsw gsw_CH gsw_FR gsw_LI gu gu_IN guz guz_KE gv gv_IM ha ha_GH ha_NE ha_NG haw haw_US he he_IL hi hi_IN hr hr_BA hr_HR hsb hsb_DE hu hu_HU hy hy_AM ia ia_001 id id_ID ig ig_NG ii ii_CN is is_IS it it_CH it_IT it_SM it_VA ja ja_JP jgo jgo_CM jmc jmc_TZ jv jv_ID ka ka_GE kab kab_DZ kam kam_KE kde kde_TZ kea kea_CV khq khq_ML ki ki_KE kk kk_KZ kkj kkj_CM kl kl_GL kln kln_KE km km_KH kn kn_IN ko ko_KP ko_KR kok kok_IN ks ks_IN ksb ksb_TZ ksf ksf_CM ksh ksh_DE ku ku_TR kw kw_GB ky ky_KG lag lag_TZ lb lb_LU lg lg_UG lkt lkt_US ln ln_AO ln_CD ln_CF ln_CG lo lo_LA lrc lrc_IQ lrc_IR lt lt_LT lu lu_CD luo luo_KE luy luy_KE lv lv_LV mas mas_KE mas_TZ mer mer_KE mfe mfe_MU mg mg_MG mgh mgh_MZ mgo mgo_CM mi mi_NZ mk mk_MK ml ml_IN mn mn_MN mr mr_IN ms ms_BN ms_MY ms_SG mt mt_MT mua mua_CM my my_MM mzn mzn_IR naq naq_NA nb nb_NO nb_SJ nd nd_ZW nds nds_DE nds_NL ne ne_IN ne_NP nl nl_AW nl_BE nl_BQ nl_CW nl_NL nl_SR nl_SX nmg nmg_CM nn nn_NO nnh nnh_CM nus nus_SS nyn nyn_UG om om_ET om_KE or or_IN os os_GE os_RU pa pa_Arab pa_Arab_PK pa_Guru pa_Guru_IN pl pl_PL prg prg_001 ps ps_AF pt pt_AO pt_BR pt_CH pt_CV pt_GQ pt_GW pt_LU pt_MO pt_MZ pt_PT pt_ST pt_TL qu qu_BO qu_EC qu_PE rm rm_CH rn rn_BI ro ro_MD ro_RO rof rof_TZ ru ru_BY ru_KG ru_KZ ru_MD ru_RU ru_UA rw rw_RW rwk rwk_TZ sah sah_RU saq saq_KE sbp sbp_TZ sd sd_PK se se_FI se_NO se_SE seh seh_MZ ses ses_ML sg sg_CF shi shi_Latn shi_Latn_MA shi_Tfng shi_Tfng_MA si si_LK sk sk_SK sl sl_SI smn smn_FI sn sn_ZW so so_DJ so_ET so_KE so_SO sq sq_AL sq_MK sq_XK sr sr_Cyrl sr_Cyrl_BA sr_Cyrl_ME sr_Cyrl_RS sr_Cyrl_XK sr_Latn sr_Latn_BA sr_Latn_ME sr_Latn_RS sr_Latn_XK sv sv_AX sv_FI sv_SE sw sw_CD sw_KE sw_TZ sw_UG ta ta_IN ta_LK ta_MY ta_SG te te_IN teo teo_KE teo_UG tg tg_TJ th th_TH ti ti_ER ti_ET tk tk_TM to to_TO tr tr_CY tr_TR tt tt_RU twq twq_NE tzm tzm_MA ug ug_CN uk uk_UA ur ur_IN ur_PK uz uz_Arab uz_Arab_AF uz_Cyrl uz_Cyrl_UZ uz_Latn uz_Latn_UZ vai vai_Latn vai_Latn_LR vai_Vaii vai_Vaii_LR vi vi_VN vo vo_001 vun vun_TZ wae wae_CH wo wo_SN xh xh_ZA xog xog_UG yav yav_CM yi yi_001 yo yo_BJ yo_NG yue yue_Hans yue_Hans_CN yue_Hant yue_Hant_HK zgh zgh_MA zh zh_Hans zh_Hans_CN zh_Hans_HK zh_Hans_MO zh_Hans_SG zh_Hant zh_Hant_HK zh_Hant_MO zh_Hant_TW zu zu_ZA>;
@languages = @languages.sort( *.chars );
@languages.unshift: 'root';

my $current-count = 1;
my $total-count = @languages.elems;
say "";
for @languages -> $l {

  my $lang = $l.subst('_','-', :g); # convert to standard
  unless $lang eq 'root' {
    $lang = LanguageTag.new($lang).canonical;
  }
  print "\e[1FProcessing language $lang ($current-count of $total-count)      \n  [ ] XML opened   [ ] XML processed       \r";
  my $file;
  try {
    $file = open-xml("main/{$l}.xml");
    CATCH { say "\e[1FNote: XML file for $l could not be opened                       \n"; next; }
  }
  next if $file.elements.elems == 1;
  print "\e[1FProcessing language $lang ($current-count of $total-count)\n  [√] XML opened   [ ] XML processed\r";

  try {
    given $lang.comb('-').elems {
      when  0 { %results{$lang} := Hash.new}
      default {
        %results{$lang} := %results{$lang.split('-')[0..*-2].join('-')}:exists # in a handful of instances, removing a single tag does not result in a valid match, but removing two ALWAYS does (for now);
            ?? hash-clone(%results{$lang.split('-')[0..*-2].join('-')})
            !! hash-clone(%results{$lang.split('-')[0..*-3].join('-')})
      }
    }
    CATCH { say "\e[1FNote: Could not load base data for $l (probably because the base XML file was unreadable)      \n"; next; }
  }

  my %m := %results{$lang};

  # Most of these should not be aliased
  with elem $file, localeDisplayNames {
    with elem $_, localeDisplayPattern {
      with elem $_, localePattern        {
        safe(%m,localeDisplayNames,localeDisplayPattern,localePattern) = contents $_;
      }
      with elem $_, localeSeparator      {
        safe(%m,localeDisplayNames,localeDisplayPattern,localeSeparator) = contents $_;
      }
      with elem $_, localeKeyTypePattern {
        safe(%m,localeDisplayNames,localeDisplayPattern,localeKeyTypePattern) = contents $_;
      }
    }
    with elem $_, measurementSystemNames {
      with elems $_, measurementSystemName {
        for @_ {
          safe(%m, localeDisplayNames,measurementSystemNames,$_<type>) = contents $_;
          resolve-alias $_;
        }
      }
    }
    with elem $_, codePatterns {
      with elems $_, codePattern {
        for @_ {
          safe(%m, localeDisplayNames,codePatterns,$_<type>) = contents $_ for @_;
          resolve-alias $_;
        }
      }
    }
    with elem $_, languages {
      with elems $_, language {
        safe(%m, localeDisplayNames,languages,$_<type>) = contents $_ for @_
      }
    }
    with elem $_, scripts {
      with elems $_, script {
        safe(%m, localeDisplayNames,scripts,$_<type>) = contents $_ for @_
      }
    }
    with elem $_, territories {
      with elems $_, territory {
        safe(%m, localeDisplayNames,territories,$_<type>) = contents $_ for @_
      }
    }
    with elem $_, variants {
      with elems $_, variant {
        safe(%m, localeDisplayNames,variants,$_<type>) = contents $_ for @_
      }
    }
  }

  # Layout orientation, should not be aliased
  with elem $file, layout {
    with elem $_, orientation {
      with elem $_, characterOrder { safe(%m, layout,characterOrder) = contents $_ }
      with elem $_, lineOrder      { safe(%m, layout,lineOrder)      = contents $_ }
    }
  }


  # Characters of sorts
  # Post import processing should probably be done here.  For now it is imported
  # as is (it provides a list of characters and they should be imported as a list,
  # and joined with a second-level delimiter).  Most of these should not have aliases. Die if found.
  with elem $file, characters {
    with elems $_, exemplarCharacters {
      # Can include ranges (e.g. a-e = a,b,c,d,e)
      safe(%m, characters,exemplarCharacters,($_<type> // 'standard')) = contents $_ for @_;
      if my %a = resolve-alias $_ { alias-die($_, %a) }
    }
    with elems $_, ellipsis {
      safe(%m, characters,ellipsis,$_<type>) = contents $_ for @_;
      if my %a = resolve-alias $_ { alias-die($_, %a) }
    }
    for elems $_, parseLenients {
      # This in particular needs heavy post processing
      my $scope = $_<scope>;
      my $level = $_<level>;
      for elems $_, parseLenient {
        safe(%m, localeDisplayNames,characters,parseLenients,$scope,$level,$_<sample>) = contents $_;
        if my %a = resolve-alias $_ { alias-die($_, %a) }
      }
      if my %a = resolve-alias $_ { alias-die($_, %a) }
    }
  }


  # Quotation Marks / delimiters.  Note sure why these are given separate elements
  # rather than type.
  with elem $file, delimiters {
    for quotationStart, quotationEnd, alternateQuotationStart, alternateQuotationEnd -> $type {
      with elem $_, $type {
        safe(%m, delimiters,$type) = contents $_
      }
    }
  }


  # The biggest of all
  with elem $file, dates {
    with elem $_, calendars {
      for elems $_, calendar {
        my $calendar-type = $_<type>; # buddhist, gregorian, etc

        with elem $_, months {
          if my %a = resolve-alias $_ {
            safe(%m, calendars,$calendar-type,months) = Alias.new(calendars, %a<calendar-type>, months);
          }else{
            for elems $_, monthContext {
              my $context-type = $_<type> // 'standard';
              if my %a = resolve-alias $_ {
                safe(%m, calendars,$calendar-type,months,$context-type) = Alias.new(calendars, $calendar-type, months, %a<monthContext-type>);
              }else{
                for elems $_, monthWidth {
                  my $width = $_<type> // 'standard';
                  if my %a = resolve-alias $_ {
                    safe(%m, calendars,$calendar-type,months,$context-type,$width) = Alias.new(calendars, $calendar-type, months, (%a<monthContext-type> // $context-type), %a<monthWidth-type>);
                  }else{
                    for elems $_, month {
                      if my %a = resolve-alias $_ { alias-die $_, %a };
                      safe(%m, calendars,$calendar-type,months,$context-type,$width,$_<type>) = contents $_;
                    }
                  }
                }
              }
            }
          }
        }

        with elem $_, days {
          if my %a = resolve-alias $_ {
            safe(%m, calendars,$calendar-type,days) = Alias.new(calendars, %a<calendar-type>, days);
          }else{
            for elems $_, dayContext {
              my $context-type = $_<type> // 'standard';
              if my %a = resolve-alias $_ {
                safe(%m, calendars,$calendar-type,days,$context-type) = Alias.new(calendars, $calendar-type, days, %a<dayContext-type>);
              }else{
                for elems $_, dayWidth {
                  my $width = $_<type> // 'standard';
                  if my %a = resolve-alias $_ {
                    safe(%m, calendars,$calendar-type,days,$context-type,$width) = Alias.new(calendars, $calendar-type, days, (%a<dayContext-type> // $context-type), %a<dayWidth-type>);
                  }else{
                    for elems $_, day {
                      if my %a = resolve-alias $_ { alias-die $_, %a };
                      safe(%m, calendars,$calendar-type,days,$context-type,$width,$_<type>) = contents $_;
                    }
                  }
                }
              }
            }
          }
        }

        with elem $_, quarters {
          if my %a = resolve-alias $_ {
            safe(%m, calendars,$calendar-type,quarters) = Alias.new(calendars, %a<calendar-type>, quarters);
          }else{
            for elems $_, quarterContext {
              my $context-type = $_<type> // 'standard';
              if my %a = resolve-alias $_ {
                safe(%m, calendars,$calendar-type,quarters,$context-type) = Alias.new(calendars, $calendar-type, quarters, %a<quarterContext-type>);
              }else{
                for elems $_, quarterWidth {
                  my $width = $_<type> // 'standard';
                  if my %a = resolve-alias $_ {
                    safe(%m, calendars,$calendar-type,quarters,$context-type,$width) = Alias.new(calendars, $calendar-type, quarters, (%a<quarterContext-type> // $context-type), %a<quarterWidth-type>);
                  }else{
                    for elems $_, quarter {
                      if my %a = resolve-alias $_ { alias-die $_, %a };
                      safe(%m, calendars,$calendar-type,quarters,$context-type,$width,$_<type>) = contents $_;
                    }
                  }
                }
              }
            }
          }
        }


        with elem $_, dayPeriods {
          if my %a = resolve-alias $_ {
            #%m{calendars}{$calendar-type}{dayPeriods} = Alias.new(calendars, %a<calendar-type>, dayPeriods);
            safe(%m, calendars,$calendar-type,dayPeriods) = Alias.new(calendars, %a<calendar-type>, dayPeriods);
          }else{
            for elems $_, dayPeriodContext {
              my $context-type = $_<type> // 'standard';
              if my %a = resolve-alias $_ {
                #%m{calendars}{$calendar-type}{dayPeriods}{$context-type} = Alias.new(calendars, $calendar-type, dayPeriods, %a<dayPeriodContext-type>);
                safe(%m, calendars,$calendar-type,dayPeriods,$context-type) = Alias.new(calendars, $calendar-type, dayPeriods, %a<dayPeriodContext-type>);
              }else{
                for elems $_, dayPeriodWidth {
                  my $width = $_<type> // 'standard';
                  if my %a = resolve-alias $_ {
                    #%m{calendars}{$calendar-type}{dayPeriods}{$context-type}{$width} = Alias.new(calendars, $calendar-type, dayPeriods, (%a<dayPeriodContext-type> // $context-type), %a<dayPeriodWidth-type>);
                    safe(%m, calendars,$calendar-type,dayPeriods,$context-type,$width) = Alias.new(calendars, $calendar-type, dayPeriods, (%a<dayPeriodContext-type> // $context-type), %a<dayPeriodWidth-type>);
                  }else{
                    for elems $_, dayPeriod {
                      if my %a = resolve-alias $_ { alias-die $_, %a };
                      #%m{calendars}{$calendar-type}{dayPeriods}{$context-type}{$width}{$_<type>} = contents $_;
                      safe(%m, calendars,$calendar-type,dayPeriods,$context-type,$width,$_<type>) = contents $_;
                    }
                  }
                }
              }
            }
          }
        }

        with elem $_, eras {
          with elem $_, eraAbbr {
            for elems $_, era {
              if my %a = resolve-alias $_ {
                #%m{calendars}{$calendar-type}{eras}{eraAbbr} = Alias.new(calendars, $calendar-type, eras, %a<eraNames> ?? eraNames !! eraNarrow )
                %m{calendars}{$calendar-type}{eras}{eraAbbr} = Alias.new(calendars, $calendar-type, eras, %a<eraNames> ?? eraNames !! eraNarrow )
              }else{
                #%m{calendars}{$calendar-type}{eras}{eraAbbr}{$_<type>} = contents $_;
                %m{calendars}{$calendar-type}{eras}{eraAbbr}{$_<type>} = contents $_;
              }
            }
          }
          with elem $_, eraNames {
            for elems $_, era {
              if my %a = resolve-alias $_ {
                #%m{calendars}{$calendar-type}{eras}{eraNames} = Alias.new(calendars, $calendar-type, eras, %a<eraAbbr> ?? eraAbbr !! eraNarrow)
                safe(%m, calendars,$calendar-type,eras,eraNames) = Alias.new(calendars, $calendar-type, eras, %a<eraAbbr> ?? eraAbbr !! eraNarrow)
              }else{
                #%m{calendars}{$calendar-type}{eras}{eraNames}{$_<type>} = contents $_;
                safe(%m, calendars,$calendar-type,eras,eraNames,$_<type>) = contents $_;
              }
            }
          }
          with elem $_, eraNarrow {
            for elems $_, era {
              if my %a = resolve-alias $_ {
                #%m{calendars}{$calendar-type}{eras}{eraNarrow} = Alias.new(calendars, $calendar-type, eras, %a<eraAbbr> ?? eraAbbr !! eraNames)
                safe(%m, calendars,$calendar-type,eras,eraNarrow) = Alias.new(calendars, $calendar-type, eras, %a<eraAbbr> ?? eraAbbr !! eraNames)
              }else{
                #%m{calendars}{$calendar-type}{eras}{eraNarrow}{$_<type>} = contents $_;
                safe(%m, calendars,$calendar-type,eras,eraNarrow,$_<type>) = contents $_;
              }
            }
          }
        }

        with elem $_, dateFormats {
          if my %a = resolve-alias $_ {
            #%m{calendars}{$calendar-type}{dateFormats} = Alias.new(calendars,%a<calendar-type>)
            safe(%m, calendars,$calendar-type,dateFormats) = Alias.new(calendars,%a<calendar-type>, dateFormats)
          }else{
            for elems $_, dateFormatLength {
              my $length = $_<type>;
              if my %a = resolve-alias $_ {
                #%m{calendar}{$calendar-type}{dateFormats}{$length} = Alias.new(calendars,%a<calendar-type> // $calendar-type,dateFormats, %a<dateFormatLength-type>)
                safe(%m, calendars,$calendar-type,dateFormats,$length) = Alias.new(calendars,%a<calendar-type> // $calendar-type,dateFormats, %a<dateFormatLength-type>)
              }else{
                with elem $_, dateFormat { # there should only be one, I think
                  for elems $_, pattern { # there is rarely more than 1
                    #%m{calendar}{$calendar-type}{dateFormats}{$length} = contents $_;
                    safe(%m, calendars,$calendar-type,dateFormats,$length, $_<alt> // 'standard') = contents $_;
                  }
                }
              }
            }
          }
        }

        with elem $_, timeFormats {
          if my %a = resolve-alias $_ {
            #%m{calendars}{$calendar-type}{timeFormats} = Alias.new(calendars,%a<calendar-type>)
            safe(%m, calendars,$calendar-type,timeFormats) = Alias.new(calendars,%a<calendar-type>,timeFormats)
          }else{
            for elems $_, timeFormatLength {
              my $length = $_<type>;
              if my %a = resolve-alias $_ {
                #%m{calendar}{$calendar-type}{timeFormats}{$length} = Alias.new(calendars,%a<calendar-type> // $calendar-type,timeFormats, %a<timeFormatLength-type>)
                safe(%m, calendars,$calendar-type,timeFormats,$length) = Alias.new(calendars,%a<calendar-type> // $calendar-type,timeFormats, %a<timeFormatLength-type>)
              }else{
                with elem $_, timeFormat { # there should only be one, I think
                  for elems $_, pattern { # there should only be one here as well
                  #%m{calendar}{$calendar-type}{timeFormats}{$length} = contents $_;
                  safe(%m, calendars,$calendar-type,timeFormats,$length,$_<alt> // 'standard') = contents $_;
                  }
                }
              }
            }
          }
        }

        with elem $_, dateTimeFormats {
          if my %a = resolve-alias $_ {
            safe(%m, calendars,$calendar-type,dateTimeFormats) = Alias.new(calendars,%a<calendar-type>,dateTimeFormats)
          }else{
            for elems $_, dateTimeFormatLength {
              my $length = $_<type>;
              if my %a = resolve-alias $_ {
                safe(%m, calendars,$calendar-type,dateTimeFormats,$length) = Alias.new(calendars,%a<calendar-type> // $calendar-type,dateTimeFormats, %a<dateTimeFormatLength-type>)
              }else{
                with elem $_, dateTimeFormat { # there should only be one, I think
                  with elem $_, pattern { # there should only be one here as well
                    safe(%m, calendars,$calendar-type,dateTimeFormats,$length) = contents $_;
                  }
                }
              }
            }
            # These are, in CLDR, hierarchically under DateTimeFormats, but it makes more sense IMO
            # for them be in their own sub unit under Calendar.  See the CLDR::Classes::Calendar
            # file and it should be clear.
            with elem $_, availableFormats {
              if my %a = resolve-alias $_ {
                #%m{calendars}{$calendar-type}{dateTimeFormats}{availableFormats} = Alias.new(calendars,%a<calendar-type> // $calendar-type,dateTimeFormats, availableFormats)
                safe(%m, calendars,$calendar-type,availableFormats) = Alias.new(calendars,%a<calendar-type> // $calendar-type, availableFormats)
              }else{
                for elems $_, dateFormatItem {
                  #%m{calendars}{$calendar-type}{dateTimeFormats}{availableFormats}{$_<id>} = contents $_;
                  safe(%m, calendars,$calendar-type,availableFormats,$_<id>) = contents $_;
                }
              }
            }
            # These are, in CLDR, hierarchically under DateTimeFormats, but it makes more sense IMO
            # for them be in their own sub unit under Calendar.  See the CLDR::Classes::Calendar
            # file and it should be clear.
            with elem $_, appendItems {
              if my %a = resolve-alias $_ {
                safe(%m, calendars,$calendar-type,appendItems) = Alias.new(calendars,%a<calendar-type> // $calendar-type, appendItems)
              }else{
                for elems $_, appendItem {
                  safe(%m, calendars,$calendar-type,appendItems,$_<request>) = contents $_;
                }
              }
            }
            # These are, in CLDR, hierarchically under DateTimeFormats, but it makes more sense IMO
            # for them be in their own sub unit under Calendar.  See the CLDR::Classes::Calendar
            # file and it should be clear.
            with elem $_, intervalFormats {
              if my %a = resolve-alias $_ {
                safe(%m, calendars,$calendar-type,intervalFormats) = Alias.new(calendars,%a<calendar-type> // $calendar-type, intervalFormats)
              }else{
                with elem $_, intervalFormatFallback {
                  # written as two 'standard', to match the structure of other interval formats.
                  safe(%m, calendars,$calendar-type,intervalFormats, 'standard', 'standard' ) = contents $_;
                }
                for elems $_, intervalFormatItem {
                  if my %a = resolve-alias $_ { alias-die $_, %a };
                  my $item-id = $_<id>;
                  for elems $_, greatestDifference {
                    safe(%m, calendars,$calendar-type,intervalFormats,$item-id,$_<id>) = contents $_;
                  }
                }
              }
            }
          }
        }
      }
    }
  }


  with elem $file, units {
    for elems $_, unitLength {
      my $length = $_<type>;
      if my %a = resolve-alias $_ {
        #%m{units}{$length} = Alias.new(units,%a<unitLength-type>);
        safe(%m, units, $length) = Alias.new(units,%a<unitLength-type>);
      }else{
        with elem $_, compoundUnit {
          my $type = $_<type>;
          if my %a = resolve-alias $_ { alias-die $_, %a };
          #%m{units}{$length}{compoundUnit}{$type}{pattern} = contents (elem $_, compoundUnitPattern);
          safe(%m, units,$length,compoundUnit,$type,pattern) = contents (elem $_, compoundUnitPattern);
        }
        for elems $_, Tags::unit {
          my $type = $_<type>;
          if my %a = resolve-alias $_ {
            #%m{units}{$length}{Tags::unit}{$type} = Alias.new(units,$length,%a<unit-type>)
            safe(%m, units,$length,Tags::unit,$type) = Alias.new(units,$length,Tags::unit,%a<unit-type>)
          }else{
            with elem $_, displayName {
              #%m{units}{$length}{Tags::unit}{$type}{displayName} = contents $_;
              safe(%m, units,$length,Tags::unit,$type,displayName) = contents $_;
            }

            for elems $_, unitPattern {
              my $count = $_<count>;
              #%m{units}{$length}{Tags::unit}{$type}{pattern}{$count} = contents $_;
              safe(%m, units,$length,Tags::unit,$type,pattern,$count) = contents $_;
            }

            with elem $_, perUnitPattern {
              #%m{units}{$length}{Tags::unit}{$type}{perUnitPattern} = contents $_;
              safe(%m, units,$length,Tags::unit,$type,perUnitPattern) = contents $_;
            }
          }
        }
        with elem $_, coordinateUnit {
          with elem $_, displayName {
            #%m{units}{$length}{coordinateUnit}{displayName} = contents $_;
            safe(%m, units,$length,coordinateUnit,displayName) = contents $_;
          }
          for elems $_, coordinateUnitPattern {
            my $type = $_<type>;
            #%m{units}{$length}{coordinateUnit}{$type} = contents $_;
            safe(%m, units,$length,coordinateUnit,$type) = contents $_;
          }
        }
      }
    } ### DURATION UNITS TODO
  }











  with elem $file, numbers {
    for elems $_, defaultNumberingSystem {
      #%m{numbers}{defaultNumberingSystem} = contents $_;
      safe(%m, numbers,defaultNumberingSystem,$<alt> // 'standard') = contents $_;
    }
    with elem $_, otherNumberingSystems {
      for .elements {
        #%m{numbers}{otherNumberingSystems}{$_.name} = contents $_;
        safe(%m, numbers,otherNumberingSystems,$_.name) = contents $_;
      }
    }
    with elem $_, minimumGroupingDigits {
      #%m{numbers}{minimumGroupingDigits} = contents $_;
      safe(%m, numbers,minimumGroupingDigits) = contents $_;
    }

    for elems $_, symbols {
      my $number-system = $_<numberSystem> // 'standard';
      if my %a = resolve-alias $_ {
        #%m{numbers}{symbols}{$number-system} = Alias.new(numbers, symbols, %a<symbols-numberSystem>);
        safe(%m, numbers,symbols,$number-system) = Alias.new(numbers, symbols, %a<symbols-numberSystem>);
      }else{
        for $_.elements {
          #%m{numbers}{symbols}{$number-system}{$_.name} = contents $_;
          safe(%m, numbers,symbols,$number-system,$_.name) = contents $_;
        }
      }
    }

    # There are several defined formats, loop through each
    with elems $_, decimalFormats { for @_ {
      my $number-system = $_<numberSystem> // 'standard';
      if my %a = resolve-alias $_ {
        #%m{numbers}{decimalFormats}{$number-system} = Alias.new(numbers, decimalFormats, %a<decimalFormats-numberSystem>);
        safe(%m, numbers,decimalFormats,$number-system) = Alias.new(numbers, decimalFormats, %a<decimalFormats-numberSystem>);
      }
      with elems $_, decimalFormatLength { for @_ {
        my $length = $_<type> // 'standard';
        if my %a = resolve-alias $_ {
          #%m{numbers}{decimalFormats}{$number-system}{$length} = Alias.new(numbers, decimalFormats, $number-system, %a<decimalFormatLength-type>);
          safe(%m, numbers,decimalFormats,$number-system,$length) = Alias.new(numbers, decimalFormats, $number-system, %a<decimalFormatLength-type>);
        }
        with elems $_, decimalFormat { for @_ { # there should only be element here
          with elems $_, pattern { for @_ {
            my $type = $_<type> // 'standard';
            if my %a = resolve-alias $_ {
              die "There shouldn't be aliases on individual pattern elements.  \n  Element: {$_.Str}\n  Alias Table: {%a.Str}";
            } else {
              #%m{numbers}{decimalFormats}{$number-system}{$length}{$type} = contents $_;
              safe(%m, numbers,decimalFormats,$number-system,$length,$type) = contents $_;
            }
          }}
        }}
      }}
    }}


    with elems $_, scientificFormats { for @_ {
      my $number-system = $_<numberSystem> // 'standard';
      if my %a = resolve-alias $_ {
        #%m{numbers}{scientificFormats}{$number-system} = Alias.new(numbers, scientificFormats, %a<scientificFormats-numberSystem>);
        safe(%m, numbers,scientificFormats,$number-system) = Alias.new(numbers, scientificFormats, %a<scientificFormats-numberSystem>);
      }
      with elems $_, scientificFormatLength { for @_ {
        my $length = $_<type> // 'standard';
        if my %a = resolve-alias $_ {
          #%m{numbers}{scientificFormats}{$number-system}{$length} = Alias.new(numbers, scientificFormats, $number-system, %a<scientificFormatLength-type>);
          safe(%m, numbers,scientificFormats,$number-system,$length) = Alias.new(numbers, scientificFormats, $number-system, %a<scientificFormatLength-type>);
        }
        with elems $_, scientificFormat { for @_ { # there should only be element here
          with elems $_, pattern { for @_ {
            my $type = $_<type> // 'standard';
            if my %a = resolve-alias $_ {
              die "There shouldn't be aliases on individual pattern elements.  \n  Element: {$_.Str}\n  Alias Table: {%a.Str}";
            } else {
              #%m{numbers}{scientificFormats}{$number-system}{$length}{$type} = contents $_;
              safe(%m, numbers,scientificFormats,$number-system,$length,$type) = contents $_;
            }
          }}
        }}
      }}
    }}

    for elems $_, percentFormats {
      my $number-system = $_<numberSystem> // 'standard';
      if my %a = resolve-alias $_ {
        safe(%m, numbers, percentFormats,$number-system) = Alias.new(numbers, percentFormats, %a<percentFormats-numberSystem>);
      }
      for elems $_, percentFormatLength {
        my $length = $_<type> // 'standard';
        if my %a = resolve-alias $_ {
          safe(%m, numbers, percentFormats,$number-system,$length) = Alias.new(numbers, percentFormats, $number-system, %a<percentFormatLength-type>);
        }
        for elems $_, percentFormat { # there should only be element here
          for elems $_, pattern {
            my $type = $_<type> // 'standard';
            if my %a = resolve-alias $_ {
              die "There shouldn't be aliases on individual pattern elements.  \n  Element: {$_.Str}\n  Alias Table: {%a.Str}";
            } else {
              safe(%m, numbers, percentFormats,$number-system,$length,$type) = contents $_;
            }
          }
        }
      }
    }

    # There is additional currency information that needs to be captured
    for elems $_, currencyFormats {
      my $number-system = $_<numberSystem> // 'standard';
      if my %a = resolve-alias $_ {
        #%m{numbers}{currencyFormats}{$number-system} = Alias.new(numbers, currencyFormats, %a<currencyFormats-numberSystem>);
        safe(%m, numbers,currencyFormats,$number-system) = Alias.new(numbers, currencyFormats, %a<currencyFormats-numberSystem>);
      }
      for elems $_, currencyFormatLength {
        my $length = $_<type> // 'standard';
        if my %a = resolve-alias $_ {
          #%m{numbers}{currencyFormats}{$number-system}{$length} = Alias.new(numbers, currencyFormats, $number-system, %a<currencyFormatLength-type>);
          safe(%m, numbers,currencyFormats,$number-system,$length) = Alias.new(numbers, currencyFormats, $number-system, %a<currencyFormatLength-type>);
        }
        for elems $_, currencyFormat { # there should only be element here
          for elems $_, pattern {
            my $type = $_<type> // 'standard';
            if my %a = resolve-alias $_ {
              alias-die($_,%a)
            } else {
              #%m{numbers}{currencyFormats}{$number-system}{$length}{$type} = contents $_;
              safe(%m, numbers,currencyFormats,$number-system,$length,$type) = contents $_;
            }
          }
        }
      }
    }

    for elems $_, miscPatterns {
      my $number-system = $_<numberSystem> // 'standard';
      if my %a = resolve-alias $_ {
        #%m{numbers}{miscPatterns}{$number-system} = Alias.new(numbers, miscPatterns, %a<miscPatterns-numberSystem>);
        safe(%m, numbers,miscPatterns,$number-system) = Alias.new(numbers, miscPatterns, %a<miscPatterns-numberSystem>);
      }
      for elems $_, pattern {
        #%m{numbers}{miscPatterns}{$number-system}{$_<type>} = contents $_;
        safe(%m, numbers,miscPatterns,$number-system,$_<type>) = contents $_;
      }
    }

    with elem $_, currencies {
      for elems $_, currency {
        my $type = $_<type>;
        for elems $_, symbol {
          my $alt = $_<alt> // 'standard';
          #%m{numbers}{currencies}{$type}{$alt} = contents $_;
          safe(%m, numbers,currencies,$type,$alt) = contents $_;
        }
      }
    }

  }

  with elem $file, listPatterns {
    for elems $_, listPattern {
      my $type = $_<type> // 'standard';
      if my %a = resolve-alias $_ {
        #%m{listPatterns}{$type} = Alias.new(listPatterns, %a<listPattern-type> // 'standard')
        safe(%m, listPatterns,$type) = Alias.new(listPatterns, %a<listPattern-type> // 'standard')
      }else{
        for elems $_, listPatternPart {
          #%m{listPatterns}{$type}{$_<type>} = contents $_;
          safe(%m, listPatterns,$type,$_<type>) = contents $_;
        }
      }
    }
  }

  with elem $file, posix {
    with elem $_, messages {
      with elem $_, yesstr {
        %m{posix}{messages}{yesstr} = contents $_
      }
      with elem $_, nostr {
        %m{posix}{messages}{nostr} = contents $_
      }
    }
  }

  with elem $file, characterLabels {
    for elems $_, characterLabelPattern {
      %m{characterLabels}{patterns}{$_<type>} = contents $_;
    }
    for elems $_, characterLabel {
      %m{characterLabels}{'labels'}{$_<type>} = contents $_;
    }
  }

  with elem $file, typographicNames {
    for elems $_, axisName {
      %m{typographicNames}{axisName}{$_<type>} = contents $_;
    }
    for elems $_, styleName {
      %m{typographicNames}{styleName}{$_<type>}{$_<subtype>}{$_<alt> // 'standard'} = contents $_;
    }
    for elems $_, featureName {
      %m{typographicNames}{featureName}{$_<type>} = contents $_;
    }
  }
  print "\e[1FProcessing language $lang ($current-count of $total-count):\n  [√] XML opened   [√] XML processed\r";

  ##########################
  # Here we should pre-process aliasing that may be needed on the fly.
  # The fall back order here may not be perfect (my CPP is *very* bad) so if fall backs don't seem
  # to work as planned, adjustment may need to be made here.
  ##########################
  # We begin with calendar data.  First we begin with aliasing the month/day/etc context/lengths
  # if the sections actually exist
  for <gregorian buddhist chinese coptic dangi ethiopic ethiopic-amete-alem generic gregorian hebrew
       indian islamic islamic-civil islamic-rgsa islamic-tbla islamic-umalqura japanese persian roc>
  -> $calendar {
    # Aliasing the months
    with %m{calendars} {
      with %m{calendars}{$calendar} {
        # If the calendar exists, not all elements will be defined.  Some default to the gregorian (names)
        # and others default to generic (patterns).
        # In either case, if the element DOES exist, then we define the fallbacks now.
        with %m{calendars}{$calendar}{days} { unless .isa(Alias) {
          .<format><short>            //= Alias.new(calendars, $calendar, days, 'format', 'abbreviated');
          .<stand-alone><wide>        //= Alias.new(calendars, $calendar, days, 'format', 'wide');
          .<stand-alone><abbreviated> //= Alias.new(calendars, $calendar, days, 'format', 'abbreviated');
          .<stand-alone><short>       //= Alias.new(calendars, $calendar, days, 'format', 'short');

          unless .<stand-alone><narrow> ||  .<format><narrow> {
            .<stand-alone><narrow>       =  Alias.new(calendars, $calendar, days, 'format', 'abbreviated');
            .<format><narrow>            =  Alias.new(calendars, $calendar, days, 'format', 'abbreviated');
          }
          .<stand-alone><narrow>        //=  Alias.new(calendars, $calendar, days, 'format',      'narrow');
          .<format><narrow>             //=  Alias.new(calendars, $calendar, days, 'stand-alone', 'narrow');
        }} else {
          %m{calendars}{$calendar}{days} = Alias.new(calendars, 'gregorian', days)
        }

        with %m{calendars}{$calendar}{months} { unless .isa(Alias) {
          .<stand-alone><wide>          //= Alias.new(calendars, $calendar, months, 'format', 'wide');
          .<stand-alone><abbreviated>   //= Alias.new(calendars, $calendar, months, 'format', 'abbreviated');
          unless .<stand-alone><narrow> ||  .<format><narrow> {
            .<stand-alone><narrow>       =  Alias.new(calendars, $calendar, months, 'format', 'abbreviated');
            .<format><narrow>            =  Alias.new(calendars, $calendar, months, 'format', 'abbreviated');
          }
          .<stand-alone><narrow>        //=  Alias.new(calendars, $calendar, months, 'format',      'narrow');
          .<format><narrow>             //=  Alias.new(calendars, $calendar, months, 'stand-alone', 'narrow');
        }} else {
          %m{calendars}{$calendar}{months} = Alias.new(calendars, 'gregorian', months)
        }

        with %m{calendars}{$calendar}{quarters} { unless .isa(Alias) {
          .<stand-alone>  //= Alias.new(calendars, $calendar, quarters, 'format');
        }} else {
          %m{calendars}{$calendar}{quarters} = Alias.new(calendars, 'gregorian', quarters)
        }

        with %m{calendars}{$calendar}{eras} { unless .isa(Alias) {
          .<eraNames>  //= Alias.new(calendars, $calendar, eras, eraAbbr);
          .<eraNarrow> //= Alias.new(calendars, $calendar, eras, eraAbbr);
        }} else {
          %m{calendars}{$calendar}{eras} = Alias.new(calendars, 'gregorian', eras)
        }

      } else {
        # Many languages won't specify an entire calendar, inherited calendars alias to their base
        # And otherwise to gregorian
        given $calendar {
          when <islamic-umalqura islamic-tbla islamic-rsga islamic-civil>.any { 
            %m{calendars}{$calendar} = Alias.new(calendars, 'islamic')
          }
          when <dangi roc> {
            %m{calendars}{'dangi'} = Alias.new(calendars, 'chinese')
          }
          when <ethiopic-amete-alem> {
            %m{calendars}{'ethiopic-amete-alem'} = Alias.new(calendars, 'ethiopic')
          }
          default {
            %m{calendars}{$calendar} = Alias.new(calendars, 'gregorian')
          }
        }
      }
    } else {
      # Should be rare, but for newer languages without full coverage, there may be no calendar element
      # These should be linked to root.  Currently, root aliased aren't handled here and are calculated
      # on a run-time look-up failure.
    }
  }







  my $out = open "languages/$lang.data", :w;
  print-hash-main $out, %m;
  $out.close;
  if my $alias-file-content = hash-alias-text(%m) {
    $out = open "languages/aliases/$lang.data", :w;
    $out.say: $alias-file-content.trim-trailing;
  }

  #print-hash-alias $out, %m;

  $out.close;
  print "\e[1FProcessing language $lang ($current-count of $total-count):\n  [√] XML opened   [√] XML processed\r";
  $current-count++;
}

say "\e[1FProcess complete.                                           \n  (Completed in {(now - BEGIN {now}).floor}s)                 ";









# utility functions
proto sub elems (|c ){*}
multi sub elems ($xml            ) { my @a = $xml.elements;             @a == 0 ?? Empty !! @a }
multi sub elems ($xml, Str() $tag) { my @a = $xml.elements(:TAG($tag)); @a == 0 ?? Empty !! @a }
sub elem    ($xml, Str() $tag) {
  my $line = Backtrace.new[3].line;
  my @a = $xml.elements(:TAG($tag));
  die "Fix elem for tag $tag, expected only one, came from line $line" if @a > 1;
  @a.head  // Nil
}
sub contents($xml            ) { with $xml.contents { return .join } else { return ''} }
sub resolve-alias ($xml            ) {
  with elem $xml, alias {
    # There is an alias
    if $_<source> eq 'locale' {
      my @alias-path      = $_<path>.split('/');
      my $parent-count = @alias-path.grep(* eq '..').elems;
      # Return the tag if it's a tag, otherwise just the string.
      my %selectors;
      for @alias-path[$parent-count..*] {
        if $_ ~~ /^(.+) '[@' (.+) "='" (.+) "']"$/ {
          %selectors{[~] $0, '-', $1} = $2.Str; # combining with the tag name isn't pretty, but if two
                                                # attributes are the same on different tags, they
                                                # can't be distinguished
        }else{
          %selectors{$_} = True;
        }
      }
      return %selectors;
    }else{
      die "Found a source that wasn't locale.  Figure out how to deal with it";
    }
  }
}
sub alias-die($xml, %a) {
  my $line = Backtrace.new[3].line;
  die "There shouldn't be aliases for this element (line $line).  \n  Element: {$_.Str}\n  Alias Table: {%a.Str}";
}

sub tag-contents($parent, $name) {
  if my $children = $parent.getElementsByTagName($name) {
    return $children.first.contents.join;
  } else {
    #say "Could not find $name";
    return Nil;
  }
}

sub pp-hash(%h, $level = 0) {
	for %h.kv -> $key, $value {
		if $value ~~ Hash {
			say ( ' ' x ($level*4)), $key, " => ";
			samewith $value, $level + 1;
		}else{
			say ( ' ' x ($level*4)), $key, " => ", $value;
		}
	}
}

sub array-clone (@array) {
  my @result = ();
  for @array {
    @result.push: $_.clone
  }
}
sub hash-clone (%hash) {
  my %result = ();
  for %hash.kv -> $key, $value {
    if $value ~~ Positional {
      %result{$key} = array-clone($value);
    }elsif $value ~~ Associative {
      %result{$key} = hash-clone($value);
    }else {
      %result{$key} = $value.clone;
    }
  }
  %result;
}

# This safe method allows us to override the aliases
sub safe(%hash, *@keys) {
	my %h := %hash;
	while @keys > 1 {
		unless %h{@keys.head} ~~ Associative {
			%h{@keys.head} := Hash.new;
		}
		%h := %h{@keys.shift}
	}
	return-rw %h{@keys.head};
}

sub print-hash-main($file, %h, *@keys) {
  for %h.kv -> $key, $value {
    if $value ~~ Associative {
      samewith $file, $value, |@keys, $key;
    }else{
      if $value !~~ Alias {
        #$file.say: @keys.map({ Tags::{$_} ?? Tags::{$_}.value !! $_ }).join($sep) ~ $sep ~ $value;
        $file.say: @keys.join($sep) ~ $sep ~ $key ~ $sep ~ $value;
      }
    }
  }
}

sub print-hash-alias($file, %h, *@keys) {
  for %h.kv -> $key, $value {
    if $value ~~ Associative {
      samewith $file, $value, |@keys, $key;
    }else{
      if $value ~~ Alias {
        #$file.say: @keys.map({ Tags::{$_} ?? Tags::{$_}.value !! $_ }).join($sep) ~ $sep ~ $value;
        $file.say: @keys.join($sep) ~ $sep ~ $key ~ $sep2 ~ $value.components.map(*.Str).join($sep);
      }
    }
  }
}

sub hash-alias-text(%h, *@keys) {
  my $result = '';
  my $text = '';
  for %h.kv -> $key, $value {
    if $value ~~ Associative {
      $text ~= samewith $value, |@keys, $key;
    }else{
      if $value ~~ Alias {
        #$file.say: @keys.map({ Tags::{$_} ?? Tags::{$_}.value !! $_ }).join($sep) ~ $sep ~ $value;
        $text ~= @keys.join($sep) ~ $sep ~ $key ~ $sep2 ~ $value.components.map(*.Str).join($sep) ~ "\n";
      }
    }
  }
  return $text;
}
