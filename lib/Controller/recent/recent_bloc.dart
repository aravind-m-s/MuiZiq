import 'package:bloc/bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:meta/meta.dart';
import 'package:muiziq_app/Model/music_model.dart';
import 'package:muiziq_app/Model/recent_model/recent_model.dart';

part 'recent_event.dart';
part 'recent_state.dart';

class RecentBloc extends Bloc<RecentEvent, RecentState> {
  RecentBloc() : super(const RecentInitial()) {
    on<GetAllRecent>((event, emit) async {
      final db = await Hive.openBox<RecentModel>('recent');
      final musicdb = await Hive.openBox<MusicModel>('musics');
      final List<MusicModel> recents = [];
      for (int i = db.values.length - 1; i >= 0; i--) {
        for (int j = 0; j < musicdb.values.length; j++) {
          if (db.values.elementAt(i).songIds ==
              musicdb.values.elementAt(j).id) {
            recents.add(musicdb.values.elementAt(j));
          }
        }
      }
      emit(RecentState(recents: recents));
    });
  }
}
