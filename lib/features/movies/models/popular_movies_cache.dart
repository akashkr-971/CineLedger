import 'package:hive/hive.dart';
import 'movie_local.dart';

part 'popular_movies_cache.g.dart';

@HiveType(typeId: 11)
class PopularMoviesCache {
  @HiveField(0)
  final DateTime lastFetched;

  @HiveField(1)
  final List<MovieLocal> movies;

  PopularMoviesCache({required this.lastFetched, required this.movies});
}
