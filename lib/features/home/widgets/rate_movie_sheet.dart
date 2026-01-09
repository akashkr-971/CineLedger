import 'package:flutter/material.dart';
import '../../movies/models/movie_local.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

typedef SaveWatchedCallback = Future<void> Function(double rating, String note);

class RateMovieSheet extends StatefulWidget {
  final MovieLocal movie;
  final SaveWatchedCallback onSave;

  const RateMovieSheet({super.key, required this.movie, required this.onSave});

  @override
  State<RateMovieSheet> createState() => _RateMovieSheetState();
}

class _RateMovieSheetState extends State<RateMovieSheet> {
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.primary,
                  foregroundColor: colors.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () async {
                  if (rating == 0) {
                    setState(() => showRatingError = true);
                    return;
                  }

                  await widget.onSave(rating, noteController.text.trim());

                  if (context.mounted) {
                    print('Saving movie & closing sheet');
                    Navigator.pop(context, true);
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
