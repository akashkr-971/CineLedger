import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'movie_search_service.dart';

final popularMoviesProvider = FutureProvider<List<Map<String, dynamic>>>((
  ref,
) async {
  final service = MovieSearchService();
  return service.getPopularMovies();
});
