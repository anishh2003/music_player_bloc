part of 'song_playlist_bloc.dart';

@immutable
sealed class SongPlaylistEvent {}

final class PlayTrack extends SongPlaylistEvent {
  final Song song;

  PlayTrack({required this.song});
}

final class PauseTrack extends SongPlaylistEvent {
  final Song song;

  PauseTrack({required this.song});
}

final class PreviousTrack extends SongPlaylistEvent {
  final Song song;

  PreviousTrack({required this.song});
}

final class NextTrack extends SongPlaylistEvent {
  final Song song;

  NextTrack({required this.song});
}

final class ShuffleTracks extends SongPlaylistEvent {
  final Song song;

  ShuffleTracks({required this.song});
}

final class ReplayTrack extends SongPlaylistEvent {
  final Song song;

  ReplayTrack({required this.song});
}
