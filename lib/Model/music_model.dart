import 'package:hive_flutter/adapters.dart';
part 'music_model.g.dart';

@HiveType(typeId: 0)
class MusicModel {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String? uri;

  @HiveField(2)
  final String? artist;

  @HiveField(3)
  final String? name;

  @HiveField(4)
  final String? title;

  @HiveField(5)
  final String? album;

  @HiveField(6)
  final int? artistID;

  @HiveField(7)
  bool isFav;

  MusicModel(
      {required this.id,
      required this.uri,
      required this.artist,
      required this.name,
      required this.title,
      required this.album,
      required this.artistID,
      required this.isFav});
}
