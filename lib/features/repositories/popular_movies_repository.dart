import '../movies/models/movie_local.dart';
import '../movies/models/popular_movies_cache.dart';
import 'movie_local_repository.dart';
import '../movies/movie_search_service.dart';

class PopularMoviesRepository {
  final _localRepo = MovieLocalRepository();
  final _movieService = MovieSearchService();

  Future<List<MovieLocal>> getPopularOncePerDay() async {
    final cache = await _localRepo.getPopularCache();

    if (cache != null) {
      final hoursSince = DateTime.now().difference(cache.lastFetched).inHours;

      if (hoursSince < 24) {
        return cache.movies;
      }
    }

    final results = await _movieService.getPopularMovies();

    final movies = results.map((e) => MovieLocal.fromTmdb(e)).toList();

    await _localRepo.savePopularCache(
      PopularMoviesCache(lastFetched: DateTime.now(), movies: movies),
    );

    return movies;
  }
}
