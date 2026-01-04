// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'popular_movies_cache.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PopularMoviesCacheAdapter extends TypeAdapter<PopularMoviesCache> {
  @override
  final int typeId = 11;

  @override
  PopularMoviesCache read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PopularMoviesCache(
      lastFetched: fields[0] as DateTime,
      movies: (fields[1] as List).cast<MovieLocal>(),
    );
  }

  @override
  void write(BinaryWriter writer, PopularMoviesCache obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.lastFetched)
      ..writeByte(1)
      ..write(obj.movies);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PopularMoviesCacheAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
