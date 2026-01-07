import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../movies/movie_list_provider.dart';
import '../../movies/models/movie_local.dart';
import '../../movies/popular_movies_provider.dart';
import '../../repositories/movie_local_repository.dart';
import '../../repositories/movie_repository.dart';
import '../widgets/popular_movie_card.dart';
import '../widgets/watchlist_movie_card.dart';
import '../../movies/show_all_movies_page.dart';
import '../../movies/show_all_popular_movies_page.dart';

class HomeTab extends ConsumerWidget {
  final AsyncValue<Map<String, dynamic>> profileAsync;

  const HomeTab({super.key, required this.profileAsync});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final moviesAsync = ref.watch(movieListProvider);
    final popularAsync = ref.watch(popularMoviesProvider);

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
              color: colors.onSurface.withValues(alpha: 0.7),
            ),
          ),

          const SizedBox(height: 24),

          // 🎬 Watched Recently
          moviesAsync.when(
            loading:
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SectionHeader(title: 'Watched Recently', onViewAll: () {}),
                    const SizedBox(height: 12),
                    _loadingRow(),
                  ],
                ),

            error:
                (_, __) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SectionHeader(title: 'Watched Recently', onViewAll: () {}),
                    const SizedBox(height: 12),
                    _emptyRow('Failed to load movies'),
                  ],
                ),

            data: (movies) {
              final watchedMovies =
                  movies.where((m) => m.watched).toList()..sort((a, b) {
                    final aTime =
                        a.watchedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
                    final bTime =
                        b.watchedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
                    return bTime.compareTo(aTime); // newest first
                  });

              final recentSix = watchedMovies.take(6).toList();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionHeader(
                    title: 'Watched Recently',
                    onViewAll:
                        watchedMovies.isEmpty
                            ? () {}
                            : () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => ShowAllMoviesPage(
                                        title: 'Watched Movies',
                                        movies: watchedMovies,
                                      ),
                                ),
                              );
                            },
                  ),

                  const SizedBox(height: 12),

                  watchedMovies.isEmpty
                      ? _emptyRow('No watched movies yet 🎬')
                      : _MovieHorizontalList(movies: recentSix),
                ],
              );
            },
          ),

          const SizedBox(height: 32),

          // 🔥 Popular Movies
          popularAsync.when(
            loading:
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SectionHeader(title: 'Popular Movies', onViewAll: () {}),
                    const SizedBox(height: 12),
                    _loadingRow(),
                  ],
                ),

            error:
                (_, __) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SectionHeader(title: 'Popular Movies', onViewAll: () {}),
                    const SizedBox(height: 12),
                    _emptyRow('Failed to load popular movies'),
                  ],
                ),

            data: (popularMovies) {
              // 🔹 Local movies (Hive)
              final localMovies = ref
                  .watch(movieListProvider)
                  .maybeWhen(
                    data: (movies) => movies,
                    orElse: () => <MovieLocal>[],
                  );

              final localMovieIds = {for (final m in localMovies) m.tmdbId};

              // 🔥 Filter out watched / watchlisted
              final visiblePopular =
                  popularMovies
                      .where((movie) => !localMovieIds.contains(movie['id']))
                      .toList();

              final previewSix = visiblePopular.take(6).toList();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionHeader(
                    title: 'Popular Movies',
                    onViewAll:
                        visiblePopular.isEmpty
                            ? () {}
                            : () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => ShowAllPopularMoviesPage(
                                        movies:
                                            visiblePopular, // ✅ raw TMDB data
                                      ),
                                ),
                              );
                            },
                  ),

                  const SizedBox(height: 12),

                  visiblePopular.isEmpty
                      ? _emptyRow('No new popular movies 🎬')
                      : SizedBox(
                        height: 240,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: previewSix.length,
                          separatorBuilder:
                              (_, __) => const SizedBox(width: 12),
                          itemBuilder: (_, index) {
                            final movie = previewSix[index];

                            return PopularMovieCard(
                              movie: movie,
                              onAdd: () async {
                                final movieRepo = MovieRepository();
                                await movieRepo.addToWatchlistFromTmdb(movie);
                                ref.invalidate(movieListProvider);
                              },
                            );
                          },
                        ),
                      ),
                ],
              );
            },
          ),

          const SizedBox(height: 32),

          // 📌 Watchlist
          moviesAsync.when(
            loading:
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SectionHeader(title: 'Watchlist', onViewAll: () {}),
                    const SizedBox(height: 12),
                    _loadingRow(),
                  ],
                ),

            error:
                (_, __) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SectionHeader(title: 'Watchlist', onViewAll: () {}),
                    const SizedBox(height: 12),
                    _emptyRow('Failed to load watchlist'),
                  ],
                ),

            data: (movies) {
              final watchlistMovies =
                  movies.where((m) => m.inWatchlist && !m.watched).toList();

              final previewSix = watchlistMovies.take(6).toList();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionHeader(
                    title: 'Watchlist',
                    onViewAll:
                        watchlistMovies.isEmpty
                            ? () {}
                            : () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => ShowAllMoviesPage(
                                        title: 'Watchlist Movies',
                                        movies: watchlistMovies,
                                      ),
                                ),
                              );
                            },
                  ),

                  const SizedBox(height: 12),

                  watchlistMovies.isEmpty
                      ? _emptyRow('Your watchlist is empty 🍿')
                      : SizedBox(
                        height: 240,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: previewSix.length,
                          separatorBuilder:
                              (_, __) => const SizedBox(width: 12),
                          itemBuilder: (_, index) {
                            final movie = previewSix[index];

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
                      ),
                ],
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

class _MovieCard extends ConsumerWidget {
  final MovieLocal movie;

  const _MovieCard({required this.movie});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          // 🎬 Poster + overlay actions
          Expanded(
            child: Stack(
              children: [
                // Poster image
                Positioned.fill(
                  child:
                      movie.posterPath.isNotEmpty
                          ? Image.network(
                            'https://image.tmdb.org/t/p/w342${movie.posterPath}',
                            fit: BoxFit.cover,
                          )
                          : Container(
                            color: colors.onSurface.withOpacity(0.1),
                            child: const Center(
                              child: Icon(Icons.movie_outlined),
                            ),
                          ),
                ),

                // 🗑️ Delete button overlay
                Positioned(
                  top: 6,
                  right: 6,
                  child: Material(
                    color: Colors.black.withOpacity(0.55),
                    shape: const CircleBorder(),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder:
                              (_) => AlertDialog(
                                title: const Text('Remove movie?'),
                                content: const Text(
                                  'This will permanently remove it from your history.',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed:
                                        () => Navigator.pop(context, false),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed:
                                        () => Navigator.pop(context, true),
                                    child: const Text('Remove'),
                                  ),
                                ],
                              ),
                        );

                        if (confirm == true) {
                          final movieRepo = MovieRepository();
                          await movieRepo.deleteWatchedMovie(movie.tmdbId);
                          ref.invalidate(movieListProvider);
                        }
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(6),
                        child: Icon(
                          Icons.delete_outline,
                          size: 18,
                          color: Colors.redAccent,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 📄 Details
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
