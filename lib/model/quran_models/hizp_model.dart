
class Hizb {
  final Start start;

  Hizb({required this.start});

  factory Hizb.fromJson(Map<String, dynamic> json) {
    return Hizb(start: Start.fromJson(json['start']));
  }
}

class Start {
  final String surah;
  final String verse;
  final String ayahText;

  Start({required this.surah, required this.verse, required this.ayahText});

  factory Start.fromJson(Map<String, dynamic> json) {
    return Start(
      surah: json['surah'],
      verse: json['verse'],
      ayahText: json['ayah_text'],
    );
  }
}