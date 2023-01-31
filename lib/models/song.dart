class Song {
  late String id;
  late String name;
  late String artistName;
  late String imageUrl;
  late String songUrl;

  Song({
    required this.id,
    required this.name,
    required this.artistName,
    required this.imageUrl,
    required this.songUrl,
  });

  Song.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    artistName = map['artistName'];
    imageUrl = map['imageUrl'];
    songUrl = map['songUrl'];
  }

  Map<String, dynamic> toMap() {
    var map = {
      'id': id,
      'name': name,
      'artistName': artistName,
      'imageUrl': imageUrl,
      'songUrl': songUrl,
    };
    return map;
  }
}
