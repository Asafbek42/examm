import 'package:examm/homescreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'box/game_box.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => GameBox()..loadGames(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const HomeScreen(),
    );
  }
}
