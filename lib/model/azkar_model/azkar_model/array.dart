class Array {
  int? id;
  String? text;
  int? count;
  String? audio;
  String? filename;

  Array({this.id, this.text, this.count, this.audio, this.filename});

  factory Array.fromJson(Map<String, dynamic> json) => Array(
        id: json['id'] as int?,
        text: json['text'] as String?,
        count: json['count'] as int?,
        audio: json['audio'] as String?,
        filename: json['filename'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'text': text,
        'count': count,
        'audio': audio,
        'filename': filename,
      };
}
