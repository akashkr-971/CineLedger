import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'movie_list_provider.dart';
import 'movie_details_provider.dart';
import '../home/widgets/rate_movie_sheet.dart';
import '../repositories/movie_repository.dart';

class MovieDetailsPage extends ConsumerWidget {
  final int tmdbId;

  const MovieDetailsPage({super.key, required this.tmdbId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final movieAsync = ref.watch(movieDetailsProvider(tmdbId));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          movieAsync
                  .whenData((movie) => movie?.title ?? 'Movie Details')
                  .value ??
              'Movie Details',
        ),
      ),
      body: movieAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),

        error: (e, _) => Center(child: Text('Failed to load movie')),

        data: (movie) {
          if (movie == null) {
            return const Center(child: Text('Movie not found'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🎬 Poster
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child:
                      movie.posterPath.isNotEmpty
                          ? Image.network(
                            'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                            height: 420,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          )
                          : Container(
                            height: 420,
                            color: colors.surfaceVariant,
                            child: const Icon(Icons.movie_outlined, size: 64),
                          ),
                ),

                const SizedBox(height: 24),

                // 🎞 Title
                Text(
                  movie.title,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                // 📅 Year + status
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 20,
                  children: [
                    if (movie.releaseYear != null)
                      Text(
                        movie.releaseYear.toString(),
                        style: theme.textTheme.bodyMedium,
                      ),
                    Chip(
                      label: Text(
                        movie.watched
                            ? 'Watched'
                            : movie.inWatchlist
                            ? 'Watchlist'
                            : 'Popular',
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                if (movie.watched) ...[
                  Text('Watched At', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(
                    '${movie.watchedAt?.day}/${movie.watchedAt?.month}/${movie.watchedAt?.year}',
                  ),
                  const SizedBox(height: 24),
                ],

                // 🎭 Genres
                if (movie.genres.isNotEmpty) ...[
                  Text('Genres', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children:
                        movie.genres
                            .map((g) => Chip(label: Text(g.toString())))
                            .toList(),
                  ),
                ],

                const SizedBox(height: 24),

                // 📝 Overview
                if (movie.overview.isNotEmpty) ...[
                  Text('Overview', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(movie.overview),
                  const SizedBox(height: 24),
                ],

                // ⭐ Rating
                if (movie.watched) ...[
                  Text('Your Rating', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text('${movie.rating.toStringAsFixed(1)} ⭐ / 10'),
                  const SizedBox(height: 24),
                ],

                if (movie.watched) ...[
                  Text('Your Notes', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(movie.note),
                  const SizedBox(height: 24),
                ],

                // 🎬 TMDB stats
                Text('TMDB Stats', style: theme.textTheme.titleMedium),
                const SizedBox(height: 8),
                Text(
                  '${movie.voteAverage.toStringAsFixed(1)} ⭐ (${movie.voteCount} votes)',
                ),

                const SizedBox(height: 32),

                // 🎯 Actions
                if (movie.inWatchlist)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      child: const Text('Mark as Watched'),
                      onPressed: () async {
                        final updated = await showModalBottomSheet<bool>(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder:
                              (_) => RateMovieSheet(
                                movie: movie,
                                onSave: (rating, note) async {
                                  final movieRepo = MovieRepository();
                                  await movieRepo.markAsWatched(
                                    movie: movie,
                                    rating: rating,
                                    note: note,
                                  );
                                },
                              ),
                        );

                        if (updated == true) {
                          print('Sheet result: $updated');
                          ref.invalidate(movieListProvider);
                          ref.invalidate(movieDetailsProvider(tmdbId));
                          Navigator.pop(context);
                        }
                      },
                    ),
                  ),

                if (!movie.watched && !movie.inWatchlist)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      child: const Text('Add to Watchlist'),
                      onPressed: () async {
                        // await movieRepo.addToWatchlistFromLocal(movie);
                        ref.invalidate(movieListProvider);
                        Navigator.pop(context);
                      },
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
