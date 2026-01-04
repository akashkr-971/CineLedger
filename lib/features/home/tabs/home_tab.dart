import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'home_search_tab.dart';
import '../../movies/movie_list_provioder.dart';
import '../../movies/models/movie_local.dart';
import '../../movies/popular_movies_provider.dart';
import '../../repositories/movie_local_repository.dart';
import '../../repositories/movie_repository.dart';
import '../widgets/popular_movie_card.dart';
import '../widgets/watchlist_movie_card.dart';

class HomeTab extends ConsumerWidget {
  final AsyncValue<Map<String, dynamic>> profileAsync;

  const HomeTab({super.key, required this.profileAsync});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final moviesAsync = ref.watch(movieListProvider);
    final popularAsync = ref.watch(popularMoviesProvider);

    final localRepo = MovieLocalRepository();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 👋 Welcome
          profileAsync.when(
            loading: () => _welcomeText(theme),
            error: (_, __) => _welcomeText(theme),
            data: (profile) {
              final name = profile['name'] ?? '';
              return Text(
                name.isNotEmpty ? 'Welcome back, $name 👋' : 'Welcome back 👋',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),

          const SizedBox(height: 8),

          Text(
            '“Every movie you watch becomes a memory.”',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontStyle: FontStyle.italic,
              color: colors.onSurface.withOpacity(0.7),
            ),
          ),

          const SizedBox(height: 24),

          const HomeSearchBar(),

          const SizedBox(height: 32),

          // 🎬 Watched Recently
          _SectionHeader(title: 'Watched Recently', onViewAll: () {}),

          const SizedBox(height: 12),

          moviesAsync.when(
            loading: () => _loadingRow(),
            error: (_, __) => _emptyRow('Failed to load movies'),
            data: (movies) {
              final watched = movies.where((m) => m.watched).take(6).toList();

              if (watched.isEmpty) {
                return _emptyRow('No watched movies yet 🎬');
              }

              return _MovieHorizontalList(movies: watched);
            },
          ),

          const SizedBox(height: 32),

          // 🔥 Popular Movies
          _SectionHeader(title: 'Popular Movies', onViewAll: () {}),

          const SizedBox(height: 12),

          popularAsync.when(
            loading: () => _loadingRow(),
            error: (_, __) => _emptyRow('Failed to load popular movies'),
            data: (movies) {
              final topSix = movies.take(6).toList();

              return SizedBox(
                height: 240,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: topSix.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (_, index) {
                    final movie = topSix[index];

                    return PopularMovieCard(
                      movie: movie,
                      onAdd: () async {
                        final watchlistMovie = MovieLocal.fromTmdb(movie);
                        await localRepo.saveMovie(watchlistMovie);
                        ref.invalidate(movieListProvider);
                      },
                    );
                  },
                ),
              );
            },
          ),

          const SizedBox(height: 32),

          // 📌 Watchlist
          _SectionHeader(title: 'Watchlist', onViewAll: () {}),

          const SizedBox(height: 12),

          moviesAsync.when(
            loading: () => _loadingRow(),
            error: (_, __) => _emptyRow('Failed to load watchlist'),
            data: (movies) {
              final watchlist =
                  movies
                      .where((m) => m.inWatchlist && !m.watched)
                      .take(6)
                      .toList();

              if (watchlist.isEmpty) {
                return _emptyRow('Your watchlist is empty 🍿');
              }

              return SizedBox(
                height: 240,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: watchlist.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (_, index) {
                    final movie = watchlist[index];

                    return WatchlistMovieCard(
                      movie: movie,
                      onSaveWatched: (rating, note) async {
                        final movieRepo = MovieRepository();
                        await movieRepo.markAsWatched(
                          movie: movie,
                          rating: rating,
                          note: note,
                        );
                        ref.invalidate(movieListProvider);
                      },
                      onRemove: () async {
                        final localRepo = MovieLocalRepository();
                        await localRepo.deleteMovie(movie.tmdbId);
                        ref.invalidate(movieListProvider);
                      },
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _welcomeText(ThemeData theme) {
    return Text('Welcome back 👋', style: theme.textTheme.headlineSmall);
  }

  Widget _loadingRow() {
    return const SizedBox(
      height: 180,
      child: Center(child: CircularProgressIndicator()),
    );
  }

  Widget _emptyRow(String text) {
    return SizedBox(height: 160, child: Center(child: Text(text)));
  }
}

/* -------------------- HELPERS -------------------- */

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onViewAll;

  const _SectionHeader({required this.title, required this.onViewAll});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        TextButton(onPressed: onViewAll, child: const Text('Show all')),
      ],
    );
  }
}

class _MovieHorizontalList extends StatelessWidget {
  final List<MovieLocal> movies;

  const _MovieHorizontalList({required this.movies});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: movies.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, index) {
          return _MovieCard(movie: movies[index]);
        },
      ),
    );
  }
}

class _MovieCard extends StatelessWidget {
  final MovieLocal movie;

  const _MovieCard({required this.movie});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      width: 130,
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child:
                movie.posterPath.isNotEmpty
                    ? Image.network(
                      'https://image.tmdb.org/t/p/w342${movie.posterPath}',
                      fit: BoxFit.cover,
                      width: double.infinity,
                    )
                    : Container(
                      color: colors.onSurface.withOpacity(0.1),
                      child: const Center(child: Icon(Icons.movie_outlined)),
                    ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (movie.releaseYear != null)
                      Text(
                        movie.releaseYear.toString(),
                        style: theme.textTheme.bodySmall,
                      ),
                    Row(
                      children: [
                        Icon(
                          Icons.star_rounded,
                          size: 14,
                          color: colors.secondary,
                        ),
                        const SizedBox(width: 2),
                        Text(movie.rating.toStringAsFixed(1)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
