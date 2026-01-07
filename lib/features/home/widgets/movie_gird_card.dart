import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../movies/models/movie_local.dart';
import '../../repositories/movie_repository.dart';
import '../../movies/movie_list_provider.dart';

class MovieGridCard extends ConsumerWidget {
  final MovieLocal movie;

  const MovieGridCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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

          // 📄 Info
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

                    if (movie.watched)
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
