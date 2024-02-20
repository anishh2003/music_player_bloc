import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/bloc/song_playlist_bloc.dart';
import 'package:music_player/models/song.dart';
import 'package:music_player/song_page.dart';

class PlayListPage extends StatelessWidget {
  const PlayListPage({
    super.key,
    required this.song,
  });

  final Song song;

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
                    return GestureDetector(
                      child: Card(
                        child: ListTile(
                          leading: SizedBox(
                            width: 60.0,
                            height: 60.0,
                            child: Image.asset(
                                state.songList[index].albumArtImagePath,
                                fit: BoxFit.cover),
                          ),
                          title: Text(state.songList[index].songName),
                          subtitle: Text(state.songList[index].artistName),
                          trailing: const Icon(Icons.arrow_forward),
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                SongPage(song: state.songList[index]),
                          ),
                        );
                      },
                    );
                  }),
            ),
          ),
        );
      },
    );
  }
}
