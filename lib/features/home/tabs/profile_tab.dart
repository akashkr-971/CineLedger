import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/theme/theme_provider.dart';

class ProfileTab extends ConsumerWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final user = FirebaseAuth.instance.currentUser;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 👤 Avatar
          CircleAvatar(
            radius: 42,
            backgroundColor: colors.primary.withOpacity(0.15),
            child: Icon(Icons.person_outline, size: 40, color: colors.primary),
          ),

          const SizedBox(height: 16),

          // 👤 Name
          Text(
            user?.displayName ?? 'CineLedger User',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),

          // 📧 Email
          Text(
            user?.email ?? '',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colors.onSurface.withOpacity(0.6),
            ),
          ),

          const SizedBox(height: 32),

          // 📊 Stats
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              _ProfileStat(label: 'Movies', value: '0'),
              _ProfileStat(label: 'Series', value: '0'),
            ],
          ),

          const SizedBox(height: 32),

          // ⚙️ Settings section
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Settings',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 12),

          _ProfileTile(
            icon: Icons.brightness_6_outlined,
            title: 'Toggle Theme',
            onTap: () {
              ref.read(themeModeProvider.notifier).toggleTheme();
            },
          ),

          _ProfileTile(
            icon: Icons.logout,
            title: 'Log Out',
            isDestructive: true,
            onTap: () async {
              await FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
    );
  }
}

class _ProfileStat extends StatelessWidget {
  final String label;
  final String value;

  const _ProfileStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Column(
      children: [
        Text(
          value,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: colors.primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: colors.onSurface.withOpacity(0.6),
          ),
        ),
      ],
    );
  }
}

class _ProfileTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isDestructive;

  const _ProfileTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final color = isDestructive ? Colors.redAccent : colors.onSurface;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: color),
      title: Text(
        title,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }
}
