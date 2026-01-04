import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'home_search_tab.dart';
import '../../movies/movie_list_provioder.dart';
import '../../movies/models/movie_local.dart';

class HomeTab extends ConsumerWidget {
  final AsyncValue<Map<String, dynamic>> profileAsync;

  const HomeTab({super.key, required this.profileAsync});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    // ✅ Watch movies (Hive → Firestore)
    final moviesAsync = ref.watch(movieListProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 👋 Welcome text
          profileAsync.when(
            loading:
                () => Text(
                  'Welcome back 👋',
                  style: theme.textTheme.headlineSmall,
                ),
            error:
                (_, __) => Text(
                  'Welcome back 👋',
                  style: theme.textTheme.headlineSmall,
                ),
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

          // 🎬 Quote
          Text(
            '“Every movie you watch becomes a memory.”',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontStyle: FontStyle.italic,
              color: colors.onSurface.withValues(alpha: 0.7),
            ),
          ),

          const SizedBox(height: 24),

          // 🔍 Search
          const HomeSearchBar(),

          const SizedBox(height: 32),

          // 🎞 My Movies title
          Text(
            'My Movies',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          // 🎬 Movie list (Hive-first)
          moviesAsync.when(
            loading:
                () => const SizedBox(
                  height: 180,
                  child: Center(child: CircularProgressIndicator()),
                ),

            error:
                (e, _) => SizedBox(
                  height: 180,
                  child: Center(
                    child: Text(
                      'Failed to load movies',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                ),

            data: (movies) {
              if (movies.isEmpty) {
                return SizedBox(
                  height: 180,
                  child: Center(
                    child: Text(
                      'No movies added yet 🎬',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colors.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ),
                );
              }

              return SizedBox(
                height: 220,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: movies.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final MovieLocal movie = movies[index];

                    return _MovieCard(movie: movie);
                  },
                ),
              );
            },
          ),
        ],
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
          // 🎬 Poster
          Expanded(
            child:
                movie.posterPath.isNotEmpty
                    ? Image.network(
                      'https://image.tmdb.org/t/p/w342${movie.posterPath}',
                      width: double.infinity,
                      fit: BoxFit.cover,
                    )
                    : Container(
                      color: colors.onSurface.withOpacity(0.1),
                      child: const Center(child: Icon(Icons.movie_outlined)),
                    ),
          ),

          // 🎞 Details
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
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colors.onSurface.withOpacity(0.6),
                        ),
                      ),

                    Row(
                      children: [
                        Icon(
                          Icons.star_rounded,
                          size: 14,
                          color: colors.secondary,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          movie.rating.toStringAsFixed(1),
                          style: theme.textTheme.bodySmall,
                        ),
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
