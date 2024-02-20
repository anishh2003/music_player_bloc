import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/bloc/song_playlist_bloc.dart';
import 'package:music_player/cubit/theme_cubit.dart';
import 'package:music_player/data/music_data.dart';
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
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ThemeCubit(),
        ),
        BlocProvider(
          create: (context) => SongPlaylistBloc(),
        )
      ],
      child: BlocBuilder<ThemeCubit, bool>(
        builder: (context, state) {
          return MaterialApp(
            theme: lighTheme,
            darkTheme: darkTheme,
            themeMode: state == false ? ThemeMode.light : ThemeMode.dark,
            debugShowCheckedModeBanner: false,
            home: SongPage(
              song: songList[0],
            ),
          );
        },
      ),
    );
  }
}
