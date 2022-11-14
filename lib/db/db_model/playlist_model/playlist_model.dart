import 'package:hive_flutter/adapters.dart';
part 'playlist_model.g.dart';

@HiveType(typeId: 1)
class PlaylistModel extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  List<int> songIds;

  PlaylistModel({required this.name, required this.songIds});

  deleteData(int id) {
    songIds.removeWhere((element) => element == id);
    save();
  }

  addData(int id) {
    songIds.add(id);
    save();
  }
}
