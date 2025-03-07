part of 'song_playlist_bloc.dart';

@immutable
sealed class SongPlaylistState extends Equatable {
  final List<Song> songList;

  const SongPlaylistState(this.songList);

  @override
  List<Object?> get props => [songList];
}

final class SongPlaylistInitial extends SongPlaylistState {
  const SongPlaylistInitial(super.songList);
}

final class SongPlaylistLoading extends SongPlaylistState {
  const SongPlaylistLoading(super.songList);
}

final class SongPlaylistLoaded extends SongPlaylistState {
  const SongPlaylistLoaded(super.songList);
}

final class SongPlaylistError extends SongPlaylistState {
  final String error;

  const SongPlaylistError({required this.error, required List<Song> songList})
      : super(songList);

  @override
  List<Object?> get props => [error, songList];
}

final class FetchingSong extends SongPlaylistState {
  FetchingSong() : super(songList);
}

final class SongisPlaying extends SongPlaylistState {
  SongisPlaying() : super(songList);
}

final class SongIsPaused extends SongPlaylistState {
  SongIsPaused() : super(songList);
}

final class SongResumed extends SongPlaylistState {
  SongResumed() : super(songList);
}

final class SongSeek extends SongPlaylistState {
  SongSeek() : super(songList);
}

final class SongReplay extends SongPlaylistState {
  SongReplay() : super(songList);
}

final class SongShuffle extends SongPlaylistState {
  SongShuffle() : super(songList);
}

final class SongDurationUpdated extends SongPlaylistState {
  final Duration newDuration;
  const SongDurationUpdated(
      {required this.newDuration, required List<Song> songList})
      : super(songList);

  @override
  List<Object?> get props => [newDuration, songList];
}

final class SongPositionUpdated extends SongPlaylistState {
  final Duration newPosition;
  const SongPositionUpdated(
      {required this.newPosition, required List<Song> songList})
      : super(songList);

  @override
  List<Object?> get props => [newPosition, songList];
}
