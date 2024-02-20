import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/bloc/song_playlist_bloc.dart';
import 'package:music_player/models/song.dart';
import 'package:music_player/neu_box.dart';
import 'package:music_player/screens/playlist_page.dart';
import 'package:music_player/widgets/drawer_widget.dart';

class SongPage extends StatefulWidget {
  SongPage({
    Key? key,
    required this.song,
  }) : super(key: key);

  Song song;

  @override
  State<SongPage> createState() => _SongPageState();
}

class _SongPageState extends State<SongPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Text(
          'Music Player',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        iconTheme: IconThemeData(
            size: 30.0,
            color: Theme.of(context)
                .colorScheme
                .inversePrimary), //changes the drawer burger button icon color
      ),
      drawer: const DrawerWidget(),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: BlocBuilder<SongPlaylistBloc, SongPlaylistState>(
          builder: (context, state) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Column(
                  children: [
                    const SizedBox(height: 10),

                    // back button and menu button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(
                          height: 60,
                          width: 60,
                          child: NeuBox(child: Icon(Icons.arrow_back)),
                        ),
                        const Text('P L A Y L I S T'),
                        SizedBox(
                          height: 60,
                          width: 60,
                          child: NeuBox(
                              child: IconButton(
                            onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => PlayListPage(
                                  song: widget.song,
                                ),
                              ),
                            ),
                            icon: const Icon(Icons.music_note),
                          )),
                        ),
                      ],
                    ),

                    const SizedBox(height: 25),

                    // cover art, artist name, song name
                    NeuBox(
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: SizedBox(
                                width: 400,
                                height: 300,
                                child: Image.asset(
                                  widget.song.albumArtImagePath,
                                  fit: BoxFit.cover,
                                )),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.song.songName,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .inversePrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      widget.song.artistName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22,
                                      ),
                                    ),
                                  ],
                                ),
                                const Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                  size: 32,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    // start time, shuffle button, repeat button, end time
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('0:00'),
                          Icon(Icons.shuffle),
                          Icon(Icons.repeat),
                          Text('4:22')
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),

                    // linear bar
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        inactiveTrackColor:
                            Theme.of(context).colorScheme.primary,
                        thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 8,
                        ),
                      ),
                      child: Slider(
                        min: 0,
                        max: 100,
                        value: 50,
                        activeColor: Colors.green,
                        onChanged: (value) {},
                      ),
                    ),

                    const SizedBox(height: 30),

                    // previous song, pause play, skip next song
                    SizedBox(
                      height: 80,
                      child: Row(
                        children: [
                          Expanded(
                            child: NeuBox(
                                child: const Icon(
                              Icons.skip_previous,
                              size: 32,
                            )),
                          ),
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: NeuBox(
                                child: state is SongisPlaying
                                    ? IconButton(
                                        onPressed: () async {
                                          context.read<SongPlaylistBloc>().add(
                                              PauseTrack(song: widget.song));
                                        },
                                        icon: const Icon(
                                          Icons.pause,
                                          size: 32,
                                        ),
                                      )
                                    : IconButton(
                                        onPressed: () async {
                                          // final player = AudioPlayer();
                                          // await player.setSource(AssetSource('lib/assets/audio/Feel_Good.mp3'));
                                          // await player.play(AssetSource(
                                          //     'audio/Feel_Good.mp3'));
                                          context.read<SongPlaylistBloc>().add(
                                              PlayTrack(song: widget.song));
                                        },
                                        icon: const Icon(
                                          Icons.play_arrow,
                                          size: 32,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: NeuBox(
                                child: const Icon(
                              Icons.skip_next,
                              size: 32,
                            )),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
