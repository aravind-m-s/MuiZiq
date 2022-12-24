part of 'playlist_bloc.dart';

@immutable
abstract class PlaylistEvent {}

class GetAllPlaylist extends PlaylistEvent {}

class GetPlaylistData extends PlaylistEvent {
  final int index;
  GetPlaylistData({required this.index});
}

class EditPlaylistName extends PlaylistEvent {
  final int index;
  final String name;
  EditPlaylistName({required this.index, required this.name});
}

class DeletePlaylist extends PlaylistEvent {
  final int index;
  DeletePlaylist({required this.index});
}

class DeletePlaylsitData extends PlaylistEvent {
  final int id;
  final int playlistIndex;
  DeletePlaylsitData({required this.id, required this.playlistIndex});
}

class AddPlaylist extends PlaylistEvent {
  final PlaylistModel playlist;
  AddPlaylist({required this.playlist});
}

class AddSongToPlaylist extends PlaylistEvent {
  final int id;
  final int playlistId;
  AddSongToPlaylist({required this.id, required this.playlistId});
}
