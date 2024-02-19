part of 'song_playlist_bloc.dart';

@immutable
sealed class SongPlaylistState {
  List<Song> songList = [];

  SongPlaylistState(this.songList);
}

final class SongPlaylistInitial extends SongPlaylistState {
  SongPlaylistInitial(super.songList);
}
