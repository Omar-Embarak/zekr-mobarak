import 'datum.dart';

class PrayingModel {
  int? code;
  String? status;
  List<Datum>? data;

  PrayingModel({this.code, this.status, this.data});

  factory PrayingModel.fromJson(Map<String, dynamic> json) => PrayingModel(
        code: json['code'] as int?,
        status: json['status'] as String?,
        data: (json['data'] as List<dynamic>?)
            ?.map((e) => Datum.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'code': code,
        'status': status,
        'data': data?.map((e) => e.toJson()).toList(),
      };
}