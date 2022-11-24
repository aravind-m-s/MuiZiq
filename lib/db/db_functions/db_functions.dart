// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:muiziq_app/db/db_model/music_model.dart';
import 'package:muiziq_app/db/db_model/playlist_model/playlist_model.dart';
import 'package:muiziq_app/db/db_model/recent_model/recent_model.dart';
import 'package:muiziq_app/screens/widgets/snacbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

ValueNotifier<List<MusicModel>> musicNotifier = ValueNotifier([]);
ValueNotifier<List<PlaylistModel>> playlistNotifier = ValueNotifier([]);
ValueNotifier<List<RecentModel>> recentNotifier = ValueNotifier([]);

getAllMusic() async {
  bool filter = false;
  final musicDb = await Hive.openBox<MusicModel>('musics');
  final prefs = await SharedPreferences.getInstance();
  musicNotifier.value.clear();
  if (prefs.getBool('filter') != null) {
    filter = prefs.getBool('filter')!;
  }
  List<MusicModel> db = [];
  db.addAll(musicDb.values);
  if (filter) {
    final temp =
        db.where((element) => element.album != "WhatsApp Audio").toList();
    musicNotifier.value.addAll(temp);
  } else {
    musicNotifier.value.addAll(musicDb.values);
  }
  musicNotifier.notifyListeners();
}

favOption(index, context) async {
  final musicDb = await Hive.openBox<MusicModel>('musics');
  List list = [];
  list.addAll(musicDb.values);
  final value =
      musicDb.values.where((element) => element.id == index).toList()[0];
  value.isFav = !value.isFav;
  value.isFav
      ? snacbarWidget(context, 'Song added to favorites')
      : warningSncakbar(context, 'Song removed from favorites');
  final int pos = list.indexOf(value);
  musicDb.putAt(pos, value);
  getAllMusic();
}

addPlaylist(PlaylistModel value, BuildContext context) async {
  snacbarWidget(context, 'Playlist added succefully');
  final playlistDB = await Hive.openBox<PlaylistModel>('playlists');
  playlistDB.add(value);
}

updatePlaylist(int index, String name, BuildContext context) async {
  snacbarWidget(context, 'Playlist Edited succefully');
  final playlistDB = await Hive.openBox<PlaylistModel>('playlists');
  final value = playlistDB.values.elementAt(index);
  value.name = name;
  playlistDB.putAt(index, value);
  playlistDB.close();
}

deletePlaylist(int index, BuildContext context) async {
  snacbarWidget(context, 'Playlist removed succefully');

  final playlistDB = await Hive.openBox<PlaylistModel>('playlists');
  playlistDB.deleteAt(index);
  playlistDB.close();
}

addToRecent(int value) async {
  final recentDB = await Hive.openBox<RecentModel>('recent');
  List<RecentModel> db = [];
  db.addAll(recentDB.values);
  if (recentDB.isNotEmpty) {
    var ele =
        recentDB.values.where((element) => element.songIds == value).toList();
    if (ele.isEmpty) {
      final val = RecentModel(songIds: value, count: 0);
      recentDB.add(val);
    } else {
      final list = db.where((element) => element.songIds != value).toList();
      int count = ele[0].count + 1;

      final val = RecentModel(songIds: value, count: count);
      list.add(val);

      recentDB.deleteAll(recentDB.keys);
      recentDB.addAll(list);
    }
  } else {
    final val = RecentModel(songIds: value, count: 0);
    recentDB.add(val);
  }
}

addAllRecent() async {
  final recentDB = await Hive.openBox<RecentModel>('recent');
  recentNotifier.value.clear();
  recentNotifier.value.addAll(recentDB.values);
  recentNotifier.notifyListeners();
  recentDB.close();
}
