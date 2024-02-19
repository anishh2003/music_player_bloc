import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'song_playlist_event.dart';
part 'song_playlist_state.dart';

class SongPlaylistBloc extends Bloc<SongPlaylistEvent, SongPlaylistState> {
  SongPlaylistBloc() : super(SongPlaylistInitial()) {
    on<SongPlaylistEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
