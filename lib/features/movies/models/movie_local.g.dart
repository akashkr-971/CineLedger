// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_local.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MovieLocalAdapter extends TypeAdapter<MovieLocal> {
  @override
  final int typeId = 1;

  @override
  MovieLocal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MovieLocal(
      tmdbId: fields[0] as int,
      title: fields[1] as String,
      posterPath: fields[2] as String,
      releaseYear: fields[3] as int?,
      rating: fields[4] as double,
      note: fields[5] as String,
      watchedAt: fields[8] as DateTime?,
      genres: (fields[9] as List).cast<int>(),
      overview: fields[10] as String,
      voteAverage: fields[11] as double,
      voteCount: fields[12] as int,
      backdropPath: fields[13] as String,
      watched: fields[6] as bool?,
      inWatchlist: fields[7] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, MovieLocal obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.tmdbId)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.posterPath)
      ..writeByte(3)
      ..write(obj.releaseYear)
      ..writeByte(4)
      ..write(obj.rating)
      ..writeByte(5)
      ..write(obj.note)
      ..writeByte(6)
      ..write(obj.watched)
      ..writeByte(7)
      ..write(obj.inWatchlist)
      ..writeByte(8)
      ..write(obj.watchedAt)
      ..writeByte(9)
      ..write(obj.genres)
      ..writeByte(10)
      ..write(obj.overview)
      ..writeByte(11)
      ..write(obj.voteAverage)
      ..writeByte(12)
      ..write(obj.voteCount)
      ..writeByte(13)
      ..write(obj.backdropPath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MovieLocalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
