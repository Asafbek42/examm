import 'package:examm/repository/repository/game_repository.dart';
import 'package:flutter/material.dart';
import '../models/game.dart';



class GameBox with ChangeNotifier {
  List<Game> _games = [];
  final List<int> _favoriteGameIds = [];

  List<Game> get games => _games;


  List<Game> get favorites =>
      _games.where((game) => _favoriteGameIds.contains(game.id)).toList();

  Future<void> fetchGames() async {
    _games = await GameRepository().fetchGames();
    notifyListeners();
  }

  Future<void> addGame(Game game) async {
    final newGame = await GameRepository().addGame(game);
    _games.add(newGame);
    notifyListeners();
  }

  Future<void> updateGame(Game game) async {
    await GameRepository().updateGame(game);
    final index = _games.indexWhere((g) => g.id == game.id);
    if (index != -1) {
      _games[index] = game;
      notifyListeners();
    }
  }

  Future<void> deleteGame(int id) async {
    await GameRepository().deleteGame(id);
    _games.removeWhere((g) => g.id == id);
    _favoriteGameIds.remove(id);
    notifyListeners();
  }

  bool isFavorite(Game game) => _favoriteGameIds.contains(game.id);

  void addToFavorites(Game game) {
    if (!isFavorite(game)) {
      _favoriteGameIds.add(game.id);
      notifyListeners();
    }
  }

  void removeFromFavorites(Game game) {
    if (isFavorite(game)) {
      _favoriteGameIds.remove(game.id);
      notifyListeners();
    }
  }

  void toggleFavorite(Game game) {
    if (isFavorite(game)) {
      _favoriteGameIds.remove(game.id);
    } else {
      _favoriteGameIds.add(game.id);
    }
    notifyListeners();
  }
}
