import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AboutGamee extends StatefulWidget {
  final int gameId;

  const AboutGamee({Key? key, required this.gameId}) : super(key: key);

  @override
  State<AboutGamee> createState() => _AboutGameeState();
}

class _AboutGameeState extends State<AboutGamee> {
  Map<String, dynamic>? gameData;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    fetchGameDetails();
  }

  Future<void> fetchGameDetails() async {
    try {
      final response = await http.get(
        Uri.parse('https://api.sampleapis.com/playstation/games'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> gamesList = json.decode(response.body);

        final gameJson = gamesList.firstWhere(
          (element) => element['id'] == widget.gameId,
          orElse: () => null,
        );

        if (gameJson == null) {
          setState(() {
            error = 'Игра с id ${widget.gameId} не найдена';
            isLoading = false;
          });
          return;
        }

        setState(() {
          gameData = Map<String, dynamic>.from(gameJson);
          isLoading = false;
        });
      } else {
        setState(() {
          error = 'Ошибка сервера: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Загрузка игры...')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Ошибка')),
        body: Center(child: Text('Ошибка: $error')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(gameData?['title'] ?? 'Игра'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (gameData?['image'] != null && gameData!['image'].isNotEmpty)
              Image.network(
                gameData!['image'],
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    const Center(child: Icon(Icons.broken_image, size: 40)),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            const SizedBox(height: 16),
            Text(
              gameData?['name'] ?? 'Без названия',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (gameData?['genre'] != null)
              Text('Жанры: ${List<String>.from(gameData!['genre']).join(', ')}'),
            if (gameData?['developers'] != null)
              Text('Разработчики: ${List<String>.from(gameData!['developers']).join(', ')}'),
            if (gameData?['publishers'] != null)
              Text('Издатели: ${List<String>.from(gameData!['publishers']).join(', ')}'),
            const SizedBox(height: 8),
            if (gameData?['releaseDates'] != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Даты выхода:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  ...Map<String, dynamic>.from(gameData!['releaseDates'])
                      .entries
                      .map(
                        (e) => Text('${e.key}: ${e.value}'),).toList(),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
