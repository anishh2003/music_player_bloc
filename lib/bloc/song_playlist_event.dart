part of 'song_playlist_bloc.dart';

@immutable
sealed class SongPlaylistEvent {}

final class PreviousTrack extends SongPlaylistEvent {}

final class PlayTrack extends SongPlaylistEvent {}

final class NextTrack extends SongPlaylistEvent {}

final class ShuffleTracks extends SongPlaylistEvent {}

final class ReplayTrack extends SongPlaylistEvent {}
