import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/movie_repository.dart';
import '../repositories/movie_local_repository.dart';
import 'models/movie_local.dart';

final movieListProvider = FutureProvider<List<MovieLocal>>((ref) async {
  final localRepo = MovieLocalRepository();
  final remoteRepo = MovieRepository();

  final localMovies = await localRepo.getAllMovies();

  if (localMovies.isNotEmpty) {
    return localMovies;
  }

  await remoteRepo.syncFromFirestoreToLocal();

  return await localRepo.getAllMovies();
});
