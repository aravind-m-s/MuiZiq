part of 'playlist_bloc.dart';

class PlaylistState {
  final List<PlaylistModel> playlists;
  final List<MusicModel> playlistData;
  String? playlistName;
  PlaylistState({
    this.playlists = const [],
    this.playlistData = const [],
    this.playlistName = '',
  });
}

class PlaylistInitial extends PlaylistState {
  PlaylistInitial() : super(playlists: []);
}
