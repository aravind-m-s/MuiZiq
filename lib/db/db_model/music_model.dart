import 'package:hive_flutter/adapters.dart';
part 'music_model.g.dart';

@HiveType(typeId: 0)
class MusicModel {
  @HiveField(0)
  final id;

  @HiveField(1)
  final uri;

  @HiveField(2)
  final artist;

  @HiveField(3)
  final name;

  @HiveField(4)
  final title;

  @HiveField(5)
  final album;

  @HiveField(6)
  final artistID;

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
