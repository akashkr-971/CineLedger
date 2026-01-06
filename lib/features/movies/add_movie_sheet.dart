import 'package:flutter/material.dart';
import 'movie_search_service.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../repositories/movie_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'movie_list_provioder.dart';

class AddMovieSheet extends ConsumerStatefulWidget {
  const AddMovieSheet({super.key});

  @override
  ConsumerState<AddMovieSheet> createState() => _AddMovieSheetState();
}

class _AddMovieSheetState extends ConsumerState<AddMovieSheet> {
  final titleController = TextEditingController();
  final noteController = TextEditingController();

  int? releaseYear;
  double rating = 0;

  bool isLoading = false;
  bool isError = false;
  String errorMessage = '';

  List<Map<String, dynamic>> searchResults = [];
  Map<String, dynamic>? selectedMovie;

  @override
  void dispose() {
    titleController.dispose();
    noteController.dispose();
    super.dispose();
  }

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final movieService = MovieSearchService();

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: colors.onSurface.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),

              // ───────────────── Header ─────────────────
              if (selectedMovie == null)
                Text(
                  'Add Movie',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),

              // ───────────────── Search Form ─────────────────
              if (selectedMovie == null) ...[
                const SizedBox(height: 20),

                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: 'Movie title',
                    prefixIcon: const Icon(Icons.movie_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                TextField(
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  decoration: InputDecoration(
                    labelText: 'Release year (optional)',
                    prefixIcon: const Icon(Icons.calendar_today_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onChanged: (value) {
                    final year = int.tryParse(value);
                    if (year != null) {
                      setState(() => releaseYear = year);
                    }
                  },
                ),

                const SizedBox(height: 24),

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
                    label: Text(isLoading ? 'Searching…' : 'Search details'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.primary,
                      foregroundColor: colors.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
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

                              setState(() => isLoading = true);

                              try {
                                final results = await movieService.searchMovies(
                                  title: title,
                                  year: releaseYear,
                                );

                                if (!mounted) return;

                                if (results.isEmpty) {
                                  showError(
                                    'No movie found. Try a different title.',
                                  );
                                } else {
                                  setState(() {
                                    searchResults = results;
                                    selectedMovie = null;
                                  });
                                }
                              } catch (_) {
                                showError('Failed to fetch movie details.');
                              } finally {
                                if (mounted) {
                                  setState(() => isLoading = false);
                                }
                              }
                            },
                  ),
                ),
              ],

              // ───────────────── Error Message ─────────────────
              if (isError)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: Colors.redAccent),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          errorMessage,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.redAccent,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // ───────────────── Search Results ─────────────────
              if (searchResults.isNotEmpty && selectedMovie == null) ...[
                const SizedBox(height: 20),

                Text(
                  'Select the correct movie',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: searchResults.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, index) {
                    final movie = searchResults[index];
                    final releaseDate = movie['release_date'] ?? '';
                    final year =
                        releaseDate.isNotEmpty
                            ? releaseDate.split('-').first
                            : '—';

                    return ListTile(
                      leading:
                          movie['poster_path'] != null
                              ? Image.network(
                                'https://image.tmdb.org/t/p/w92${movie['poster_path']}',
                                width: 40,
                              )
                              : const Icon(Icons.movie_outlined),
                      title: Text(movie['title']),
                      subtitle: Text(year),
                      onTap: () {
                        setState(() {
                          selectedMovie = movie;
                        });
                      },
                    );
                  },
                ),
              ],

              // ───────────────── Selected Movie View ─────────────────
              if (selectedMovie != null) ...[
                const SizedBox(height: 20),

                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        setState(() {
                          selectedMovie = null;
                        });
                      },
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Add Movie',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                if (selectedMovie!['backdrop_path'] != null ||
                    selectedMovie!['poster_path'] != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      'https://image.tmdb.org/t/p/w780'
                      '${selectedMovie!['backdrop_path'] ?? selectedMovie!['poster_path']}',
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),

                const SizedBox(height: 16),

                Text(
                  selectedMovie!['title'],
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 16),
                Text(
                  'Your Rating',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Center(
                    child: RatingBar.builder(
                      initialRating: rating,
                      minRating: 0,
                      allowHalfRating: true,
                      itemCount: 10,
                      itemSize: 35,
                      unratedColor: colors.onSurface.withValues(alpha: 0.1),
                      itemBuilder:
                          (context, _) =>
                              Icon(Icons.star_rounded, color: colors.secondary),
                      onRatingUpdate: (value) {
                        setState(() => rating = value);
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${rating.toStringAsFixed(1)} / 10',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colors.onSurface.withValues(alpha: 0.6),
                  ),
                ),

                SizedBox(height: 16),
                Text("Add a note about the movie"),
                SizedBox(height: 8),
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
                      if (selectedMovie == null) return;
                      final movieRepo = MovieRepository();
                      final navigator = Navigator.of(context);
                      try {
                        await movieRepo.addMovie(
                          movie: selectedMovie!,
                          rating: rating,
                          note: noteController.text.trim(),
                        );
                        ref.invalidate(movieListProvider);

                        if (!mounted) return;
                        navigator.pop();
                      } catch (e) {
                        if (!mounted) return;
                        debugPrint('Failed to save movie: $e');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.primary,
                      foregroundColor: colors.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text('Add to My Movies'),
                  ),
                ),
              ],

              if (selectedMovie == null) ...[
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
