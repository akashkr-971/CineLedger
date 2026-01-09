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

  @HiveField(8)
  final DateTime? watchedAt;

  // 🆕 SAFE ADDITIONS
  @HiveField(9)
  final List<int> genres;

  @HiveField(10)
  final String overview;

  @HiveField(11)
  final double voteAverage;

  @HiveField(12)
  final int voteCount;

  @HiveField(13)
  final String backdropPath;

  MovieLocal({
    required this.tmdbId,
    required this.title,
    required this.posterPath,
    this.releaseYear,
    required this.rating,
    required this.note,
    this.watchedAt,
    this.genres = const [],
    this.overview = '',
    this.voteAverage = 0.0,
    this.voteCount = 0,
    this.backdropPath = '',
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
      genres: List<int>.from(movie['genre_ids'] ?? []),
      overview: movie['overview'] ?? '',
      voteAverage: (movie['vote_average'] ?? 0).toDouble(),
      voteCount: movie['vote_count'] ?? 0,
      backdropPath: movie['backdrop_path'] ?? '',
      rating: 0,
      note: '',
      watched: false,
      inWatchlist: true,
      watchedAt: null,
    );
  }

  /// 🧠 copyWith (FULLY FIXED)
  MovieLocal copyWith({
    bool? watched,
    bool? inWatchlist,
    double? rating,
    String? note,
    DateTime? watchedAt,
    List<int>? genres,
    String? overview,
    double? voteAverage,
    int? voteCount,
    String? backdropPath,
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
      watchedAt: watchedAt ?? this.watchedAt,
      genres: genres ?? this.genres,
      overview: overview ?? this.overview,
      voteAverage: voteAverage ?? this.voteAverage,
      voteCount: voteCount ?? this.voteCount,
      backdropPath: backdropPath ?? this.backdropPath,
    );
  }
}
