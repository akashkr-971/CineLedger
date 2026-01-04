import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/movie_local_repository.dart';
import 'models/movie_local.dart';

final watchlistProvider = FutureProvider<List<MovieLocal>>((ref) async {
  final repo = MovieLocalRepository();
  return repo.getWatchlistMovies();
});
