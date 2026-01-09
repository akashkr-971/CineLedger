import 'package:flutter/material.dart';
import '../../movies/models/movie_local.dart';
import './rate_movie_sheet.dart';

typedef SaveWatchedCallback = Future<void> Function(double rating, String note);

class WatchlistMovieCard extends StatelessWidget {
  final MovieLocal movie;
  final SaveWatchedCallback onSaveWatched;
  final VoidCallback onRemove;
  final VoidCallback onTap;

  const WatchlistMovieCard({
    super.key,
    required this.movie,
    required this.onSaveWatched,
    required this.onRemove,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        width: 160,
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 🎬 Poster
            Expanded(
              child:
                  movie.posterPath.isNotEmpty
                      ? Image.network(
                        'https://image.tmdb.org/t/p/w342${movie.posterPath}',
                        fit: BoxFit.cover,
                      )
                      : Container(
                        color: colors.onSurface.withValues(alpha: 0.1),
                        child: const Icon(Icons.movie_outlined),
                      ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 10),
              child: Column(
                children: [
                  Text(
                    movie.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _IconButton(
                        icon: Icons.delete_outline,
                        color: colors.error,
                        onTap: onRemove,
                      ),
                      _IconButton(
                        icon: Icons.check_circle_rounded,
                        color: Colors.green,
                        onTap: () {
                          _showRatingSheet(context);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showRatingSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => RateMovieSheet(movie: movie, onSave: onSaveWatched),
    );
  }
}

class _IconButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _IconButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withValues(alpha: 0.45),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(icon, size: 20, color: color),
        ),
      ),
    );
  }
}
