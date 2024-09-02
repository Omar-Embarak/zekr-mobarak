class Hizb {
  final int startSurah;
  final int startVerse;
  final String ayahText;

  Hizb({required this.startSurah, required this.startVerse, required this.ayahText});

  factory Hizb.fromJson(Map<String, dynamic> json) {
    return Hizb(
      startSurah: int.parse(json['surah']),
      startVerse: int.parse(json['verse']),
      ayahText: json['ayah_text'],
    );
  }
}

class Juz {
  final int juzIndex;
  final List<Hizb> hizbs;

  Juz({required this.juzIndex, required this.hizbs});

  factory Juz.fromJson(Map<String, dynamic> json) {
    List<Hizb> hizbs = [];
    for (int i = 1; i <= 8; i++) {
      hizbs.add(Hizb.fromJson(json['hizb_$i']['start']));
    }
    return Juz(
      juzIndex: int.parse(json['juz_index']),
      hizbs: hizbs,
    );
  }
}
