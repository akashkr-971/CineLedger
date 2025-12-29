import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeTab extends StatelessWidget {
  final AsyncValue<Map<String, dynamic>> profileAsync;

  const HomeTab({super.key, required this.profileAsync});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          profileAsync.when(
            loading:
                () => Text(
                  'Welcome back 👋',
                  style: theme.textTheme.headlineSmall,
                ),
            error:
                (_, __) => Text(
                  'Welcome back 👋',
                  style: theme.textTheme.headlineSmall,
                ),
            data: (profile) {
              final name = profile['name'] ?? '';
              return Text(
                name.isNotEmpty ? 'Welcome back, $name 👋' : 'Welcome back 👋',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),

          const SizedBox(height: 8),

          Text(
            '“Every movie you watch becomes a memory.”',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontStyle: FontStyle.italic,
              color: colors.onSurface.withOpacity(0.7),
            ),
          ),

          const SizedBox(height: 24),

          // Search bar preview
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Icon(Icons.search, color: colors.onSurface.withOpacity(0.54)),
                const SizedBox(width: 12),
                Text(
                  'Search movies or series',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colors.onSurface.withOpacity(0.54),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          Text(
            'My Movies',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          SizedBox(
            height: 180,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                return Container(
                  width: 120,
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Text(
                      'Movie',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colors.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
