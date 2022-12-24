import 'package:bloc/bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:meta/meta.dart';
import 'package:muiziq_app/Model/music_model.dart';
import 'package:muiziq_app/constants/constants.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<GetAllMusic>((event, emit) async {
      bool filter = false;
      final musicDb = await Hive.openBox<MusicModel>('musics');
      final audioQuery = OnAudioQuery();
      final songs = await audioQuery.querySongs(
        sortType: null,
        orderType: OrderType.ASC_OR_SMALLER,
        uriType: UriType.EXTERNAL,
        ignoreCase: true,
      );
      if (musicDb.values.length < songs.length) {
        musicDb.deleteAll(musicDb.keys);
        for (int i = 0; i < songs.length; i++) {
          final value = MusicModel(
            id: songs[i].id,
            uri: songs[i].uri,
            artist: songs[i].artist,
            name: songs[i].displayNameWOExt,
            title: songs[i].title,
            album: songs[i].album,
            artistID: songs[i].artistId,
            isFav: false,
          );
          musicDb.add(value);
        }
      }
      final prefs = await SharedPreferences.getInstance();
      if (prefs.getBool('filter') != null) {
        filter = prefs.getBool('filter')!;
      }
      List<MusicModel> db = [];
      db.addAll(musicDb.values);
      final List<MusicModel> list = [];
      if (filter) {
        final temp =
            db.where((element) => element.album != "WhatsApp Audio").toList();
        list.addAll(temp);
      } else {
        list.addAll(musicDb.values);
      }
      audio = list;
      emit(HomeState(musics: list));
    });
  }
}
