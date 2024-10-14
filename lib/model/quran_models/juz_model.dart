import 'hizp_model.dart';

class Juz {
  final String juzIndex;
  final Map<String, Hizb> hizbs;

  Juz({required this.juzIndex, required this.hizbs});

  factory Juz.fromJson(Map<String, dynamic> json) {
    final hizbs = <String, Hizb>{};
    json.forEach((key, value) {
      if (key.startsWith('hizb')) {
        hizbs[key] = Hizb.fromJson(value);
      }
    });
    return Juz(juzIndex: json['juz_index'], hizbs: hizbs);
  }
}

