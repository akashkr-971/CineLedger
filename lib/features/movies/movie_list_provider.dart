import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/movie_repository.dart';
import '../repositories/movie_local_repository.dart';
import 'models/movie_local.dart';
import '../auth/auth_providers.dart';

final movieRefreshTriggerProvider = StateProvider<int>((ref) => 0);

final movieListProvider = FutureProvider<List<MovieLocal>>((ref) async {
  ref.watch(movieRefreshTriggerProvider);
  final user = ref.watch(authStateProvider).value;

  if (user == null) {
    return [];
  }
  final localRepo = MovieLocalRepository();
  final remoteRepo = MovieRepository();

  final localMovies = await localRepo.getAllMovies();

  if (localMovies.isNotEmpty) {
    return localMovies;
  }

  await remoteRepo.syncFromFirestoreToLocal();
  return await localRepo.getAllMovies();
});
