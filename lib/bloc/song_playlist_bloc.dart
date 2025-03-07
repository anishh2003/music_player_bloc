import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/data/music_data.dart';
import 'package:music_player/models/song.dart';
import 'package:flutter/foundation.dart';
import 'package:music_player/song_playlist_manager.dart';
part 'song_playlist_event.dart';
part 'song_playlist_state.dart';

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
    on<ReplayShuffleToggle>(_onReplayShuffleToggle);

    _initializeBlocPlayerSubscriptions(); //keep listening to this function
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

  void _initializeBlocPlayerSubscriptions() {
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
    emit(SongisPlaying());
  }

  Future<void> _onReplayShuffleToggle(
      ReplayShuffleToggle event, Emitter<SongPlaylistState> emit) async {
    emit(SongisPlaying());
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
    _manager.shuffle();
    emit(SongShuffle());
  }

  Future<void> _onSliderChange(
      SliderChange event, Emitter<SongPlaylistState> emit) async {
    _manager.onSliderChange(event.sliderValueDuration);
    emit(SongSeek());
  }

  Future<void> _onUpdatedCurrentDuration(
      UpdateCurrentDuration event, Emitter<SongPlaylistState> emit) async {
    _manager.currentDuration = event.newPosition;
    emit(SongPositionUpdated(
        newPosition: _manager.currentDuration, songList: songList));
  }

  Future<void> _onUpdatedTotalDuration(
      UpdateTotalDuration event, Emitter<SongPlaylistState> emit) async {
    _manager.totalDuration = event.newDuration;
    emit(SongDurationUpdated(
      newDuration: _manager.totalDuration,
      songList: songList,
    ));
  }

  void _onSongCompleted(
      SongCompleted event, Emitter<SongPlaylistState> emit) async {
    add(NextTrack()); //event
  }

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

  bool get toggleReplay => _toggleReplay;
  bool get toggleShuffle => _toggleShuffle;

  int get currentIndex => _manager.currentIndex;

  Duration get currentDuration {
    if ((_manager.currentDuration <= Duration.zero) ||
        (_manager.currentDuration >= _manager.totalDuration)) {
      return Duration.zero;
    } else {
      return _manager.currentDuration;
    }
  }

  Duration get totalDuration => _manager.totalDuration <= Duration.zero
      ? Duration.zero
      : _manager.totalDuration;
}
