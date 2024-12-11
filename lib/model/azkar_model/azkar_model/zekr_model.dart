class ZekrModel {
  final int id;
  final String zekrCatgory;
  final List zekrList;
  ZekrModel({required this.zekrCatgory,required this.zekrList, required this.id});
  Map<String, dynamic> toMap() {
    return {
      'id': id, // Include id if needed
      'zekrCatgory': zekrCatgory,
      'zekrList': zekrList,
    };
  }
    factory ZekrModel.fromMap(Map<String, dynamic> map) {
    return ZekrModel(
      id: map['id'], // Ensure this maps correctly
      zekrCatgory: map['zekrCatgory'],
      zekrList: map['zekrList'],
    );
  }
}
