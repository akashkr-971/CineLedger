import 'package:flutter/material.dart';

class HomeSearchBar extends StatefulWidget {
  const HomeSearchBar({super.key});

  @override
  State<HomeSearchBar> createState() => _HomeSearchBarState();
}

class _HomeSearchBarState extends State<HomeSearchBar> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late List<Map<String, dynamic>> filteredResults;
  bool showResults = false;

  // TEMP mock data (replace later)
  final List<Map<String, dynamic>> mockResults = [
    {'title': 'Inception', 'year': 2010, 'watched': true},
    {'title': 'Interstellar', 'year': 2014, 'watched': false},
    {'title': 'The Dark Knight', 'year': 2008, 'watched': true},
  ];

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    filteredResults = mockResults;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return SizedBox(
      height: showResults ? 320 : 64,
      child: Stack(
        children: [
          TextField(
            controller: _controller,
            focusNode: _focusNode,
            onTap: () {
              setState(() => showResults = true);
            },
            onChanged: (value) {
              final query = value.toLowerCase().trim();

              setState(() {
                showResults = query.isNotEmpty;

                filteredResults =
                    mockResults.where((movie) {
                      final title = (movie['title'] as String).toLowerCase();
                      return title.contains(query);
                    }).toList();
              });
            },
            decoration: InputDecoration(
              hintText: 'Search movies or series',
              prefixIcon: Icon(
                Icons.search,
                color: colors.onSurface.withValues(alpha: 0.54),
              ),
              filled: true,
              fillColor: colors.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),

          if (showResults)
            Positioned(
              top: 64,
              left: 0,
              right: 0,
              child: Material(
                elevation: 8,
                borderRadius: BorderRadius.circular(14),
                color: colors.surface,
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: filteredResults.length,
                  separatorBuilder:
                      (_, __) => Divider(
                        height: 1,
                        color: colors.onSurface.withValues(alpha: 0.08),
                      ),
                  itemBuilder: (context, index) {
                    final movie = filteredResults[index];

                    return ListTile(
                      title: Text(
                        '${movie['title']} (${movie['year']})',
                        style: theme.textTheme.bodyMedium,
                      ),
                      trailing:
                          movie['watched']
                              ? _WatchedChip()
                              : const SizedBox.shrink(),
                      onTap: () {
                        _focusNode.unfocus();
                        setState(() => showResults = false);
                      },
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _WatchedChip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: colors.secondary.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        'Watched',
        style: TextStyle(
          color: colors.secondary,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
