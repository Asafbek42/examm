import 'package:examm/repository/repository/game_repository.dart';
import 'package:flutter/material.dart';
import '../models/game.dart';

class GameBox extends ChangeNotifier {
  final List<Game> _apiGames = [];
  final List<Game> _userGames = [];
  final List<Game> _favorites = [];
  bool isLoading = false;

  List<Game> get games => [..._userGames, ..._apiGames];
  List<Game> get favorites => _favorites;

  final GameRepository _repository = GameRepository();

  Future<void> loadGames() async {
    try {
      isLoading = true;
      notifyListeners();

      final fetchedGames = await _repository.fetchGames();

      final updatedGames = fetchedGames.map((game) {
        final imageUrl = (game.image.isNotEmpty &&
                Uri.tryParse(game.image)?.hasAbsolutePath == true)
            ? game.image
            : 'https://picsum.photos/seed/${game.id}/1000/1200';
        return Game(id: game.id, title: game.title, image: imageUrl);
      }).toList();

      _apiGames.clear();
      _apiGames.addAll(updatedGames);
    } catch (e) {
      print('xato');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void addGame(Game game) {
    _userGames.add(game);
    notifyListeners();
  }

  void deleteGame(int id) {
    _userGames.removeWhere((g) => g.id == id);
    _apiGames.removeWhere((g) => g.id == id);
    _favorites.removeWhere((g) => g.id == id);
    notifyListeners();
  }

  void updateGame(Game updatedGame) {
    final index = _userGames.indexWhere((g) => g.id == updatedGame.id);
    if (index != -1) {
      _userGames[index] = updatedGame;
      notifyListeners();
    }
  }

  void addToFavorites(Game game) {
    if (!_favorites.contains(game)) {
      _favorites.add(game);
      notifyListeners();
    }
  }

  void removeFromFavorites(Game game) {
    _favorites.remove(game);
    notifyListeners();
  }

  bool isFavorite(Game game) {
    return _favorites.contains(game);
  }
}
