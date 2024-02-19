import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/bloc/song_playlist_bloc.dart';

class PlayListPage extends StatelessWidget {
  const PlayListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SongPlaylistBloc, SongPlaylistState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Theme.of(context).colorScheme.background,
            title: Text(
              'PlayList',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            iconTheme: IconThemeData(
                size: 30.0,
                color: Theme.of(context)
                    .colorScheme
                    .inversePrimary), //changes the drawer burger button icon color
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView.builder(
                  itemCount: state.songList.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        leading: Image.asset(
                          state.songList[index].albumArtImagePath,
                          scale: 2,
                        ),
                        title: Text(state.songList[index].songName),
                        subtitle: Text(state.songList[index].artistName),
                        trailing: const Icon(Icons.arrow_forward),
                      ),
                    );
                  }),
            ),
          ),
        );
      },
    );
  }
}