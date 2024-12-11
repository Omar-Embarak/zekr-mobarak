class FavDarsModel {
  final int? id;
  final String name;
  final String url;

  FavDarsModel({this.id, required this.name, required this.url});
  factory FavDarsModel.fromMap(Map<String, dynamic> map) {
    return FavDarsModel(
      id: map['id'], // Ensure this maps correctly
      name: map['name'],
      url: map['url'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id, // Include id if needed
      'name': name,
      'url': url,
    };
  }
}
