// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'music_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MusicModelAdapter extends TypeAdapter<MusicModel> {
  @override
  final int typeId = 0;

  @override
  MusicModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MusicModel(
      id: fields[0] as int,
      uri: fields[1] as String?,
      artist: fields[2] as String?,
      name: fields[3] as String?,
      title: fields[4] as String?,
      album: fields[5] as String?,
      artistID: fields[6] as int?,
      isFav: fields[7] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, MusicModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.uri)
      ..writeByte(2)
      ..write(obj.artist)
      ..writeByte(3)
      ..write(obj.name)
      ..writeByte(4)
      ..write(obj.title)
      ..writeByte(5)
      ..write(obj.album)
      ..writeByte(6)
      ..write(obj.artistID)
      ..writeByte(7)
      ..write(obj.isFav);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MusicModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
