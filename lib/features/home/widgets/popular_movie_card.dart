import 'package:flutter/material.dart';

class PopularMovieCard extends StatelessWidget {
  final Map<String, dynamic> movie;
  final VoidCallback onAdd;
  final VoidCallback onTap;

  const PopularMovieCard({
    super.key,
    required this.movie,
    required this.onAdd,
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
        width: 140,
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
                  movie['poster_path'] != null
                      ? Image.network(
                        'https://image.tmdb.org/t/p/w342${movie['poster_path']}',
                        fit: BoxFit.cover,
                        width: double.infinity,
                      )
                      : Container(
                        color: colors.onSurface.withValues(alpha: 0.1),
                        child: const Icon(Icons.movie_outlined),
                      ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie['title'],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.add, size: 16),
                      label: const Text('Watchlist'),
                      onPressed: onAdd,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        textStyle: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
