import 'package:examm/repository/repository/game_repository.dart';
import 'package:flutter/material.dart';
import '../models/game.dart';

class GameBox extends ChangeNotifier {
  final List<Game> _games = [];
  final List<Game> _favorites = [];
  bool isLoading = false;

  List<Game> get games => _games;
  List<Game> get favorites => _favorites;

  final GameRepository _repository = GameRepository();
  final List<Game> _localAddedGames = [];
  Future<void> loadGames() async {
    try {
      isLoading = true;
      notifyListeners();

      final fetchedGames = await _repository.fetchGames();

      final updatedGames =
          fetchedGames.map((game) {
            final imageUrl =
                game.image.isNotEmpty
                    ? game.image
                    : 'https://picsum.photos/seed/${game.id}/1000/1200';
            return Game(id: game.id, title: game.title, image: imageUrl);
          }).toList();

      _games.clear();
      _games.addAll(updatedGames);
    } catch (e) {
      print('xato: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void addGame(Game game) {
    _localAddedGames.add(game);

    _games.add(game);
    notifyListeners();
  }

  void deleteGame(int id) {
    _games.removeWhere((g) => g.id == id);
    _favorites.removeWhere((g) => g.id == id);
    _localAddedGames.removeWhere((g) => g.id == id);
    notifyListeners();
  }

  void updateGame(Game updatedGame) {
    final index = _games.indexWhere((g) => g.id == updatedGame.id);
    if (index != -1) {
      _games[index] = updatedGame;
      notifyListeners();
    }

    final localIndex = _localAddedGames.indexWhere(
      (g) => g.id == updatedGame.id,
    );
    if (localIndex != -1) {
      _localAddedGames[localIndex] = updatedGame;
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
