class Artist {
  late String id;
  late String name;
  late String? biography;
  late String? description;
  late List<dynamic> listTrackId;

  Artist({
    required this.id,
    required this.name,
    this.listTrackId = const [],
  });

  Artist.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    biography = map['biography'];
    description = map['description'];
    listTrackId = map['listTrackId'];
  }

  Map<String, dynamic> toMap() {
    var map = {
      'id': id,
      'name': name,
      'biography': biography,
      'description': description,
      'listTrackId': listTrackId,
    };
    return map;
  }
}
