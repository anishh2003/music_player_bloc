import 'package:flutter/material.dart';
import 'package:music_player/song_page.dart';
import 'package:music_player/theme/dart_theme.dart';
import 'package:music_player/theme/light_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: lighTheme,
      darkTheme: darkTheme,
      debugShowCheckedModeBanner: false,
      home: const SongPage(),
    );
  }
}
