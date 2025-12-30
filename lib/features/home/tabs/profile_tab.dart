import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/theme/theme_provider.dart';
import '../user_profile_provider.dart';

class ProfileTab extends ConsumerWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final user = FirebaseAuth.instance.currentUser;
    final profileAsync = ref.watch(userProfileProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          RichText(
            text: TextSpan(
              text: 'Cine',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colors.primary,
              ),
              children: [
                TextSpan(
                  text: 'Ledger',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colors.secondary,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // 👤 Avatar
          CircleAvatar(
            radius: 42,
            backgroundColor: colors.primary.withValues(alpha: 0.15),
            child: Icon(Icons.person_outline, size: 40, color: colors.primary),
          ),

          const SizedBox(height: 16),

          // 👤 Name
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                profileAsync.when(
                  loading: () => 'User',
                  error: (_, __) => 'User',
                  data: (profile) => profile['name'] ?? 'User',
                ),
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 6),
              GestureDetector(
                onTap: () {
                  
                },
                child: Icon(Icons.edit, color: colors.primary, size: 20),
              ),
            ],
          ),

          const SizedBox(height: 6),

          // 📧 Email
          Text(
            user?.email ?? '',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colors.onSurface.withValues(alpha: 0.6),
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Joined On : ",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colors.onSurface.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(width: 4),
              Text(
                user?.metadata.creationTime.toString().split(' ').first ?? '',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colors.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
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
            icon: Icons.bookmark_border,
            title: 'Watchlist',
            onTap: () {
              ref.read(themeModeProvider.notifier).toggleTheme();
            },
          ),

          _ProfileTile(
            icon: Icons.brightness_6_outlined,
            title: 'Toggle Theme',
            onTap: () {
              ref.read(themeModeProvider.notifier).toggleTheme();
            },
          ),

          _ProfileTile(
            icon: Icons.password,
            title: 'Change Password',
            isDestructive: false,
            onTap: () async {
              await FirebaseAuth.instance.sendPasswordResetEmail(
                email: user?.email ?? '',
              );
            },
          ),

          _ProfileTile(
            icon: Icons.logout_outlined,
            title: 'Log Out',
            isDestructive: true,
            onTap: () async {
              await FirebaseAuth.instance.signOut();
            },
          ),

          _ProfileTile(
            icon: Icons.delete_outline,
            title: 'Delete Account',
            isDestructive: true,
            onTap: () async {},
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
            color: colors.onSurface.withValues(alpha: 0.6),
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
