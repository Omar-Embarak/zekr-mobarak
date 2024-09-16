import 'package:azkar_app/model/quran_models/reciters_model.dart';
import 'package:flutter/material.dart';
import 'package:azkar_app/constants/colors.dart';
import 'package:azkar_app/utils/app_style.dart';
import '../../../widgets/reciturs_item.dart';
import 'list_surahs_listening_page.dart';

class MurattalPage extends StatelessWidget {
  MurattalPage({super.key});
  final List<RecitersModel> reciters = <RecitersModel>[
    RecitersModel(
      url: 'https://download.quranicaudio.com/qdc/abdul_baset/murattal/',
      name: 'عبد الباسط عبد الصمد',
      zeroPaddingSurahNumber: false,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/abdulbaset_warsh//',
      name: 'عبد الباسط عبد الصمد برواية ورش ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url:
          'https://download.quranicaudio.com/qdc/abdurrahmaan_as_sudais/murattal/',
      name: 'عبدالرحمن السديس',
      zeroPaddingSurahNumber: false,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/qdc/abu_bakr_shatri/murattal/',
      name: 'ابو بكر الشاطري',
      zeroPaddingSurahNumber: false,
    ),
    RecitersModel(
      url:
          'https://download.quranicaudio.com/quran/abu_bakr_ash-shatri_tarawee7//',
      name: 'أبو بكر الشاطري - تراويح  ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/qdc/hani_ar_rifai/murattal/',
      name: 'هاني الرفاعي',
      zeroPaddingSurahNumber: false,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/qdc/khalil_al_husary/murattal/',
      name: 'خليل الحصري',
      zeroPaddingSurahNumber: false,
    ),
    RecitersModel(
      url:
          'https://download.quranicaudio.com/quran/mahmood_khaleel_al-husaree_iza3a//',
      name: 'محمود خليل الحصري - إذاعة  ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/qdc/khalil_al_husary/muallim/',
      name: 'خليل الحصري - المعلم',
      zeroPaddingSurahNumber: false,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/husary_muallim//',
      name: 'خليل الحصري - المعلم  ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url:
          'https://download.quranicaudio.com/quran/husary_muallim_kids_repeat//',
      name: 'خليل الحصري - المعلم مع الاطفال  ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url:
          'https://download.quranicaudio.com/quran/mahmood_khaleel_al-husaree_doori//',
      name: 'محمود خليل الحصري برواية دوري ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/qdc/mishari_al_afasy/murattal/',
      name: 'مشاري العفاسي',
      zeroPaddingSurahNumber: false,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/mishaari_california//',
      name: 'العفاسي - ختمة كاليفورنيا  ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url:
          'https://download.quranicaudio.com/qdc/mishari_al_afasy/streaming/mp3/',
      name: 'مشاري العفاسي - ستريم  ',
      zeroPaddingSurahNumber: false,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/qdc/siddiq_minshawi/murattal/',
      name: 'صديق المنشاوي',
      zeroPaddingSurahNumber: false,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/qdc/siddiq_minshawi/kids_repeat/',
      name: 'صديق المنشاوي - المعلم مع الاطفال  ',
      zeroPaddingSurahNumber: false,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/qdc/saud_ash-shuraym/murattal/',
      name: 'سعود الشريم',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/sa3ood_al-shuraym/older//',
      name: 'سعود الشريم - قديم  ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/abdul_muhsin_alqasim/',
      name: 'عبدالمحسن القاسم',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url:
          'https://download.quranicaudio.com/quran/sa3d_al-ghaamidi/complete//',
      name: 'سعد الغامدي',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url:
          'https://download.quranicaudio.com/quran/tawfeeq_bin_saeed-as-sawaaigh//',
      name: 'توفيق الصائغ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/mahmood_ali_albana//',
      name: 'محمود علي البنا  ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/thubaity//',
      name: 'عبدالباري بن عواض الثبيتي',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/sahl_yaaseen/',
      name: 'سهل ياسين',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/salaah_bukhaatir//',
      name: 'صلاح بوخاطر',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/ahmed_ibn_3ali_al-3ajamy//',
      name: 'أحمد بن علي العجمي',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/sodais_and_shuraim//',
      name: 'السديس والشريم',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/sodais_and_shuraim/older//',
      name: 'السديس والشريم - قديم  ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/abdulazeez_al-ahmad//',
      name: 'عبدالعزيز الاحمد',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/muhammad_ayyoob//',
      name: 'محمد أيوب',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/muhammad_ayyoob_hq//',
      name: 'محمد أيوب  ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/abdullaah_alee_jaabir//',
      name: 'عبدالله علي جابر',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/ali_jaber//',
      name: 'علي جابر  ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url:
          'https://download.quranicaudio.com/quran/abdullaah_alee_jaabir_studio//',
      name: 'عبدالله علي جابر ..استوديو ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/fatih_seferagic//',
      name: 'فاتح سفرجيك  ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/yasser_ad-dussary//',
      name: 'ياسر الدوسري  ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/qdc/yasser_ad-dussary/mp3/',
      name: 'ياسر الدوسري  ',
      zeroPaddingSurahNumber: false,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/nasser_bin_ali_alqatami//',
      name: 'ناصر القطامي  ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/madinah_1419//',
      name: 'قران المدينة 1419',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/madinah_1423//',
      name: 'قران المدينة 1423 ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/madinah_1426//',
      name: 'قران المدينة 1426',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/madinah_1427//',
      name: 'قران المدينة 1427',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/madinah_1428//',
      name: 'قران المدينة 1428',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/madinah_1429//',
      name: 'قران المدينة 1429  ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/madinah_1430//',
      name: 'قران المدينة 1430  ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/madinah_1431//',
      name: 'قران المدينة 1431 ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/madinah_1432//',
      name: 'قران المدينة 1432  ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/madinah_1433//',
      name: 'قران المدينة 1433  ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/madinah_1434//',
      name: 'قران المدينة 1434  ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/madinah_1435//',
      name: 'قران المدينة 1435  ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/madinah_1436//',
      name: 'قران المدينة 1436  ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/madinah_1437//',
      name: 'قران المدينة 1437  ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/madinah_1439//',
      name: 'قران المدينة 1439  ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/madinah_1440//',
      name: 'قران المدينة 1440  ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/madinah_1441//',
      name: 'قران المدينة 1441  ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/madinah_1442//',
      name: 'قران المدينة 1442  ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/mehysni//',
      name: 'محمد المحيسني',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/muhaisny_1435//',
      name: '1435 محمد المحيسني  ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/jibreen//',
      name: 'عبدالله جبرين',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/makkah_1424//',
      name: 'قران مكة 1424 ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/makkah_1425//',
      name: 'قران مكة 1425 ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/makkah_1426//',
      name: 'قران مكة 1426',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/makkah_1427//',
      name: 'قران مكة 1427',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/makkah_1428//',
      name: 'قران مكة 1428 ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/makkah_1429//',
      name: 'قران مكة 1429 ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/makkah_1430//',
      name: 'قران مكة 1430 ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/makkah_1431//',
      name: 'قران مكة 1431 ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/makkah_1432//',
      name: 'قران مكة 1432  ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/makkah_1433//',
      name: 'قران مكة 1433  ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/makkah_1434//',
      name: 'قران مكة 1434  ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/makkah_1435//',
      name: 'قران مكة 1435  ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/makkah_1436//',
      name: 'قران مكة 1436  ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/makkah_1437//',
      name: 'قران مكة 1437  ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/makkah_1438//',
      name: 'قران مكة 1438  ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/makkah_1439//',
      name: 'قران مكة 1439  ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/makkah_1440//',
      name: 'قران مكة 1440  ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/makkah_1441//',
      name: 'قران مكة 1441  ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/makkah_1442//',
      name: 'قران مكة 1442  ',
      zeroPaddingSurahNumber: true,
    ),
      RecitersModel(
      url: 'https://download.quranicaudio.com/quran/masjid_quba_1434//',
      name: 'قران مسجد القبة 1434  ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/muhammad_jibreel/hidayah//',
      name: 'محمد جبريل',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url:
          'https://download.quranicaudio.com/quran/muhammad_jibreel/complete//',
      name: 'محمد جبريل - كامل  ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/saleh_al_taleb//',
      name: 'صالح الطالب',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url:
          'https://download.quranicaudio.com/quran/sudais_shuraim_and_english//',
      name: 'السديس والشريم and English',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url:
          'https://download.quranicaudio.com/quran/shakir_qasami_with_english/',
      name: 'شاكر قاسمي and English ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/salahbudair//',
      name: 'صلاح البدير ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url:
          'https://download.quranicaudio.com/quran/abdulbaset_with_naeem_sultan_pickthall//',
      name: 'عبدالباسط عبدالصمد ونعيم سلطان ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url:
          'https://download.quranicaudio.com/quran/sudais_shuraim_with_naeem_sultan_pickthall//',
      name: 'السديس والشريم مع نعيم سلطان ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url:
          'https://download.quranicaudio.com/quran/mishaari_with_saabir_mkhan//',
      name: 'العفاسي and Saabir Mkhan ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/maher_256//',
      name: 'ماهر المعيقلي ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url:
          'https://download.quranicaudio.com/quran/maher_almu3aiqly/year1440//',
      name: 'ماهر المعيقلي 1440  ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/muhammad_alhaidan//',
      name: 'محمد الليحدان ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/mohammad_altablawi//',
      name: 'محمد الطبلاوي ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url:
          'https://download.quranicaudio.com/quran/alhusaynee_al3azazee_with_children//',
      name: 'الحسيني العزيزي -المعلم مع الاطفال ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url:
          'https://download.quranicaudio.com/quran/abdulbasit_w_ibrahim_walk_si//',
      name: 'عبدالباسط and Ibrahim Walksi ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url:
          'https://download.quranicaudio.com/quran/mishaari_w_ibrahim_walk_si//',
      name: 'العفاسي and Ibrahim Walksi ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url:
          'https://download.quranicaudio.com/quran/abdurrashid_sufi_soosi_rec//',
      name: 'عبدالرشيد صوفي ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/abdurrashid_sufi//',
      name: 'عبدالرشيد صوفي  ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url:
          'https://download.quranicaudio.com/quran/abdurrashid_sufi_-_khalaf_3an_7amza_recitation//',
      name: 'عبد الرشيد صوفي برواية خلف عن حمزة ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url:
          'https://download.quranicaudio.com/quran/abdurrashid_sufi_abi_al7arith//',
      name: 'عبدالرشيد صوفي برواية ابي الحارث  ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/abdurrashid_sufi_shu3ba//',
      name: 'عبدالرشيد صوفي برواية شعبة   ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/abdurrashid_sufi_doori//',
      name: 'عبدالرشيد صوفي برواية الدوري  ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url:
          'https://download.quranicaudio.com/quran/abdurrashid_sufi_soosi_2020//',
      name: 'عبدالرشيد صوفي 2020  ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/sadaqat_ali//',
      name: 'صداقت علي ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/hamad_sinan//',
      name: 'حمد سنان ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/abdullaah_basfar//',
      name: 'عبدالله بصفر  ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url:
          'https://download.quranicaudio.com/quran/abdullah_basfar_w_ibrahim_walk_si//',
      name: 'عبدالله بصفر and Ibrahim Walksi ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url:
          'https://download.quranicaudio.com/quran/sudais_and_shuraim_with_urdu//',
      name: 'السديس والشريم and urdu ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url:
          'https://download.quranicaudio.com/quran/abdulrazaq_bin_abtan_al_dulaimi//',
      name: 'عبدالرزاق بن عبطان الدليمي ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/muhammad_abdulkareem//',
      name: 'محمد عبدالكريم ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/mustafa_al3azzawi//',
      name: 'مصطفي العزاوي ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/khayat//',
      name: 'عبدالله خياط ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/mu7ammad_7assan//',
      name: 'محمد حسن ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/salah_alhashim//',
      name: 'صلاح الهاشم ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/adel_kalbani//',
      name: 'عادل الكلباني ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/adel_kalbani_1437//',
      name: 'عادل الكلباني 1437  ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/hatem_farid/collection//',
      name: 'حاتم فريد - تشكيلة',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/hatem_farid/taraweeh1430//',
      name: 'حاتم فريد - تراويح 1430  ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/hatem_farid/taraweeh1431//',
      name: 'حاتم فريد - تراويح 1431 ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/hatem_farid/taraweeh1432//',
      name: 'حاتم فريد - تراويح 1432 ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/hatem_farid/taraweeh1434//',
      name: 'حاتم فريد - تراويح 1434  ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/mostafa_ismaeel//',
      name: 'مصطفي اسماعيل ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/muhammad_patel//',
      name: 'محمد سليمان باتل ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url:
          'https://download.quranicaudio.com/quran/mohammad_ismaeel_almuqaddim//',
      name: 'محمد اسماعيل المقدم',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/imad_zuhair_hafez//',
      name: 'عماد زهير حافظ  ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/ibrahim_al_akhdar//',
      name: 'إبراهيم الأخضر  ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/abdulkareem_al_hazmi//',
      name: 'عبدالكريم الحازمي  ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/abdulmun3im_abdulmubdi2//',
      name: 'عبدالمنعم عبدالمبديء  ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/ahmad_alhuthayfi//',
      name: 'أحمد الحذيفي  ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/huthayfi//',
      name: 'علي بن عبدالرحمن الحذيفي  ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/huthayfi_qaloon//',
      name: 'الحذيفي برواية قالون  ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/idrees_akbar//',
      name: 'إدريس أبكر  ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/bandar_baleela//',
      name: 'بندر بليلة  ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/bandar_baleela/complete//',
      name: 'بندر بليلة - كامل  ',
      zeroPaddingSurahNumber: true,
    ),
  
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/muhammad_khaleel//',
      name: 'محمد خليل  ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/abdullah_matroud//',
      name: 'عبدالله مطرود  ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/abdul_wadood_haneef_rare//',
      name: 'عبدالودود حنيف نادر  ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/ahmad_nauina//',
      name: 'أحمد نعينع  ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/akram_al_alaqmi//',
      name: 'أكرم العلاقمي  ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/ali_hajjaj_alsouasi//',
      name: 'علي حجاج السويسي  ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/wadee_hammadi_al-yamani//',
      name: 'وديع حمادي اليمني  ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/asim_abdulaleem//',
      name: 'عاصم عبدالعليم  ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/abdallah_abdal//',
      name: 'عبدالله عبدل  ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/noreen_siddiq//',
      name: 'نورين محمد صديق  ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/bandar_baleela/complete//',
      name: 'بندر بليلة - كامل  ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/khalifah_taniji//',
      name: 'خليفة الطنيجي  ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url:
          'https://download.quranicaudio.com/quran/abdullaah_3awwaad_al-juhaynee//',
      name: 'عبدالله عواد الجهني  ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/nabil_rifa3i//',
      name: 'نبيل رفاعي  ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/khaalid_al-qahtaanee//',
      name: 'خالد القحطاني  ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/qdc/khalid_jalil/murattal/mp3/',
      name: 'خالد جليل  ',
      zeroPaddingSurahNumber: false,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/qdc/hadi_toure/mp3/',
      name: 'محمد الهادي توري  ',
      zeroPaddingSurahNumber: false,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/qdc/yasser_ad-dussary/mp3/',
      name: 'ياسر الدوسري  ',
      zeroPaddingSurahNumber: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kPrimaryColor,
      appBar: AppBar(
        backgroundColor: AppColors.kSecondaryColor,
        title: Text(
          'القران المرتل',
          style: AppStyles.styleCairoBold20(context),
        ),
      ),
      body: ListView.builder(
        itemCount: reciters.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ListSurahsListeningPage(
                    audioBaseUrl: reciters[index].url,
                    reciterName: reciters[index].name,
                    zeroPadding: reciters[index].zeroPaddingSurahNumber,
                  ),
                ),
              );
            },
            child: RecitursItem(
              reciter: reciters[index].name,
            ),
          );
        },
      ),
    );
  }
}
