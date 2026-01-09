import 'package:flutter/material.dart';
import '../../movies/models/movie_local.dart';

class MovieGridCard extends StatelessWidget {
  final MovieLocal movie;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const MovieGridCard({
    super.key,
    required this.movie,
    this.onDelete,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap, 
        child: Container(
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(16),
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              Column(
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
                              color: colors.onSurface.withValues(alpha: 0.1),
                              child: const Center(
                                child: Icon(Icons.movie_outlined),
                              ),
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
                            if (movie.watched)
                              Row(
                                children: [
                                  const Icon(
                                    Icons.star_rounded,
                                    size: 14,
                                    color: Colors.amber,
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

              // 🗑️ Delete overlay (independent tap)
              if (onDelete != null)
                Positioned(
                  top: 6,
                  right: 6,
                  child: Material(
                    color: Colors.black54,
                    shape: const CircleBorder(),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: onDelete, // 👈 ONLY delete
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
      ),
    );
  }
}
