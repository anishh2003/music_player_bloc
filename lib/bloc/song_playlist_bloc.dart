import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/data/music_data.dart';
import 'package:music_player/models/song.dart';
import 'package:flutter/foundation.dart';
part 'song_playlist_event.dart';
part 'song_playlist_state.dart';

class SongPlaylistBloc extends Bloc<SongPlaylistEvent, SongPlaylistState> {
  SongPlaylistBloc() : super(SongPlaylistInitial(songList)) {
    // on<SongPlaylistEvent>(_onLoadToDo);
    on<PlayTrack>(_onPlay);
    on<PauseTrack>(_onPause);
  }

  final player = AudioPlayer();

  // void _onLoadToDo(SongPlaylistEvent event, Emitter<SongPlaylistState> emit) {
  //   emit(SongPlaylistInitial(songList));
  //   try {
  //     // final tasks = await _taskRepository.getTask();
  //     // emit(const TodoLoaded([]));
  //   } catch (e) {
  //     // emit(TodoError(error: e.toString(), const []));
  //   }
  // }

  Future<void> _onPlay(PlayTrack event, Emitter<SongPlaylistState> emit) async {
    emit(FetchingSong());
    await player.play(AssetSource(event.song.audioPath));
    emit(SongisPlaying(song: event.song));
  }

  Future<void> _onPause(
      PauseTrack event, Emitter<SongPlaylistState> emit) async {
    await player.pause();
    emit(SongIsPaused());
  }
}
