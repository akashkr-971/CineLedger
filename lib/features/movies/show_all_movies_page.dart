import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../movies/models/movie_local.dart';
import '../movies/movie_list_provider.dart';
import '../repositories/movie_repository.dart';
import '../home/widgets/movie_gird_card.dart';

class ShowAllMoviesPage extends ConsumerStatefulWidget {
  final String title;
  final List<MovieLocal> movies;

  const ShowAllMoviesPage({
    super.key,
    required this.title,
    required this.movies,
  });

  @override
  ConsumerState<ShowAllMoviesPage> createState() => _ShowAllMoviesPageState();
}

class _ShowAllMoviesPageState extends ConsumerState<ShowAllMoviesPage> {
  late List<MovieLocal> _filteredMovies;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredMovies = widget.movies;
  }

  void _onSearch(String query) {
    final q = query.trim().toLowerCase();

    setState(() {
      if (q.isEmpty) {
        _filteredMovies = widget.movies;
      } else {
        _filteredMovies =
            widget.movies.where((movie) {
              return movie.title.toLowerCase().contains(q);
            }).toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Column(
        children: [
          // 🔍 Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearch,
              decoration: InputDecoration(
                hintText: 'Search movies...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // 🎬 Grid
          Expanded(
            child:
                _filteredMovies.isEmpty
                    ? Center(
                      child: Text(
                        'No movies found',
                        style: theme.textTheme.bodyMedium,
                      ),
                    )
                    : GridView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 0.65,
                          ),
                      itemCount: _filteredMovies.length,
                      itemBuilder: (context, index) {
                        final movie = _filteredMovies[index];

                        return MovieGridCard(
                          movie: movie,
                          onDelete:
                              movie.watched
                                  ? () async {
                                    final confirm = await showDialog<bool>(
                                      context: context,
                                      builder:
                                          (_) => AlertDialog(
                                            title: const Text('Remove movie?'),
                                            content: const Text(
                                              'This will permanently remove it.',
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed:
                                                    () => Navigator.pop(
                                                      context,
                                                      false,
                                                    ),
                                                child: const Text('Cancel'),
                                              ),
                                              TextButton(
                                                onPressed:
                                                    () => Navigator.pop(
                                                      context,
                                                      true,
                                                    ),
                                                child: const Text('Remove'),
                                              ),
                                            ],
                                          ),
                                    );

                                    if (confirm == true) {
                                      final repo = MovieRepository();
                                      await repo.deleteWatchedMovie(
                                        movie.tmdbId,
                                      );
                                      ref.invalidate(movieListProvider);
                                    }
                                  }
                                  : null,
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
