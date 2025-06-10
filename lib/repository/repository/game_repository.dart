import 'dart:convert';
import 'package:http/http.dart' as http;
import '/models/game.dart';

class GameRepository {
  final String baseUrl = 'https://api.sampleapis.com/playstation/games';

  Future<List<Game>> fetchGames() async {
    final res = await http.get(Uri.parse(baseUrl));
    if (res.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(res.body);
      return jsonData.map((item) => Game.fromJson(item)).toList();
    } else {
      throw Exception('Ошибка загрузки данных');
    }
  }

  Future<Game> addGame(Game game) async {
    final res = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(game.toJson()),
    );
    if (res.statusCode == 200 || res.statusCode == 201) {
      return Game.fromJson(json.decode(res.body));
    } else {
      throw Exception('Ошибка при добавлении игры');
    }
  }

  Future<void> updateGame(Game game) async {
    final res = await http.put(
      Uri.parse('$baseUrl/${game.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(game.toJson()),
    );
    if (res.statusCode != 200) {
      throw Exception('Ошибка обновления игры');
    }
  }

  Future<void> deleteGame(int id) async {
    final res = await http.delete(Uri.parse('$baseUrl/$id'));
    if (res.statusCode != 200 && res.statusCode != 204) {
      throw Exception('Ошибка удаления игры');
    }
  }
}
