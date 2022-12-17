import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:muiziq_app/View/widgets/snacbar.dart';
part 'playlist_model.g.dart';

@HiveType(typeId: 1)
class PlaylistModel extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  List<int> songIds;

  PlaylistModel({required this.name, required this.songIds});

  deleteData(int id, BuildContext context) {
    songIds.removeWhere((element) => element == id);
    warningSncakbar(context, 'Playlist deleted succefully');
    save();
  }

  addData(int id, BuildContext context) {
    if (!songIds.contains(id)) {
      songIds.add(id);
      snacbarWidget(context, 'Song added to playlist');
    } else {
      warningSncakbar(context, 'Song already in playlist');
    }
    save();
  }
}
