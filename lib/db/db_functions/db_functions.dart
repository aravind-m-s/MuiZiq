import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:muiziq_app/db/db_model/music_model.dart';
import 'package:muiziq_app/db/db_model/playlist_model/playlist_model.dart';

ValueNotifier<List<MusicModel>> musicNotifier = ValueNotifier([]);

getAllMusic() async {
  final musicDb = await Hive.openBox<MusicModel>('musics');
  musicNotifier.value.clear();
  musicNotifier.value.addAll(musicDb.values);
  musicNotifier.notifyListeners();
}

favOption(index) async {
  final musicDb = await Hive.openBox<MusicModel>('musics');
  final value = musicDb.values.elementAt(index);
  value.isFav = !value.isFav;
  musicDb.putAt(index, value);
  getAllMusic();
}

addPlaylist(value) async {
  final playlistDB = await Hive.openBox<PlaylistModel>('playlists');
  playlistDB.add(value);
  log(playlistDB.values.toString());
}

updatePlaylist(int index, String name) async {
  final playlistDB = await Hive.openBox<PlaylistModel>('playlists');
  final value = playlistDB.values.elementAt(index);
  value.name = name;
  playlistDB.putAt(index, value);
}
