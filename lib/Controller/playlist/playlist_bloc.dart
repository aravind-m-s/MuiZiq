import 'package:bloc/bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:meta/meta.dart';
import 'package:muiziq_app/Model/music_model.dart';
import 'package:muiziq_app/Model/playlist_model/playlist_model.dart';

part 'playlist_event.dart';
part 'playlist_state.dart';

class PlaylistBloc extends Bloc<PlaylistEvent, PlaylistState> {
  PlaylistBloc() : super(PlaylistInitial()) {
    on<GetAllPlaylist>((event, emit) async {
      final db = await Hive.openBox<PlaylistModel>('playlists');
      emit(
        PlaylistState(
          playlists: db.values.toList(),
          playlistData: state.playlistData,
        ),
      );
    });

    on<DeletePlaylist>((event, emit) async {
      final db = await Hive.openBox<PlaylistModel>('playlists');
      db.deleteAt(event.index);
      emit(PlaylistState(
          playlists: db.values.toList(), playlistData: state.playlistData));
    });

    on<GetPlaylistData>((event, emit) async {
      final playlistDb = await Hive.openBox<PlaylistModel>('playlists');
      final playlist = playlistDb.values.elementAt(event.index);
      final allPlaylistSongs = await convertPlaylistIds(playlist);
      emit(PlaylistState(
          playlistData: allPlaylistSongs, playlists: state.playlists));
    });

    on<AddPlaylist>((event, emit) async {
      final db = await Hive.openBox<PlaylistModel>('playlists');
      db.add(event.playlist);
      emit(PlaylistState(
          playlists: db.values.toList(), playlistData: state.playlistData));
    });

    on<DeletePlaylsitData>((event, emit) async {
      final db = await Hive.openBox<PlaylistModel>('playlists');
      final playlist = db.values.elementAt(event.playlistIndex);
      playlist.songIds.remove(event.id);
      db.putAt(event.playlistIndex, playlist);
      final allPlaylistSongs = await convertPlaylistIds(playlist);

      emit(PlaylistState(
          playlistData: allPlaylistSongs, playlists: state.playlists));
    });

    on<AddSongToPlaylist>((event, emit) async {
      final db = await Hive.openBox<PlaylistModel>('playlists');
      final playlist = db.values.elementAt(event.playlistId);
      if (playlist.songIds.contains(event.id)) {
        return;
      }
      playlist.songIds.add(event.id);
      db.putAt(event.playlistId, playlist);

      final allPlaylistSongs = await convertPlaylistIds(playlist);
      emit(PlaylistState(
          playlistData: allPlaylistSongs, playlists: state.playlists));
    });

    on<EditPlaylistName>((event, emit) async {
      final db = await Hive.openBox<PlaylistModel>('playlists');
      final playlist = db.values.elementAt(event.index);
      playlist.name = event.name;
      db.putAt(event.index, playlist);
      final allPlaylistSongs = await convertPlaylistIds(playlist);

      emit(PlaylistState(
          playlistData: allPlaylistSongs,
          playlists: state.playlists,
          playlistName: event.name));
    });
  }
}

convertPlaylistIds(PlaylistModel playlist) async {
  final musicDb = await Hive.openBox<MusicModel>('musics');

  List<MusicModel> allPlaylistSongs = [];
  for (int i = 0; i < playlist.songIds.length; i++) {
    for (int j = 0; j < musicDb.values.length; j++) {
      if (playlist.songIds[i] == musicDb.values.elementAt(j).id) {
        allPlaylistSongs.add(musicDb.values.elementAt(j));
      }
    }
  }
  return allPlaylistSongs;
}
