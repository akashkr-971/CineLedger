import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'movie_local_repository.dart';
import '../movies/models/movie_local.dart';

class MovieRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final MovieLocalRepository _localRepo;

  MovieRepository({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
    MovieLocalRepository? localRepo,
  }) : _firestore = firestore ?? FirebaseFirestore.instance,
       _auth = auth ?? FirebaseAuth.instance,
       _localRepo = localRepo ?? MovieLocalRepository();

  Future<void> addMovie({
    required Map<String, dynamic> movie,
    required double rating,

    String? note,
  }) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }

    final int tmdbId = movie['id'];
    final String title = movie['title'];

    final releaseDate = movie['release_date'] ?? '';
    final int? year =
        releaseDate.isNotEmpty
            ? int.tryParse(releaseDate.split('-').first)
            : null;

    /// 🔥 1. SAVE LOCALLY FIRST (offline-first)
    final localMovie = MovieLocal(
      tmdbId: tmdbId,
      title: title,
      posterPath: movie['poster_path'] ?? '',
      releaseYear: year,
      rating: rating,
      note: note ?? '',
      watched: true,
      inWatchlist: false,
      watchedAt: DateTime.now(),
    );

    await _localRepo.saveMovie(localMovie);

    /// ☁️ 2. SYNC TO FIRESTORE
    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('movies')
        .doc(tmdbId.toString())
        .set({
          'tmdbId': tmdbId,
          'userId': user.uid,

          'title': title,
          'originalTitle': movie['original_title'],
          'overview': movie['overview'],

          'posterPath': movie['poster_path'],
          'backdropPath': movie['backdrop_path'],

          'genres': movie['genre_ids'] ?? [],
          'releaseYear': year,

          'rating': rating,
          'note': note ?? '',
          'watched': true,

          'voteAverage': movie['vote_average'],
          'voteCount': movie['vote_count'],

          'createdAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
  }

  Future<void> syncFromFirestoreToLocal() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final snapshot =
        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('movies')
            .get();

    final localRepo = MovieLocalRepository();

    final movies =
        snapshot.docs.map((doc) {
          final data = doc.data();

          return MovieLocal(
            tmdbId: data['tmdbId'],
            title: data['title'],
            posterPath: data['posterPath'] ?? '',
            releaseYear: data['releaseYear'],
            rating: (data['rating'] ?? 0).toDouble(),
            note: data['note'] ?? '',
            watched: data['watched'] ?? true,
            inWatchlist: data['inWatchlist'] ?? false,
          );
        }).toList();

    await localRepo.saveMovies(movies);
  }

  Future<void> addToWatchlistFromTmdb(Map<String, dynamic> movie) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('Not logged in');

    final localMovie = MovieLocal.fromTmdb(
      movie,
    ).copyWith(inWatchlist: true, watched: false);

    await _localRepo.saveMovie(localMovie);

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('movies')
        .doc(localMovie.tmdbId.toString())
        .set({
          'tmdbId': localMovie.tmdbId,
          'userId': user.uid,
          'title': localMovie.title,
          'posterPath': localMovie.posterPath,
          'releaseYear': localMovie.releaseYear,
          'genres': movie['genre_ids'] ?? [],
          'overview': movie['overview'] ?? '',
          'voteAverage': movie['vote_average'],
          'voteCount': movie['vote_count'],
          'watched': false,
          'inWatchlist': true,
          'createdAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
  }

  Future<void> removeFromWatchlist(MovieLocal movie) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('Not authenticated');

    final updated = movie.copyWith(inWatchlist: false);

    // 🔥 Local first
    await _localRepo.saveMovie(updated);

    // ☁️ Firestore sync
    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('movies')
        .doc(movie.tmdbId.toString())
        .set({
          'inWatchlist': false,
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
  }

  Future<void> markAsWatched({
    required MovieLocal movie,
    required double rating,
    required String note,
    DateTime? watchedAt,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    if (rating <= 0) {
      throw Exception('Rating is required');
    }

    final updated = movie.copyWith(
      watched: true,
      inWatchlist: false,
      rating: rating,
      note: note,
      watchedAt: DateTime.now(),
    );

    await _localRepo.saveMovie(updated);

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('movies')
        .doc(movie.tmdbId.toString())
        .set({
          'tmdbId': movie.tmdbId,
          'userId': user.uid,

          'title': movie.title,
          'posterPath': movie.posterPath,
          'releaseYear': movie.releaseYear,

          'rating': rating,
          'note': note,

          'watched': true,
          'inWatchlist': false,

          'watchedAt': FieldValue.serverTimestamp(),

          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
  }
}
