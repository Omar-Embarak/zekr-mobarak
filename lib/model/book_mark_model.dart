class BookMarkModel {
  final int? id; // Should be nullable to handle new objects
  final String surahName;
  final int pageNumber;

  BookMarkModel({
    this.id,
    required this.surahName,
    required this.pageNumber,
  });

  factory BookMarkModel.fromMap(Map<String, dynamic> map) {
    return BookMarkModel(
      id: map['id'], // Ensure this maps correctly
      surahName: map['surahName'],
      pageNumber: map['pageNumber'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id, // Include id if needed
      'surahName': surahName,
      'pageNumber': pageNumber,
    };
  }
}
