import 'package:hive_flutter/adapters.dart';

part 'recent_model.g.dart';

@HiveType(typeId: 2)
class RecentModel extends HiveObject {
  @HiveField(0)
  final int songIds;

  @HiveField(1)
  final int count;
  RecentModel({required this.songIds, required this.count});
}
