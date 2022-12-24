import 'package:bloc/bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:meta/meta.dart';
import 'package:muiziq_app/Model/music_model.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(SearchInitial()) {
    on<SearchQuery>((event, emit) async {
      final musicDb = await Hive.openBox<MusicModel>('musics');
      final result = musicDb.values
          .where(
            (element) => element.name!
                .toLowerCase()
                .contains(event.query.toLowerCase().trim()),
          )
          .toList();
      emit(SearchState(result: result));
    });
  }
}
