import 'package:hive_flutter/adapters.dart';
part 'playlist_model.g.dart';

@HiveType(typeId: 1)
class PlaylistModel {
  @HiveField(0)
  String name;

  @HiveField(1)
  List<int> songIds;

  PlaylistModel({required this.name, required this.songIds});
}
