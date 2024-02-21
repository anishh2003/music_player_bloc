part of 'song_playlist_bloc.dart';

@immutable
sealed class SongPlaylistState {
  final List<Song> songList;

  const SongPlaylistState(this.songList);
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
  SongPlaylistError({required this.error}) : super(songList);
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
