import 'package:muiziq_app/db/db_functions/db_functions.dart';
import 'package:muiziq_app/Model/music_model.dart';

indexFinder(MusicModel data) {
  List<MusicModel> list = musicNotifier.value;
  return list.indexOf(data);
}
