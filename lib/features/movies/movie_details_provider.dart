import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'models/movie_local.dart';
import 'movie_search_service.dart';

final movieDetailsProvider = FutureProvider.family<MovieLocal?, int>((
  ref,
  tmdbId,
) async {
  final user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    final doc =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('movies')
            .doc(tmdbId.toString())
            .get();

    if (doc.exists) {
      final data = doc.data()!;
      return MovieLocal(
        tmdbId: data['tmdbId'],
        title: data['title'],
        posterPath: data['posterPath'] ?? '',
        releaseYear: data['releaseYear'],
        rating: (data['rating'] ?? 0).toDouble(),
        note: data['note'] ?? '',
        watched: data['watched'] ?? false,
        inWatchlist: data['inWatchlist'] ?? false,
        watchedAt:
            data['createdAt'] != null
                ? (data['createdAt'] as Timestamp).toDate()
                : null,
        genres: List<int>.from(data['genres'] ?? []),
        overview: data['overview'] ?? '',
        voteAverage: (data['voteAverage'] ?? 0).toDouble(),
        voteCount: data['voteCount'] ?? 0,
        backdropPath: data['backdropPath'] ?? '',
      );
    }
  }

  final tmdbMovie = await MovieSearchService().getMovieDetails(tmdbId);

  return MovieLocal.fromTmdb(tmdbMovie);
});
