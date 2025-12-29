import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_providers.dart';
import 'signup_screen.dart';
import '../../core/widgets/cine_input_field.dart';
import '../../core/widgets/cine_snack_bar.dart';
import 'verify_email.dart';
import '../repositories/user_repository.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final authService = ref.read(authServiceProvider);
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/film_roll.png',
              fit: BoxFit.cover,
            ),
          ),

          Positioned.fill(
            child: Container(color: Colors.black.withValues(alpha: 0.45)),
          ),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          children: [
                            const SizedBox(height: 60),

                            // 🔹 Logo
                            Image.asset(
                              'assets/logo/cineledger_bg_remove.png',
                              height: 240,
                            ),

                            const SizedBox(height: 40),

                            CineInputField(
                              hint: 'Email',
                              icon: Icons.email_outlined,
                              controller: emailController,
                            ),
                            const SizedBox(height: 16),

                            CineInputField(
                              hint: 'Password',
                              icon: Icons.lock_outline,
                              isPassword: true,
                              controller: passwordController,
                            ),

                            const SizedBox(height: 32),

                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: colors.secondary,
                                  foregroundColor: Colors.black,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                onPressed: () async {
                                  final email = emailController.text.trim();
                                  final password =
                                      passwordController.text.trim();

                                  if (email.isEmpty || password.isEmpty) {
                                    CineSnack.error(
                                      context,
                                      'Please enter both email and password',
                                    );
                                    return;
                                  }

                                  try {
                                    await authService
                                        .signInWithEmailAndPassword(
                                          email: email,
                                          password: password,
                                        );

                                    if (!context.mounted) return;

                                    final user = authService.currentUser;

                                    if (user != null && !user.emailVerified) {
                                      CineSnack.warning(
                                        context,
                                        'Please verify your email before logging in.',
                                      );

                                      await Future.delayed(
                                        const Duration(seconds: 3),
                                      );
                                      if (!context.mounted) return;
                                      Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                          builder:
                                              (_) => VerifyEmailScreen(
                                                email: email,
                                                name: user.displayName ?? '',
                                              ),
                                        ),
                                      );
                                      return;
                                    }

                                    CineSnack.success(
                                      context,
                                      'Login successful',
                                    );
                                  } catch (e) {
                                    if (!context.mounted) return;

                                    CineSnack.error(
                                      context,
                                      'Login failed. Please check your credentials.',
                                    );
                                  }
                                },

                                child: const Text(
                                  'Log In',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),

                            TextButton(
                              onPressed: () async {
                                final email = emailController.text.trim();
                                if (email.isEmpty) {
                                  CineSnack.error(
                                    context,
                                    'Please enter your email to reset password',
                                  );
                                  return;
                                }
                                if (!email.contains('@') ||
                                    !email.contains('.')) {
                                  CineSnack.error(
                                    context,
                                    'Please enter a valid email address',
                                  );
                                  return;
                                }
                                try {
                                  await authService.sendPasswordResetEmail(
                                    email,
                                  );

                                  if (!context.mounted) return;

                                  CineSnack.success(
                                    context,
                                    'If an account exists, a password reset link has been sent.',
                                  );
                                } catch (e) {
                                  if (!context.mounted) return;

                                  // ⚠️ Do NOT expose exact errors (security)
                                  CineSnack.success(
                                    context,
                                    'If an account exists, a password reset link has been sent.',
                                  );
                                }
                              },
                              child: const Text(
                                'Forgot Password?',
                                style: TextStyle(color: Colors.white70),
                              ),
                            ),

                            const SizedBox(height: 24),

                            Row(
                              children: const [
                                Expanded(child: Divider(color: Colors.white24)),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 12),
                                  child: Text(
                                    'Or log in or Sign Up with',
                                    style: TextStyle(color: Colors.white70),
                                  ),
                                ),
                                Expanded(child: Divider(color: Colors.white24)),
                              ],
                            ),

                            const SizedBox(height: 20),

                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.black,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                icon: Image.asset(
                                  'assets/logo/google.png',
                                  height: 20,
                                ),
                                label: const Text(
                                  'Continue with Google',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                onPressed: () async {
                                  try {
                                    final credential =
                                        await authService.signInWithGoogle();

                                    final user = credential.user;
                                    if (user == null) return;
                                    final repo = UserRepository();
                                    await repo.createOrUpdateUserFromAuth();

                                    if (!context.mounted) return;

                                    CineSnack.success(
                                      context,
                                      'Logged in successfully',
                                    );
                                  } catch (e) {
                                    if (!context.mounted) return;

                                    CineSnack.error(
                                      context,
                                      'Google sign-in failed. Please try again.',
                                    );
                                  }
                                },
                              ),
                            ),
                            const Spacer(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'New user? ',
                                  style: TextStyle(color: Colors.white70),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => const SignUpScreen(),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    'Sign Up',
                                    style: TextStyle(
                                      color: Color(0xFFFBBF24),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 40),
                          ],
                        ),
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
