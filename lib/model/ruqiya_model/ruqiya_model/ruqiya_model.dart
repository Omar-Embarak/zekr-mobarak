class RuqiyaModel {
  String? id;

  String? text;

  String? info;

  RuqiyaModel({this.id, this.text, this.info});

  factory RuqiyaModel.fromJson(Map<String, dynamic> json) => RuqiyaModel(
        id: json['id'] as String?,
        text: json['text'] as String?,
        info: json['info'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'text': text,
        'info': info,
      };
}
