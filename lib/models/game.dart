class Game {
  final int id;
  final String title;
  final String image;

  Game({
    required this.id,
    required this.title,
    required this.image,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      id: json['id'] ?? DateTime.now().millisecondsSinceEpoch,
      title: json['title'] ?? json['name'] ?? 'Unknown Game',
      image: json['image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'image': image,
    };
  }
}
