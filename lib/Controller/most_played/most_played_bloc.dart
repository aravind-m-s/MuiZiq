import 'package:bloc/bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:meta/meta.dart';
import 'package:muiziq_app/Model/music_model.dart';
import 'package:muiziq_app/Model/recent_model/recent_model.dart';

part 'most_played_event.dart';
part 'most_played_state.dart';

class MostPlayedBloc extends Bloc<MostPlayedEvent, MostPlayedState> {
  MostPlayedBloc() : super(MostPlayedInitial()) {
    on<GetAllMostPlayed>((event, emit) async {
      final db = await Hive.openBox<RecentModel>('recent');
      final recentDbValue = db.values.where((element) => element.count > 5);

      final musicdb = await Hive.openBox<MusicModel>('musics');
      List<MusicModel> mostPlayed = [];
      for (int i = recentDbValue.length - 1; i >= 0; i--) {
        for (int j = 0; j < musicdb.values.length; j++) {
          if (recentDbValue.elementAt(i).songIds ==
              musicdb.values.elementAt(j).id) {
            mostPlayed.add(musicdb.values.elementAt(j));
          }
        }
      }
      emit(MostPlayedState(mostPlayed: mostPlayed));
    });
  }
}
