class Game {
  final int id;
  final String name;
  final List<String> genre;
  final List<String> developers;
  final List<String> publishers;
  final Map<String, String> releaseDates;
  final String imageAsset; // Путь к локальному ассету

  Game({
    required this.id,
    required this.name,
    required this.genre,
    required this.developers,
    required this.publishers,
    required this.releaseDates,
    required this.imageAsset,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      id: json['id'],
      name: json['name'],
      genre: List<String>.from(json['genre'] ?? []),
      developers: List<String>.from(json['developers'] ?? []),
      publishers: List<String>.from(json['publishers'] ?? []),
      releaseDates: Map<String, String>.from(json['releaseDates'] ?? {}),
      imageAsset: json['imageAsset'] ?? 'assets/images/default.jpg',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'genre': genre,
      'developers': developers,
      'publishers': publishers,
      'releaseDates': releaseDates,
      'imageAsset': imageAsset,
    };
  }
}
