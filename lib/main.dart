import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/auth/auth_providers.dart';
import 'features/auth/login_screen.dart';
import 'features/home/home_screen.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/verify_email.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const ProviderScope(child: CineLedgerApp()));
}

class CineLedgerApp extends StatelessWidget {
  const CineLedgerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CineLedger',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: Consumer(
        builder: (context, ref, _) {
          final authState = ref.watch(authStateProvider);

          return authState.when(
            loading:
                () => const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                ),
            error: (e, _) => Scaffold(body: Center(child: Text('Error: $e'))),
            data: (user) {
              if (user == null) {
                return const LoginScreen();
              }

              if (!user.emailVerified) {
                return VerifyEmailScreen(
                  email: user.email ?? '',
                  name: user.displayName ?? '',
                );
              }

              return const HomeScreen();
            },
          );
        },
      ),
    );
  }
}
