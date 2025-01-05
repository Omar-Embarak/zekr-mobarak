class Timings {
  String? fajr;
  String? sunrise;
  String? dhuhr;
  String? asr;
  String? maghrib;
  String? isha;
  String? imsak;

  Timings({
    this.fajr,
    this.sunrise,
    this.dhuhr,
    this.asr,
    this.maghrib,
    this.isha,
  });

  factory Timings.fromJson(Map<String, dynamic> json) => Timings(
        fajr: json['Fajr']?.toString(),
        sunrise: json['Sunrise']?.toString(),
        dhuhr: json['Dhuhr']?.toString(),
        asr: json['Asr']?.toString(),
        maghrib: json['Maghrib']?.toString(),
        isha: json['Isha']?.toString(),
      );

  Map<String, dynamic> toJson() => {
        'Fajr': fajr,
        'Sunrise': sunrise,
        'Dhuhr': dhuhr,
        'Asr': asr,
        'Maghrib': maghrib,
        'Isha': isha,
        'Imsak': imsak,
      };
  // Map model to SQLite table columns
  Map<String, dynamic> toMap() {
    return {
      'Fajr': fajr,
      'Sunrise': sunrise,
      'Dhuhr': dhuhr,
      'Asr': asr,
      'Maghrib': maghrib,
      'Isha': isha,
    };
  }

  static Timings fromMap(Map<String, dynamic> map) {
    return Timings(
      fajr: map['Fajr'],
      sunrise: map['Sunrise'],
      dhuhr: map['Dhuhr'],
      asr: map['Asr'],
      maghrib: map['Maghrib'],
      isha: map['Isha'],
    );
  }
}
