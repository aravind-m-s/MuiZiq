import 'package:bloc/bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:meta/meta.dart';
import 'package:muiziq_app/Model/music_model.dart';

part 'favorite_event.dart';
part 'favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  FavoriteBloc() : super(FavoriteInitial()) {
    on<GetAllFavorites>((event, emit) async {
      final musicDb = await Hive.openBox<MusicModel>('musics');
      final List<MusicModel> list =
          musicDb.values.where((element) => element.isFav).toList();
      emit(FavoriteState(favorites: list));
    });

    on<FavoriteAddRemove>((event, emit) async {
      final musicDb = await Hive.openBox<MusicModel>('musics');
      final music = musicDb.values
          .where((element) => element.id == event.id)
          .toList()
          .first;
      if (music.isFav) {
        music.isFav = false;
      } else {
        music.isFav = true;
      }
      final int position = musicDb.values.toList().indexOf(music);
      musicDb.putAt(position, music);
      emit(FavoriteState(
          favorites: musicDb.values
              .where((element) => element.isFav == true)
              .toList()));
    });
  }
}
