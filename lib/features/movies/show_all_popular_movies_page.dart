import 'package:flutter/material.dart';
import '../home/widgets/popular_movie_card.dart';
import '../repositories/movie_repository.dart';
import 'movie_details_page.dart';

class ShowAllPopularMoviesPage extends StatelessWidget {
  final List<Map<String, dynamic>> movies;

  const ShowAllPopularMoviesPage({super.key, required this.movies});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Popular Movies')),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.65,
        ),
        itemCount: movies.length,
        itemBuilder: (_, index) {
          final movie = movies[index];

          return PopularMovieCard(
            movie: movie,
            onAdd: () async {
              final repo = MovieRepository();
              await repo.addToWatchlistFromTmdb(movie);
            },
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MovieDetailsPage(tmdbId: movie['id']),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
