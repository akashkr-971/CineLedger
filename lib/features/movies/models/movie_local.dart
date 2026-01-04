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

  @HiveField(7)
  final bool inWatchlist;

  MovieLocal({
    required this.tmdbId,
    required this.title,
    required this.posterPath,
    this.releaseYear,
    required this.rating,
    required this.note,
    bool? watched,
    bool? inWatchlist,
  }) : watched = watched ?? false,
       inWatchlist = inWatchlist ?? false;

  /// 🔁 TMDB → Local
  factory MovieLocal.fromTmdb(Map<String, dynamic> movie) {
    final releaseDate = movie['release_date'] ?? '';
    final year =
        releaseDate.isNotEmpty
            ? int.tryParse(releaseDate.split('-').first)
            : null;

    return MovieLocal(
      tmdbId: movie['id'],
      title: movie['title'] ?? '',
      posterPath: movie['poster_path'] ?? '',
      releaseYear: year,
      rating: 0,
      note: '',
      watched: false,
      inWatchlist: true,
    );
  }

  /// 🧠 copyWith (NOW this works)
  MovieLocal copyWith({
    bool? watched,
    bool? inWatchlist,
    double? rating,
    String? note,
  }) {
    return MovieLocal(
      tmdbId: tmdbId,
      title: title,
      posterPath: posterPath,
      releaseYear: releaseYear,
      rating: rating ?? this.rating,
      note: note ?? this.note,
      watched: watched ?? this.watched,
      inWatchlist: inWatchlist ?? this.inWatchlist,
    );
  }
}
