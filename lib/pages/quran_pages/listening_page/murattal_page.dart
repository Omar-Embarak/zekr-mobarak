import 'package:azkar_app/model/quran_models/reciters_model.dart';
import 'package:flutter/material.dart';
import 'package:azkar_app/constants.dart';
import 'package:azkar_app/utils/app_style.dart';
import '../../../widgets/reciturs_item.dart';
import 'list_surahs_listening_page.dart';

class MurattalPage extends StatefulWidget {
  const MurattalPage({super.key});

  @override
  State<MurattalPage> createState() => _MurattalPageState();
}

class _MurattalPageState extends State<MurattalPage> {
  final List<RecitersModel> reciters = const [
    // 1. يبدأ برقم

    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/ibrahim_al_akhdar//',
      name: 'إبراهيم الأخضر',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/idrees_akbar//',
      name: 'إدريس أبكر',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/ahmed_ibn_3ali_al-3ajamy//',
      name: 'أحمد بن علي العجمي',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/ahmad_alhuthayfi//',
      name: 'أحمد الحذيفي',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/ahmad_nauina//',
      name: 'أحمد نعينع',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/akram_al_alaqmi//',
      name: 'أكرم العلاقمي',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/abu_bakr_shatri/murattal/',
      name: 'ابو بكر الشاطري',
      zeroPaddingSurahNumber: false,
    ),

    // المجموعة (ب)
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

    // المجموعة (ت)
    RecitersModel(
      url:
          'https://download.quranicaudio.com/quran/tawfeeq_bin_saeed-as-sawaaigh//',
      name: 'توفيق الصائغ',
      zeroPaddingSurahNumber: true,
    ),

    // المجموعة (ح)
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/hatem_farid/collection//',
      name: 'حاتم فريد ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/hamad_sinan//',
      name: 'حمد سنان ',
      zeroPaddingSurahNumber: true,
    ),

    // المجموعة (خ)
    RecitersModel(
      url: 'https://download/quranicaudio.com/quran/khaalid_al-qahtaanee//',
      name: 'خالد القحطاني  ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/qdc/khalid_jalil/murattal/mp3/',
      name: 'خالد جليل  ',
      zeroPaddingSurahNumber: false,
    ),
    RecitersModel(
      url: 'https://download/quranicaudio.com/quran/khalifah_taniji//',
      name: 'خليفة الطنيجي  ',
      zeroPaddingSurahNumber: true,
    ),

    // المجموعة (س)
    RecitersModel(
      url:
          'https://download.quranicaudio.com/quran/sa3d_al-ghaamidi/complete//',
      name: 'سعد الغامدي',
      zeroPaddingSurahNumber: true,
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
      url: 'https://download/quranicaudio.com/quran/sahl_yaaseen/',
      name: 'سهل ياسين',
      zeroPaddingSurahNumber: true,
    ),

    // المجموعة (ص)
    RecitersModel(
      url: 'https://download/quranicaudio.com/quran/saleh_al_taleb//',
      name: 'صالح الطالب',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download/quranicaudio.com/quran/sadaqat_ali//',
      name: 'صداقت علي ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download/quranicaudio.com/qdc/siddiq_minshawi/murattal/',
      name: 'صديق المنشاوي',
      zeroPaddingSurahNumber: false,
    ),
    RecitersModel(
      url: 'https://download/quranicaudio.com/quran/salahbudair//',
      name: 'صلاح البدير ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download/quranicaudio.com/quran/salaah_bukhaatir//',
      name: 'صلاح بوخاطر',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download/quranicaudio.com/quran/salah_alhashim//',
      name: 'صلاح الهاشم ',
      zeroPaddingSurahNumber: true,
    ),

    // المجموعة (ع) يتم ترتيبها بعدة فئات
    // أ) أولاً القارئ الذي يبدأ بـ"عاصم"
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/asim_abdulaleem//',
      name: 'عاصم عبدالعليم  ',
      zeroPaddingSurahNumber: true,
    ),
    // ب) بقية أسماء تبدأ بـ"عبد"
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/thubaity//',
      name: 'عبدالباري بن عواض الثبيتي',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url:
          'https://download.quranicaudio.com/qdc/abdurrahmaan_as_sudais/murattal/',
      name: 'عبدالرحمن السديس',
      zeroPaddingSurahNumber: false,
    ),
    RecitersModel(
      url:
          'https://download.quranicaudio.com/quran/abdulrazaq_bin_abtan_al_dulaimi//',
      name: 'عبدالرزاق بن عبطان الدليمي ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url:
          'https://download/quranicaudio.com/quran/abdurrashid_sufi_soosi_rec//',
      name: 'عبدالرشيد صوفي ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download/quranicaudio.com/quran/abdurrashid_sufi//',
      name: 'عبدالرشيد صوفي 2 ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url:
          'https://download/quranicaudio.com/quran/abdurrashid_sufi_soosi_2020//',
      name: 'عبدالرشيد صوفي 2020  ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download/quranicaudio.com/quran/abdulkareem_al_hazmi//',
      name: 'عبدالكريم الحازمي  ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download/quranicaudio.com/quran/jibreen//',
      name: 'عبدالله جبرين',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download/quranicaudio.com/quran/khayat//',
      name: 'عبدالله خياط ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download/quranicaudio.com/quran/abdulmun3im_abdulmubdi2//',
      name: 'عبدالمنعم عبدالمبديء  ',
      zeroPaddingSurahNumber: true,
    ),

    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/abdul_baset/murattal/',
      name: 'عبد الباسط عبد الصمد',
      zeroPaddingSurahNumber: false,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/abdul_muhsin_alqasim/',
      name: 'عبدالمحسن القاسم',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/abdul_wadood_haneef_rare//',
      name: 'عبدالودود حنيف نادر',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/abdulazeez_al-ahmad//',
      name: 'عبدالعزيز الاحمد',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/abdullah_abdal//',
      name: 'عبدالله عبدل',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/abdullah_matroud//',
      name: 'عبدالله مطرود',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/abdullaah_basfar//',
      name: 'عبدالله بصفر',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url:
          'https://download.quranicaudio.com/quran/abdullaah_3awwaad_al-juhaynee//',
      name: 'عبدالله عواد الجهني',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/abdullaah_alee_jaabir//',
      name: 'عبدالله علي جابر',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url:
          'https://download.quranicaudio.com/quran/abdullaah_alee_jaabir_studio//',
      name: 'عبدالله علي جابر ..استوديو',
      zeroPaddingSurahNumber: true,
    ),
    // ج) أسماء تبدأ بـ"علي" أو غيرها من (ع)
    RecitersModel(
      url: 'https://download/quranicaudio.com/quran/huthayfi//',
      name: 'علي بن عبدالرحمن الحذيفي  ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download/quranicaudio.com/quran/ali_jaber//',
      name: 'علي جابر  ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download/quranicaudio.com/quran/ali_hajjaj_alsouasi//',
      name: 'علي حجاج السويسي  ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download/quranicaudio.com/quran/imad_zuhair_hafez//',
      name: 'عماد زهير حافظ  ',
      zeroPaddingSurahNumber: true,
    ),

    // المجموعة (ف)
    RecitersModel(
      url: 'https://download/quranicaudio.com/quran/fatih_seferagic//',
      name: 'فاتح سفرجيك  ',
      zeroPaddingSurahNumber: true,
    ),

    // المجموعة (ق)
    RecitersModel(
      url: 'https://download/quranicaudio.com/quran/masjid_quba_1434//',
      name: 'قران مسجد القبة 1434  ',
      zeroPaddingSurahNumber: true,
    ),

    // المجموعة (م)؛ نقسمها حسب الكلمة الأولى (مثلاً: ماهر – محمد – محمود – مشاري – مصطفى)
    // أ) مجموعة "ماهر"
    RecitersModel(
      url: 'https://download/quranicaudio.com/quran/maher_256//',
      name: 'ماهر المعيقلي ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url:
          'https://download/quranicaudio.com/quran/maher_almu3aiqly/year1440//',
      name: 'ماهر المعيقلي 1440  ',
      zeroPaddingSurahNumber: true,
    ),

    // ب) مجموعة "محمد"
    RecitersModel(
      url:
          'https://download/quranicaudio.com/quran/mohammad_jibreel/complete//',
      name: 'محمد اسماعيل المقدم',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download/quranicaudio.com/quran/muhammad_ayyoob//',
      name: 'محمد أيوب',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download/quranicaudio.com/quran/muhammad_ayyoob_hq//',
      name: 'محمد أيوب  ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download/quranicaudio.com/quran/muhammad_jibreel/hidayah//',
      name: 'محمد جبريل',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url:
          'https://download/quranicaudio.com/quran/muhammad_jibreel/complete//',
      name: 'محمد جبريل - كامل  ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/mu7ammad_7assan//',
      name: 'محمد حسن ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download/quranicaudio.com/quran/muhammad_khaleel//',
      name: 'محمد خليل  ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download/quranicaudio.com/quran/muhammad_patel//',
      name: 'محمد سليمان باتل ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download/quranicaudio.com/quran/mohammad_altablawi//',
      name: 'محمد الطبلاوي ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download/quranicaudio.com/quran/muhammad_abdulkareem//',
      name: 'محمد عبدالكريم ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download/quranicaudio.com/quran/muhammad_alhaidan//',
      name: 'محمد الليحدان ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download/quranicaudio.com/quran/mehysni//',
      name: 'محمد المحيسني',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/muhaisny_1435//',
      name: '1435 محمد المحيسني  ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/muhaisny_1435//',
      name: '1435 محمد المحيسني',
      zeroPaddingSurahNumber: true,
    ),

    RecitersModel(
      url: 'https://download/quranicaudio.com/qdc/hadi_toure/mp3/',
      name: 'محمد الهادي توري  ',
      zeroPaddingSurahNumber: false,
    ),

    // ج) مجموعة "محمود"
    RecitersModel(
      url:
          'https://download/quranicaudio.com/quran/mahmood_khaleel_al-husaree_iza3a//',
      name: 'محمود خليل الحصري - إذاعة  ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/qdc/khalil_al_husary/murattal/',
      name: 'محمود خليل الحصري ',
      zeroPaddingSurahNumber: false,
    ),

    RecitersModel(
      url: 'https://download/quranicaudio.com/quran/mahmood_ali_albana//',
      name: 'محمود علي البنا  ',
      zeroPaddingSurahNumber: true,
    ),

    // د) مجموعة "مشاري"
    RecitersModel(
      url: 'https://download/quranicaudio.com/qdc/mishari_al_afasy/murattal/',
      name: 'مشاري العفاسي',
      zeroPaddingSurahNumber: false,
    ),
    RecitersModel(
      url:
          'https://download/quranicaudio.com/qdc/mishari_al_afasy/streaming/mp3/',
      name: 'مشاري العفاسي - ستريم  ',
      zeroPaddingSurahNumber: false,
    ),

    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/mishaari_california//',
      name: 'مشاري العفاسي - ختمة كاليفورنيا  ',
      zeroPaddingSurahNumber: true,
    ),

    // هـ) مجموعة "مصطفي"
    RecitersModel(
      url: 'https://download/quranicaudio.com/quran/mostafa_ismaeel//',
      name: 'مصطفي اسماعيل ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download/quranicaudio.com/quran/mustafa_al3azzawi//',
      name: 'مصطفي العزاوي ',
      zeroPaddingSurahNumber: true,
    ),

    // المجموعة (ن)
    RecitersModel(
      url: 'https://download/quranicaudio.com/quran/nabil_rifa3i//',
      name: 'نبيل رفاعي  ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download/quranicaudio.com/quran/noreen_siddiq//',
      name: 'نورين محمد صديق  ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/nasser_bin_ali_alqatami//',
      name: 'ناصر القطامي',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/hani_ar_rifai/murattal/',
      name: 'هاني الرفاعي',
      zeroPaddingSurahNumber: false,
    ),

    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/wadee_hammadi_al-yamani//',
      name: 'وديع حمادي اليمني',
      zeroPaddingSurahNumber: true,
    ),

    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/yasser_ad-dussary//',
      name: 'ياسر الدوسري 1',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/qdc/yasser_ad-dussary/mp3/',
      name: ' ياسر الدوسري 2',
      zeroPaddingSurahNumber: false,
    ),
  ];
  final TextEditingController _searchController = TextEditingController();
  List<int> filteredReciters = [];
  bool _isSearching = false;
  @override
  void initState() {
    super.initState();
    filteredReciters = List.generate(reciters.length, (index) => index);
  }

  void _filterReciter(String query) {
    setState(() {
      filteredReciters = reciters
          .asMap()
          .entries
          .where((entry) => entry.value.name.contains(query))
          .map((entry) => entry.key)
          .toList();
    });
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        _filterReciter('');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kPrimaryColor,
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: AppStyles.styleCairoMedium15white(context).color),
        backgroundColor: AppColors.kSecondaryColor,
        title: _isSearching
            ? TextField(
                controller: _searchController,
                onChanged: _filterReciter,
                style: AppStyles.styleCairoMedium15white(context),
                decoration: InputDecoration(
                  hintText: 'إبحث عن قاريء ...',
                  hintStyle: AppStyles.styleCairoMedium15white(context),
                  border: InputBorder.none,
                ),
                autofocus: true,
              )
            : Text(
                'القران المرتل',
                style: AppStyles.styleCairoBold20(context),
              ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: _toggleSearch,
              child: Icon(_isSearching ? Icons.close : Icons.search),
            ),
          )
        ],
      ),
      body: filteredReciters.isNotEmpty
          ? ListView.builder(
              itemCount: filteredReciters.length,
              itemBuilder: (context, index) {
                int actualIndex = filteredReciters[
                    index]; // Get the correct index from filteredReciters

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ListSurahsListeningPage(
                          reciter: reciters[actualIndex], // Use actualIndex
                        ),
                      ),
                    );
                  },
                  child: RecitursItem(
                    title: reciters[actualIndex].name, // Use actualIndex
                  ),
                );
              },
            )
          : Center(
              child: Text(
              'القاريء غير موجود',
              style: AppStyles.styleCairoBold20(context),
            )),
    );
  }
}
