import 'package:hive/hive.dart';
import '../movies/models/movie_local.dart';

class MovieLocalRepository {
  static const _boxName = 'movies';

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

  Future<bool> isEmpty() async {
    final box = await _openBox();
    return box.isEmpty;
  }
}
