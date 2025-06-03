import 'dart:convert';
import 'package:http/http.dart' as http;
import '/models/game.dart';

class GameRepository {
  static const String _baseUrl = 'https://api.sampleapis.com/playstation/games';

  Future<List<Game>> fetchGames() async {
    final response = await http.get(Uri.parse(_baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => Game.fromJson(item)).toList();
    } else {
      throw Exception('zagruzka bumadi');
    }
  }
}
