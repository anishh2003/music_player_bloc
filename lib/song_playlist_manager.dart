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

  void play() async {
    final newSong = _songList[_currentIndex];
    await player.stop();
    await player.play(AssetSource(newSong.audioPath));
  }

  Future<void> pause() async {
    await player.pause();
  }

  Future<void> resume() async {
    await player.resume();
  }

  void next() {
    if (_currentIndex >= _songList.length - 1) {
      _currentIndex = 0;
    } else {
      _currentIndex = _currentIndex + 1;
    }
    play();
  }

  void previous() {
    if (_currentIndex <= 0) {
      _currentIndex = 0;
    } else {
      _currentIndex = _currentIndex - 1;
    }
    play();
  }

  void replay() {
    play();
  }

  void shuffle() {
    _currentIndex = Random().nextInt(_songList.length - 1);
    play();
  }

  void onSliderChange(Duration position) async {
    await player.seek(position);
  }

  set currentIndex(int index) {
    _currentIndex = index;
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

  int get currentIndex => _currentIndex;
}
