class Game {
  final int id;
  final String title;
  final String image;
  final List<String> genre;
  final List<String> developers;
  final List<String> publishers;
  final Map<String, String> releaseDates;

  Game({
    required this.id,
    required this.title,
    required this.image,
    this.genre = const [],
    this.developers = const [],
    this.publishers = const [],
    this.releaseDates = const {},
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      id: json['id'] ?? DateTime.now().millisecondsSinceEpoch,
      title: json['title'] ?? json['name'] ?? 'Unknown Game',
      image: json['image'] ?? '',
      genre: (json['genre'] != null)
          ? List<String>.from(json['genre'])
          : [],
      developers: (json['developers'] != null)
          ? List<String>.from(json['developers'])
          : [],
      publishers: (json['publishers'] != null)
          ? List<String>.from(json['publishers'])
          : [],
      releaseDates: (json['releaseDates'] != null)
          ? Map<String, String>.from(json['releaseDates'])
          : {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'image': image,
      'genre': genre,
      'developers': developers,
      'publishers': publishers,
      'releaseDates': releaseDates,
    };
  }
}
