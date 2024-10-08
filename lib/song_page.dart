import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/bloc/song_playlist_bloc.dart';
import 'package:music_player/neu_box.dart';
import 'package:music_player/screens/playlist_page.dart';
import 'package:music_player/widgets/drawer_widget.dart';

class SongPage extends StatefulWidget {
  const SongPage({
    Key? key,
  }) : super(key: key);

  @override
  State<SongPage> createState() => _SongPageState();
}

class _SongPageState extends State<SongPage> {
  String formatTime(Duration duration) {
    String twoDigitSeconds =
        duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    String formatedTime = "${duration.inMinutes} : $twoDigitSeconds";

    return formatedTime;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      drawer: const DrawerWidget(),
      body: SafeArea(
        child: BlocBuilder<SongPlaylistBloc, SongPlaylistState>(
          builder: (context, state) {
            var currentIndex = context.read<SongPlaylistBloc>().currentIndex;
            var currentSong = state.songList[currentIndex];
            var totalDuration = context.read<SongPlaylistBloc>().totalDuration;
            var currentDuration =
                context.read<SongPlaylistBloc>().currentDuration;

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: BlocConsumer<SongPlaylistBloc, SongPlaylistState>(
                  listener: (context, state) {
                    // return;
                  },
                  builder: (context, state) {
                    return Column(
                      children: [
                        const SizedBox(height: 50),

                        // back button and menu button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              height: 60,
                              width: 60,
                              child: NeuBox(
                                  child: IconButton(
                                      onPressed: () =>
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const PlayListPage(),
                                            ),
                                          ),
                                      icon: const Icon(Icons.arrow_back))),
                            ),
                            const Text('P L A Y L I S T'),
                            SizedBox(
                              height: 60,
                              width: 60,
                              child: NeuBox(
                                  child: IconButton(
                                onPressed: () =>
                                    Scaffold.of(context).openDrawer(),
                                icon: const Icon(Icons.menu),
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
                                      currentSong.albumArtImagePath,
                                      fit: BoxFit.cover,
                                    )),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          currentSong.songName,
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
                                          currentSong.artistName,
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
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              state is SongPositionUpdated
                                  ? Text(formatTime(state.newPosition))
                                  : Text(
                                      formatTime(
                                        context
                                            .watch<SongPlaylistBloc>()
                                            .currentDuration,
                                      ),
                                    ),
                              IconButton(
                                onPressed: () {
                                  context
                                      .read<SongPlaylistBloc>()
                                      .add(ShuffleTracks());
                                },
                                icon: IconButton(
                                    icon: Icon(Icons.shuffle,
                                        color: context
                                                .read<SongPlaylistBloc>()
                                                .toggleShuffle
                                            ? Colors.green
                                            : Theme.of(context)
                                                .colorScheme
                                                .onBackground),
                                    onPressed: () {
                                      context
                                          .read<SongPlaylistBloc>()
                                          .onShuffleDisableReplay();
                                      context
                                          .read<SongPlaylistBloc>()
                                          .setToggleShuffle();
                                    }),
                              ),
                              IconButton(
                                onPressed: () {
                                  context
                                      .read<SongPlaylistBloc>()
                                      .setToggleReplay();
                                  context
                                      .read<SongPlaylistBloc>()
                                      .add(ReplayTrack());
                                },
                                icon: IconButton(
                                    icon: Icon(Icons.repeat,
                                        color: context
                                                .read<SongPlaylistBloc>()
                                                .toggleReplay
                                            ? Colors.green
                                            : Theme.of(context)
                                                .colorScheme
                                                .onBackground),
                                    onPressed: () {
                                      context
                                          .read<SongPlaylistBloc>()
                                          .onReplayDisableSuffle();
                                      context
                                          .read<SongPlaylistBloc>()
                                          .setToggleReplay();
                                    }),
                              ),
                              state is SongDurationUpdated
                                  ? Text(formatTime(state.newDuration))
                                  : Text(
                                      formatTime(
                                        context
                                            .read<SongPlaylistBloc>()
                                            .totalDuration,
                                      ),
                                    ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 10),

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
                            max: totalDuration.inSeconds.toDouble(),
                            value: currentDuration.inSeconds.toDouble(),
                            activeColor: Colors.green,
                            onChanged: (double double) {
                              context.read<SongPlaylistBloc>().add(
                                    SliderChange(
                                      sliderValueDuration:
                                          Duration(seconds: double.toInt()),
                                    ),
                                  );
                            },
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
                                    child: IconButton(
                                  onPressed: () async {
                                    context
                                        .read<SongPlaylistBloc>()
                                        .add(PreviousTrack());
                                  },
                                  icon: const Icon(
                                    Icons.skip_previous,
                                    size: 32,
                                  ),
                                )),
                              ),
                              Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0),
                                  child: NeuBox(
                                    child: (state is! SongIsPaused)
                                        ? IconButton(
                                            onPressed: () async {
                                              context
                                                  .read<SongPlaylistBloc>()
                                                  .add(PauseTrack());
                                            },
                                            icon: const Icon(
                                              Icons.pause,
                                              size: 32,
                                            ),
                                          )
                                        : IconButton(
                                            onPressed: () async {
                                              context
                                                  .read<SongPlaylistBloc>()
                                                  .add(ResumeTrack());
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
                                    child: IconButton(
                                  onPressed: () async {
                                    context
                                        .read<SongPlaylistBloc>()
                                        .add(NextTrack());
                                  },
                                  icon: const Icon(
                                    Icons.skip_next,
                                    size: 32,
                                  ),
                                )),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
