import 'package:flutter/material.dart';
import '../../movies/models/movie_local.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

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
                      color: colors.onSurface.withOpacity(0.1),
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
    );
  }

  void _showRatingSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _RateMovieSheet(movie: movie, onSave: onSaveWatched),
    );
  }
}

class _RateMovieSheet extends StatefulWidget {
  final MovieLocal movie;
  final SaveWatchedCallback onSave;

  const _RateMovieSheet({required this.movie, required this.onSave});

  @override
  State<_RateMovieSheet> createState() => _RateMovieSheetState();
}

class _RateMovieSheetState extends State<_RateMovieSheet> {
  double rating = 0.0;
  final noteController = TextEditingController();
  bool showRatingError = false;

  @override
  void dispose() {
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: colors.onSurface.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),

            Text(
              widget.movie.title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            Text('Your rating'),
            const SizedBox(height: 8),

            Center(
              child: RatingBar.builder(
                initialRating: rating,
                minRating: 0,
                allowHalfRating: true,
                itemCount: 10,
                itemSize: 32,
                unratedColor: colors.onSurface.withValues(alpha: 0.15),
                itemBuilder:
                    (_, __) =>
                        Icon(Icons.star_rounded, color: colors.secondary),
                onRatingUpdate: (value) {
                  setState(() {
                    rating = value;
                    showRatingError = false; // ✅ clear error on rate
                  });
                },
              ),
            ),

            if (showRatingError)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'Please provide a rating',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colors.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            Text('Rating : ${rating.toStringAsFixed(1)} / 10'),

            const SizedBox(height: 16),

            TextField(
              controller: noteController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Add a note (optional)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (rating == 0) {
                    setState(() => showRatingError = true);
                    return;
                  }

                  await widget.onSave(rating, noteController.text.trim());

                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                },
                child: const Text('Mark as Watched'),
              ),
            ),
          ],
        ),
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
