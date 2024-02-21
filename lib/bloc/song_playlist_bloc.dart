import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/data/music_data.dart';
import 'package:music_player/models/song.dart';
import 'package:flutter/foundation.dart';
part 'song_playlist_event.dart';
part 'song_playlist_state.dart';

enum ButtonPressed {
  previous,
  play,
  pause,
  next,
}

class SongPlaylistBloc extends Bloc<SongPlaylistEvent, SongPlaylistState> {
  SongPlaylistBloc() : super(SongPlaylistInitial(songList)) {
    // on<SongPlaylistEvent>(_onLoadToDo);
    on<PlayTrack>(_onPlay);
    on<PauseTrack>(_onPause);
    on<ResumeTrack>(_onResume);
    on<NextTrack>(_onNext);
    on<PreviousTrack>(_onPrevious);
    on<SliderChange>(_onSliderChange);

    // setSongDuration();
  }

  final player = AudioPlayer();
  int _currentIndex = 0;
  Duration _currentDuration = Duration.zero;
  Duration _totalDuration = Duration.zero;
  Duration _seekDuration = Duration.zero;

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
    int newSongIndex = songList
        .indexWhere((element) => songList.indexOf(element) == _currentIndex);
    Song newSong = songList[newSongIndex];
    await player.stop();
    // setSongDuration();
    await player.play(AssetSource(newSong.audioPath));

    emit(SongisPlaying());
  }

  Future<void> _onPause(
      PauseTrack event, Emitter<SongPlaylistState> emit) async {
    await player.pause();
    emit(SongIsPaused());
  }

  Future<void> _onResume(
      ResumeTrack event, Emitter<SongPlaylistState> emit) async {
    await player.resume();
    emit(SongResumed());
  }

  Future<void> _onNext(NextTrack event, Emitter<SongPlaylistState> emit) async {
    int newSongIndex = songList
        .indexWhere((element) => songList.indexOf(element) == _currentIndex);
    Song newSong = songList[newSongIndex];
    await player.stop();
    await player.play(AssetSource(newSong.audioPath));
    emit(SongisPlaying());
  }

  Future<void> _onPrevious(
      PreviousTrack event, Emitter<SongPlaylistState> emit) async {
    int newSongIndex = songList
        .indexWhere((element) => songList.indexOf(element) == _currentIndex);
    Song newSong = songList[newSongIndex];
    await player.stop();
    await player.play(AssetSource(newSong.audioPath));
    emit(SongisPlaying());
  }

  Future<void> _onSliderChange(
      SliderChange event, Emitter<SongPlaylistState> emit) async {
    setSeekDuration(event.sliderValueDuration);
    // setSongDuration();
    emit(SongSeek());
  }

  int get currentIndex => _currentIndex;

  int setCurrentIndex(int value, ButtonPressed buttonPressed) {
    if (buttonPressed == ButtonPressed.previous) {
      if (value < 0) {
        _currentIndex = 0;
      } else {
        _currentIndex = value - 1;
      }
    }
    if (buttonPressed == ButtonPressed.play) {
      _currentIndex = value;
    } else if (buttonPressed == ButtonPressed.pause) {
      _currentIndex = value;
    } else {
      if (value >= songList.length - 1) {
        _currentIndex = 0;
      } else {
        _currentIndex = value + 1;
      }
    }

    return _currentIndex;
  }

  Stream<Duration> getSongTotalDuration() {
    return player.onDurationChanged.map((newDuration) {
      _totalDuration = newDuration;
      return _totalDuration;
    });
  }

  Stream<Duration> getCurrentSonglDuration() {
    return player.onPositionChanged.map((newPosition) {
      _currentDuration = newPosition;
      return _currentDuration;
    });
  }

  void setSeekDuration(Duration position) async {
    await player.seek(position);
    // _currentDuration = position;
  }

  Duration get currentDuration => _currentDuration;

  Duration get songDuration => _totalDuration;
}
