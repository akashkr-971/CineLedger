import 'package:hive/hive.dart';

part 'movie_local.g.dart';

@HiveType(typeId: 1)
class MovieLocal {
  @HiveField(0)
  final int tmdbId;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String posterPath;

  @HiveField(3)
  final int? releaseYear;

  @HiveField(4)
  final double rating;

  @HiveField(5)
  final String note;

  @HiveField(6)
  final bool watched;

  MovieLocal({
    required this.tmdbId,
    required this.title,
    required this.posterPath,
    this.releaseYear,
    required this.rating,
    required this.note,
    required this.watched,
  });
}
