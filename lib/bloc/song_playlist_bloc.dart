import 'dart:async';
import 'dart:math';

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
    on<PlayTrack>(_onPlay);
    on<PauseTrack>(_onPause);
    on<ResumeTrack>(_onResume);
    on<NextTrack>(_onNext);
    on<PreviousTrack>(_onPrevious);
    on<UpdateCurrentDuration>(_onUpdatedCurrentDuration);
    on<UpdateTotalDuration>(_onUpdatedTotalDuration);
    on<SliderChange>(_onSliderChange);
    on<SongCompleted>(_onSongCompleted);
    on<ReplayTrack>(_onReplay);
    on<ShuffleTracks>(_onShuffle);

    _initializePlayerSubscriptions(); //keep listening to this function
  }

  final player = AudioPlayer();
  int _currentIndex = 0;
  Duration _currentDuration = Duration.zero;
  Duration _totalDuration = Duration.zero;
  late StreamSubscription<Duration> _durationSubscription;
  late StreamSubscription<Duration> _positionSubscription;
  bool _toggleReplay = false;
  bool _toggleShuffle = false;

  @override
  Future<void> close() {
    // Cancel subscriptions when closing the bloc
    _durationSubscription.cancel();
    _positionSubscription.cancel();
    return super.close();
  }

  void _initializePlayerSubscriptions() {
    _durationSubscription = player.onDurationChanged.listen((newDuration) {
      add(UpdateTotalDuration(newDuration: newDuration)); // Dispatch event here
    });

    _positionSubscription = player.onPositionChanged.listen((newPosition) {
      add(UpdateCurrentDuration(
          newPosition: newPosition)); // Dispatch event here
    });

    player.onPlayerComplete.listen((_) {
      if (_toggleReplay) {
        add(ReplayTrack());
      } else if (_toggleShuffle) {
        add(ShuffleTracks());
      } else {
        add(SongCompleted());
      }
    });
  }

  Future<void> _onPlay(PlayTrack event, Emitter<SongPlaylistState> emit) async {
    emit(FetchingSong());
    int newSongIndex = songList
        .indexWhere((element) => songList.indexOf(element) == _currentIndex);
    Song newSong = songList[newSongIndex];
    await player.stop();
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

  Future<void> _onReplay(
      ReplayTrack event, Emitter<SongPlaylistState> emit) async {
    int newSongIndex = songList
        .indexWhere((element) => songList.indexOf(element) == _currentIndex);
    Song newSong = songList[newSongIndex];
    await player.stop();
    await player.play(AssetSource(newSong.audioPath));
    emit(SongReplay());
  }

  Future<void> _onShuffle(
      ShuffleTracks event, Emitter<SongPlaylistState> emit) async {
    _currentIndex = Random().nextInt(songList.length);
    int newSongIndex = songList
        .indexWhere((element) => songList.indexOf(element) == _currentIndex);
    Song newSong = songList[newSongIndex];
    await player.stop();
    await player.play(AssetSource(newSong.audioPath));
    emit(SongReplay());
  }

  Future<void> _onSliderChange(
      SliderChange event, Emitter<SongPlaylistState> emit) async {
    setSeekDuration(event.sliderValueDuration);
    emit(SongSeek());
  }

  Future<void> _onUpdatedCurrentDuration(
      UpdateCurrentDuration event, Emitter<SongPlaylistState> emit) async {
    _currentDuration = event.newPosition;
    emit(SongPositionUpdated(_currentDuration));
  }

  Future<void> _onUpdatedTotalDuration(
      UpdateTotalDuration event, Emitter<SongPlaylistState> emit) async {
    _totalDuration = event.newDuration;
    emit(SongDurationUpdated(_totalDuration));
  }

  void _onSongCompleted(
      SongCompleted event, Emitter<SongPlaylistState> emit) async {
    setCurrentIndex(_currentIndex, ButtonPressed.next);
    add(NextTrack()); //event
  }

  int get currentIndex => _currentIndex;

  int setCurrentIndex(int value, ButtonPressed buttonPressed) {
    if (buttonPressed == ButtonPressed.previous) {
      if (value <= 0) {
        _currentIndex = 0;
      } else {
        _currentIndex = value - 1;
      }
    } else if (buttonPressed == ButtonPressed.play) {
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

  void setSeekDuration(Duration position) async {
    await player.seek(position);
  }

  void setToggleReplay() {
    _toggleReplay = !_toggleReplay;
  }

  void setToggleShuffle() {
    _toggleShuffle = !_toggleShuffle;
  }

  Duration get currentDuration =>
      _currentDuration <= Duration.zero ? Duration.zero : _currentDuration;

  Duration get songDuration =>
      _totalDuration <= Duration.zero ? Duration.zero : _totalDuration;

  bool get toggleReplay => _toggleReplay;
  bool get toggleShuffle => _toggleShuffle;
}
