import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MovieRepository {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future<void> addMovie({
    required Map<String, dynamic> movie,
    required double rating,
    required String note,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    final releaseDate = movie['release_date'] ?? '';
    final year =
        releaseDate.isNotEmpty ? int.parse(releaseDate.split('-').first) : null;

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('movies')
        .doc(movie['id'].toString())
        .set({
          'tmdbId': movie['id'],
          'title': movie['title'],
          'originalTitle': movie['original_title'],
          'overview': movie['overview'],
          'posterPath': movie['poster_path'],
          'backdropPath': movie['backdrop_path'],
          'genres': movie['genre_ids'],
          'releaseYear': year,
          'rating': rating,
          'note': note,
          'voteAverage': movie['vote_average'],
          'voteCount': movie['vote_count'],
          'createdAt': FieldValue.serverTimestamp(),
        });
  }
}
