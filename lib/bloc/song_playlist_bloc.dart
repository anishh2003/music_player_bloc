import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/data/music_data.dart';
import 'package:music_player/models/song.dart';
import 'package:flutter/foundation.dart';
import 'package:music_player/song_playlist_manager.dart';
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
    // on<SliderChange>(_onSliderChange);
    // on<SongCompleted>(_onSongCompleted);
    on<ReplayTrack>(_onReplay);
    on<ShuffleTracks>(_onShuffle);
    on<ReplayShuffleToggle>(_onReplayShuffleToggle);

    _initializePlayerSubscriptions(); //keep listening to this function
  }

  bool _toggleReplay = false;
  bool _toggleShuffle = false;

  final SongPlaylistManager _manager = SongPlaylistManager(songList);

  @override
  Future<void> close() {
    // Cancel subscriptions when closing the bloc
    _manager.dispose();
    return super.close();
  }

  void _initializePlayerSubscriptions() {
    _manager.player.onDurationChanged.listen((_) {
      add(UpdateTotalDuration(
          newDuration: _manager.totalDuration)); // Dispatch event here
    });

    _manager.player.onPositionChanged.listen((_) {
      add(UpdateCurrentDuration(
          newPosition: _manager.currentDuration)); // Dispatch event here
    });

    _manager.player.onPlayerComplete.listen((_) {
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
    int newSongIndex = songList.indexWhere(
        (element) => songList.indexOf(element) == event.selectedIndex);
    _manager.currentIndex = newSongIndex;
    _manager.play();

    emit(SongisPlaying());
  }

  Future<void> _onPause(
      PauseTrack event, Emitter<SongPlaylistState> emit) async {
    await _manager.pause();
    emit(SongIsPaused());
  }

  Future<void> _onResume(
      ResumeTrack event, Emitter<SongPlaylistState> emit) async {
    await _manager.resume();
    emit(SongResumed());
  }

  Future<void> _onReplayShuffleToggle(
      ReplayShuffleToggle event, Emitter<SongPlaylistState> emit) async {
    emit(ReplayShuffleToggleState());
  }

  Future<void> _onNext(NextTrack event, Emitter<SongPlaylistState> emit) async {
    _manager.next();
    emit(SongisPlaying());
  }

  Future<void> _onPrevious(
      PreviousTrack event, Emitter<SongPlaylistState> emit) async {
    _manager.previous();
    emit(SongisPlaying());
  }

  Future<void> _onReplay(
      ReplayTrack event, Emitter<SongPlaylistState> emit) async {
    _manager.replay();
    emit(SongReplay());
  }

  Future<void> _onShuffle(
      ShuffleTracks event, Emitter<SongPlaylistState> emit) async {
    // _totalDuration = Duration.zero;
    // _currentDuration = Duration.zero;
    // _currentIndex = Random().nextInt(songList.length);
    // int newSongIndex = songList
    //     .indexWhere((element) => songList.indexOf(element) == _currentIndex);
    _manager.shuffle();
    emit(SongReplay());
  }

  // Future<void> _onSliderChange(
  //     SliderChange event, Emitter<SongPlaylistState> emit) async {
  //   setSeekDuration(event.sliderValueDuration);
  //   emit(SongSeek());
  // }

  Future<void> _onUpdatedCurrentDuration(
      UpdateCurrentDuration event, Emitter<SongPlaylistState> emit) async {
    _manager.currentDuration = event.newPosition;
    emit(SongPositionUpdated(_manager.currentDuration));
  }

  Future<void> _onUpdatedTotalDuration(
      UpdateTotalDuration event, Emitter<SongPlaylistState> emit) async {
    _manager.totalDuration = event.newDuration;
    emit(SongDurationUpdated(_manager.totalDuration));
  }

  // void _onSongCompleted(
  //     SongCompleted event, Emitter<SongPlaylistState> emit) async {
  //   setCurrentIndex(_currentIndex, ButtonPressed.next);
  //   add(NextTrack()); //event
  // }

  int get currentIndex => _manager.currentIndex;

  // int setCurrentIndex(int value, ButtonPressed buttonPressed) {
  //   if (buttonPressed == ButtonPressed.previous) {
  //     if (value <= 0) {
  //       _currentIndex = 0;
  //     } else {
  //       _currentIndex = value - 1;
  //     }
  //   } else if (buttonPressed == ButtonPressed.play) {
  //     _currentIndex = value;
  //   } else if (buttonPressed == ButtonPressed.pause) {
  //     _currentIndex = value;
  //   } else {
  //     if (value >= songList.length - 1) {
  //       _currentIndex = 0;
  //     } else {
  //       _currentIndex = value + 1;
  //     }
  //   }

  //   return _currentIndex;
  // }

  // void setSeekDuration(Duration position) async {
  //   await player.seek(position);
  // }

  void setToggleReplay() {
    _toggleReplay = !_toggleReplay;
    add(ReplayShuffleToggle());
  }

  void setToggleShuffle() {
    _toggleShuffle = !_toggleShuffle;
    add(ReplayShuffleToggle());
  }

  void onShuffleDisableReplay() {
    _toggleReplay = false;
  }

  void onReplayDisableSuffle() {
    _toggleShuffle = false;
  }

  // Duration get currentDuration =>
  //     _currentDuration <= Duration.zero ? Duration.zero : _currentDuration;

  // Duration get songDuration {
  //   return _totalDuration <= Duration.zero ? Duration.zero : _totalDuration;
  // }

  bool get toggleReplay => _toggleReplay;
  bool get toggleShuffle => _toggleShuffle;

  Duration get currentDuration => _manager.currentDuration;

  Duration get totalDuration => _manager.totalDuration;
}
