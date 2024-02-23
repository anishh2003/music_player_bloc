part of 'song_playlist_bloc.dart';

@immutable
sealed class SongPlaylistEvent {}

final class PlayTrack extends SongPlaylistEvent {
  final int selectedIndex;

  PlayTrack(this.selectedIndex);
}

final class PauseTrack extends SongPlaylistEvent {}

final class ResumeTrack extends SongPlaylistEvent {}

final class PreviousTrack extends SongPlaylistEvent {
  PreviousTrack();
}

final class NextTrack extends SongPlaylistEvent {
  NextTrack();
}

final class SongCompleted extends SongPlaylistEvent {}

final class ShuffleTracks extends SongPlaylistEvent {}

final class ReplayTrack extends SongPlaylistEvent {}

final class ReplayShuffleToggle extends SongPlaylistEvent {}

final class SliderChange extends SongPlaylistEvent {
  final Duration sliderValueDuration;

  SliderChange({required this.sliderValueDuration});
}

final class UpdateTotalDuration extends SongPlaylistEvent {
  final Duration newDuration;

  UpdateTotalDuration({required this.newDuration});
}

final class UpdateCurrentDuration extends SongPlaylistEvent {
  final Duration newPosition;

  UpdateCurrentDuration({required this.newPosition});
}
