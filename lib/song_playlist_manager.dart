import 'dart:async';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:music_player/models/song.dart';

class SongPlaylistManager {
  final AudioPlayer player = AudioPlayer();
  late StreamSubscription<Duration> _durationSubscription;
  late StreamSubscription<Duration> _positionSubscription;
  bool _toggleReplay = false;
  bool _toggleShuffle = false;
  late List<Song> _songList;
  late Duration _currentDuration;
  late Duration _totalDuration;
  late int _currentIndex;

  SongPlaylistManager(this._songList) {
    _currentDuration = Duration.zero;
    _totalDuration = Duration.zero;
    _currentIndex = 0;
    _initializePlayerSubscriptions();
  }

  void _initializePlayerSubscriptions() {
    _durationSubscription = player.onDurationChanged.listen((newDuration) {
      _totalDuration = newDuration;
    });

    _positionSubscription = player.onPositionChanged.listen((newPosition) {
      _currentDuration = newPosition;
    });

    // player.onPlayerComplete.listen((_) {
    //   if (_toggleReplay) {
    //     replay();
    //   } else if (_toggleShuffle) {
    //     shuffle();
    //   } else {
    //     onSongCompleted();
    //   }
    // });
  }

  Future<void> dispose() async {
    await player.dispose();
    _durationSubscription.cancel();
    _positionSubscription.cancel();
  }

  void play(int index) async {
    final newSong = _songList[index];
    await player.stop();
    await player.play(AssetSource(newSong.audioPath));
  }

  void pause() async {
    await player.pause();
  }

  void resume() async {
    await player.resume();
  }

  void next(int index) {
    // _currentIndex = (_currentIndex + 1) % _songList.length;
    index = index + 1;
    play(index);
  }

  void previous(int index) {
    // _currentIndex = (_currentIndex - 1) % _songList.length;
    // if (_currentIndex < 0) {
    //   _currentIndex = _songList.length - 1;
    // }

    if (index <= 0) {
      index = 0;
    } else {
      index = index - 1;
    }
    play(index);
  }

  void replay(int index) {
    play(index);
  }

  void shuffle() {
    int index = Random().nextInt(_songList.length);
    play(index);
  }

  void onSliderChange(Duration position) async {
    await player.seek(position);
  }

  // void onSongCompleted() {
  //   next(index);
  // }

  // void setToggleReplay() {
  //   _toggleReplay = !_toggleReplay;
  // }

  // void setToggleShuffle() {
  //   _toggleShuffle = !_toggleShuffle;
  // }

  Duration get currentDuration => _currentDuration;

  Duration get songDuration => _totalDuration;
}
