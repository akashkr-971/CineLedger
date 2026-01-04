import 'package:flutter/material.dart';
import '../../movies/models/movie_local.dart';

typedef SaveWatchedCallback = Future<void> Function(double rating, String note);

class WatchlistMovieCard extends StatelessWidget {
  final MovieLocal movie;
  final SaveWatchedCallback onSaveWatched;
  final VoidCallback onRemove;

  const WatchlistMovieCard({
    super.key,
    required this.movie,
    required this.onSaveWatched,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      width: 160, // ⬅️ wider card
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
                      color: colors.onSurface.withOpacity(0.1),
                      child: const Icon(Icons.movie_outlined),
                    ),
          ),

          // 📄 Details
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 10),
            child: Column(
              children: [
                // 🎞 Title
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

                // 🔘 Action icons (below title)
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
                      onTap: () async {
                        // TEMP values – rating sheet later
                        await onSaveWatched(8.0, '');
                      },
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
      color: Colors.black.withOpacity(0.45),
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
