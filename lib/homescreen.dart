import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'box/game_box.dart';
import 'models/game.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final box = context.watch<GameBox>();

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: const Color(0xFF1E1E1E),
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text('Game Store'),
          centerTitle: true,
          bottom: const TabBar(
            indicatorColor: Colors.deepPurpleAccent,
            tabs: [
              Tab(text: 'Popular'),
              Tab(text: 'Trending'),
              Tab(text: 'New Launch'),
              Tab(text: 'Favorites'),
            ],
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey, width: 1.5),
                      ),
                      child: const TextField(
                        style: TextStyle(color: Colors.white),
                        cursorColor: Colors.white,
                        decoration: InputDecoration(
                          icon: Icon(Icons.search, color: Colors.grey),
                          hintText: 'Search',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Container(
                    width: 50,
                    height: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white),
                    ),
                    child: InkWell(
                      focusColor: const Color.fromARGB(255, 99, 97, 97),
                      splashColor: Colors.white,
                      onTap: () {},
                      child: const Icon(
                        Icons.notification_add,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  const GameGrid(),
                  const GameGrid(),
                  const GameGrid(),
                  const FavoritesGrid(),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.deepPurpleAccent,
          onPressed: () => _showAddGameDialog(context),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  void _showAddGameDialog(BuildContext context) {
    final titleController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Add Game'),
            content: TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
              autofocus: true,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  final title = titleController.text.trim();
                  if (title.isNotEmpty) {
                    final newGame = Game(
                      id: DateTime.now().millisecondsSinceEpoch,
                      title: title,
                      // Ставим дефолтную картинку
                      image: 'https://picsum.photos/seed/defaultgame/400/600',
                    );
                    context.read<GameBox>().addGame(newGame);
                    Navigator.pop(context);
                  }
                },
                child: const Text('Add'),
              ),
            ],
          ),
    );
  }
}

class GameGrid extends StatelessWidget {
  const GameGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final games = context.watch<GameBox>().games;
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio:
            2 / 3, 
      ),
      itemCount: games.length,
      itemBuilder: (context, index) {
        final game = games[index];
        final isFavorite = context.watch<GameBox>().isFavorite(game);
        return GameCard(game: game, isFavorite: isFavorite);
      },
    );
  }
}

class FavoritesGrid extends StatelessWidget {
  const FavoritesGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final favorites = context.watch<GameBox>().favorites;

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 3 / 4,
      ),
      itemCount: favorites.length,
      itemBuilder: (context, index) {
        final game = favorites[index];
        return GameCard(game: game, isFavorite: true);
      },
    );
  }
}

class GameCard extends StatelessWidget {
  final Game game;
  final bool isFavorite;

  const GameCard({super.key, required this.game, this.isFavorite = false});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Colors.white, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: Image.network(
                game.image,
                fit: BoxFit.cover,
                errorBuilder:
                    (_, __, ___) =>
                        const Center(child: Icon(Icons.broken_image, size: 40)),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
            child: Text(
              game.title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  tooltip: 'Delete',
                  onPressed: () {
                    context.read<GameBox>().deleteGame(game.id);
                  },
                  icon: const Icon(Icons.delete, color: Colors.red),
                ),
                IconButton(
                  tooltip: 'Edit',
                  onPressed: () {
                    _showEditGameDialog(context, game);
                  },
                  icon: const Icon(Icons.edit, color: Colors.blue),
                ),
                IconButton(
                  tooltip: 'Favorite',
                  onPressed: () {
                    if (isFavorite) {
                      context.read<GameBox>().removeFromFavorites(game);
                    } else {
                      context.read<GameBox>().addToFavorites(game);
                    }
                  },
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showEditGameDialog(BuildContext context, Game game) {
    final titleController = TextEditingController(text: game.title);

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Edit Game'),
            content: TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
              autofocus: true,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  final updatedTitle = titleController.text;
                  if (updatedTitle.isNotEmpty) {
                    final updatedGame = Game(
                      id: game.id,
                      title: updatedTitle,
                      image: game.image,
                    );
                    context.read<GameBox>().updateGame(updatedGame);
                    Navigator.pop(context);
                  }
                },
                child: const Text('Update'),
              ),
            ],
          ),
    );
  }
}
