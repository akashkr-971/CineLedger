import 'package:hive/hive.dart';
import '../movies/models/movie_local.dart';
import '../movies/models/popular_movies_cache.dart';

class MovieLocalRepository {
  static const _boxName = 'movies';
  static const _popularBox = 'popular_movies';

  Future<Box<MovieLocal>> _openBox() async {
    if (!Hive.isBoxOpen(_boxName)) {
      return await Hive.openBox<MovieLocal>(_boxName);
    }
    return Hive.box<MovieLocal>(_boxName);
  }

  Future<List<MovieLocal>> getAllMovies() async {
    final box = await _openBox();
    return box.values.toList();
  }

  Future<void> saveMovie(MovieLocal movie) async {
    final box = await _openBox();
    await box.put(movie.tmdbId, movie);
  }

  Future<void> saveMovies(List<MovieLocal> movies) async {
    final box = await _openBox();
    for (final movie in movies) {
      await box.put(movie.tmdbId, movie);
    }
  }

  Future<PopularMoviesCache?> getPopularCache() async {
    final box = await Hive.openBox<PopularMoviesCache>(_popularBox);
    return box.get('cache');
  }

  Future<void> savePopularCache(PopularMoviesCache cache) async {
    final box = await Hive.openBox<PopularMoviesCache>(_popularBox);
    await box.put('cache', cache);
  }

  Future<bool> isEmpty() async {
    final box = await _openBox();
    return box.isEmpty;
  }

  Future<List<MovieLocal>> getWatchedMovies() async {
    final box = await _openBox();
    return box.values.where((m) => m.watched).toList();
  }

  Future<List<MovieLocal>> getWatchlistMovies() async {
    final box = await _openBox();
    return box.values.where((m) => m.inWatchlist).toList();
  }

  Future<void> updateMovie(MovieLocal movie) async {
    final box = await _openBox();
    await box.put(movie.tmdbId, movie);
  }

  Future<void> deleteMovie(int tmdbId) async {
    final box = await _openBox();
    await box.delete(tmdbId);
  }
}
