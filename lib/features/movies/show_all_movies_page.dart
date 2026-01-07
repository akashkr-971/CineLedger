import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'models/show_all_types.dart';
import 'movie_list_provider.dart';
import 'popular_movies_provider.dart';
import '../home/widgets/popular_movie_card.dart';
import '../home/widgets/watchlist_movie_card.dart';
import '../repositories/movie_repository.dart';
import '../home/widgets/movie_gird_card.dart';

class ShowAllMoviesPage extends ConsumerWidget {
  final ShowAllType type;

  const ShowAllMoviesPage({super.key, required this.type});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(_title)),
      body: _buildBody(context, ref, theme),
    );
  }

  String get _title {
    switch (type) {
      case ShowAllType.watched:
        return 'Watched Movies';
      case ShowAllType.watchlist:
        return 'Watchlist';
      case ShowAllType.popular:
        return 'Popular Movies';
    }
  }

  Widget _buildBody(BuildContext context, WidgetRef ref, ThemeData theme) {
    switch (type) {
      case ShowAllType.watched:
        return _watchedGrid(ref, theme);

      case ShowAllType.watchlist:
        return _watchlistGrid(ref, theme);

      case ShowAllType.popular:
        return _popularGrid(ref);
    }
  }

  Widget _watchedGrid(WidgetRef ref, ThemeData theme) {
    final moviesAsync = ref.watch(movieListProvider);

    return moviesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const Center(child: Text('Failed to load')),
      data: (movies) {
        final watched =
            movies.where((m) => m.watched).toList()..sort((a, b) {
              final aTime =
                  a.watchedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
              final bTime =
                  b.watchedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
              return bTime.compareTo(aTime);
            });

        if (watched.isEmpty) {
          return const Center(child: Text('No watched movies'));
        }

        return _movieGrid(
          movies: watched,
          itemBuilder: (movie) => MovieGridCard(movie: movie),
        );
      },
    );
  }

  // 📌 Watchlist
  Widget _watchlistGrid(WidgetRef ref, ThemeData theme) {
    final moviesAsync = ref.watch(movieListProvider);

    return moviesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const Center(child: Text('Failed to load')),
      data: (movies) {
        final watchlist = movies.where((m) => m.inWatchlist).toList();

        if (watchlist.isEmpty) {
          return const Center(child: Text('Watchlist is empty'));
        }

        return _movieGrid(
          movies: watchlist,
          itemBuilder:
              (movie) => WatchlistMovieCard(
                movie: movie,
                onSaveWatched: (rating, note) async {
                  final repo = MovieRepository();
                  await repo.markAsWatched(
                    movie: movie,
                    rating: rating,
                    note: note,
                  );
                  ref.invalidate(movieListProvider);
                },
                onRemove: () async {
                  final repo = MovieRepository();
                  await repo.removeFromWatchlist(movie);
                  ref.invalidate(movieListProvider);
                },
              ),
        );
      },
    );
  }

  Widget _popularGrid(WidgetRef ref) {
    final popularAsync = ref.watch(popularMoviesProvider);

    return popularAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const Center(child: Text('Failed to load')),
      data: (movies) {
        return _movieGrid(
          movies: movies,
          itemBuilder:
              (movie) => PopularMovieCard(
                movie: movie,
                onAdd: () async {
                  final repo = MovieRepository();
                  await repo.addToWatchlistFromTmdb(movie);
                  ref.invalidate(movieListProvider);
                },
              ),
        );
      },
    );
  }

  Widget _movieGrid<T>({
    required List<T> movies,
    required Widget Function(T) itemBuilder,
  }) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.6,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: movies.length,
      itemBuilder: (_, index) => itemBuilder(movies[index]),
    );
  }
}
