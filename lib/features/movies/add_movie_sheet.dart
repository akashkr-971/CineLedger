import 'package:flutter/material.dart';
import 'movie_search_service.dart';

class AddMovieSheet extends StatefulWidget {
  const AddMovieSheet({super.key});

  @override
  State<AddMovieSheet> createState() => _AddMovieSheetState();
}

class _AddMovieSheetState extends State<AddMovieSheet> {
  final titleController = TextEditingController();
  int? releaseYear;
  bool isLoading = false;
  bool isError = false;
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final movieService = MovieSearchService();
    Map<String, dynamic>? movieResult;

    void showError(String message) {
      if (!mounted) return;
      setState(() {
        isError = true;
        errorMessage = message;
      });
    }

    void clearError() {
      if (!mounted) return;
      setState(() {
        isError = false;
        errorMessage = '';
      });
    }

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
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
              'Add Movie',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            // 🎬 Movie Title
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Movie title',
                hintText: 'Enter movie name',
                prefixIcon: const Icon(Icons.movie_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // 📅 Release Date
            TextField(
              keyboardType: TextInputType.number,
              maxLength: 4,
              decoration: InputDecoration(
                labelText: 'Release year (optional)',
                hintText: 'e.g. 2014',
                prefixIcon: const Icon(Icons.calendar_today_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onChanged: (value) {
                if (value.length == 4) {
                  final year = int.tryParse(value);
                  if (year != null) {
                    setState(() {
                      releaseYear = year;
                    });
                  }
                }
              },
            ),

            const SizedBox(height: 24),

            // 🔍 Search button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon:
                    isLoading
                        ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                        : const Icon(Icons.search),
                label: Text(isLoading ? 'Searching...' : 'Search details'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.primary,
                  foregroundColor: colors.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed:
                    isLoading
                        ? null
                        : () async {
                          clearError();

                          final title = titleController.text.trim();
                          if (title.isEmpty) {
                            showError('Please enter a movie title');
                            return;
                          }
                          if (releaseYear != null) {
                            final year = releaseYear!;
                            final currentYear = DateTime.now().year;

                            if (year < 1900 || year > currentYear) {
                              showError('Please enter a valid release year');
                              return;
                            }
                          }

                          if (!mounted) return;
                          setState(() => isLoading = true);

                          try {
                            final result = await movieService.searchMovie(
                              title: title,
                              year: releaseYear,
                            );

                            if (!mounted) return;

                            if (result == null) {
                              showError(
                                'No movie found. Try a different title or year.',
                              );
                            } else {
                              setState(() {
                                movieResult = result;
                              });
                              clearError();
                              print(movieResult);
                              debugPrint('Movie found: ${result['title']}');
                            }
                          } catch (e) {
                            if (!mounted) return;
                            showError(
                              'Failed to fetch movie details. Please try again.',
                            );
                          } finally {
                            if (mounted) {
                              setState(() => isLoading = false);
                            }
                          }
                        },
              ),
            ),
            if (isError)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.redAccent,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        errorMessage,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.redAccent,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
