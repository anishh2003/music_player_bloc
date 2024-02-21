part of 'song_playlist_bloc.dart';

@immutable
sealed class SongPlaylistEvent {}

final class PlayTrack extends SongPlaylistEvent {}

final class PauseTrack extends SongPlaylistEvent {}

final class ResumeTrack extends SongPlaylistEvent {}

final class PreviousTrack extends SongPlaylistEvent {}

final class NextTrack extends SongPlaylistEvent {}

final class ShuffleTracks extends SongPlaylistEvent {
  final Song song;

  ShuffleTracks({required this.song});
}

final class ReplayTrack extends SongPlaylistEvent {
  final Song song;

  ReplayTrack({required this.song});
}
