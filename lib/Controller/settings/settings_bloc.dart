import 'package:bloc/bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:muiziq_app/Model/music_model.dart';
import 'package:muiziq_app/Model/playlist_model/playlist_model.dart';
import 'package:muiziq_app/Model/recent_model/recent_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(SettingsInitial()) {
    on<WhatsAppFilter>((event, emit) async {
      final prefs = await SharedPreferences.getInstance();
      bool? status = prefs.getBool('filter');
      if (status == false) {
        status = true;
      } else {
        status = false;
      }
      prefs.setBool('filter', status);
      emit(SettingsState(status: status, version: state.version));
    });
    on<WhatsAppFilterInitial>((event, emit) async {
      final prefs = await SharedPreferences.getInstance();
      bool? status = prefs.getBool('filter');
      status ??= false;
      emit(SettingsState(status: status, version: state.version));
    });

    on<ResetApplication>((event, emit) async {
      final musicDB = await Hive.openBox<MusicModel>('musics');
      final playlistDB = await Hive.openBox<PlaylistModel>('playlists');
      final recentDB = await Hive.openBox<RecentModel>('recent');
      musicDB.deleteAll(musicDB.keys);
      playlistDB.deleteAll(playlistDB.keys);
      recentDB.deleteAll(recentDB.keys);
    });
  }
}
