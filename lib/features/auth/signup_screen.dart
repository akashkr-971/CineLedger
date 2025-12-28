import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/widgets/cine_input_field.dart';
import 'login_screen.dart';
import 'auth_providers.dart';
import 'verify_email.dart';
import '../../core/widgets/cine_snack_bar.dart';

class SignUpScreen extends ConsumerWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;

    final authService = ref.read(authServiceProvider);

    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

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
            child: Container(color: Colors.black.withOpacity(0.55)),
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
                            const SizedBox(height: 50),

                            Image.asset(
                              'assets/logo/cineledger_bg_remove.png',
                              height: 180,
                            ),

                            const SizedBox(height: 32),

                            CineInputField(
                              hint: 'Name',
                              icon: Icons.person_outline,
                              controller: nameController,
                            ),
                            const SizedBox(height: 16),

                            CineInputField(
                              hint: 'Email',
                              icon: Icons.email_outlined,
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                            ),
                            const SizedBox(height: 16),

                            CineInputField(
                              hint: 'Password',
                              icon: Icons.lock_outline,
                              isPassword: true,
                              controller: passwordController,
                            ),
                            const SizedBox(height: 16),

                            CineInputField(
                              hint: 'Confirm Password',
                              icon: Icons.lock_outline,
                              isPassword: true,
                              controller: confirmPasswordController,
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
                                  final name = nameController.text.trim();
                                  final email = emailController.text.trim();
                                  final password =
                                      passwordController.text.trim();
                                  final confirmPassword =
                                      confirmPasswordController.text.trim();

                                  if (name.isEmpty ||
                                      email.isEmpty ||
                                      password.isEmpty ||
                                      confirmPassword.isEmpty) {
                                    CineSnack.error(
                                      context,
                                      'All fields are required',
                                    );
                                    return;
                                  }
                                  if (!email.contains('@') ||
                                      !email.contains('.')) {
                                    CineSnack.error(
                                      context,
                                      'Invalid email address',
                                    );
                                    return;
                                  }
                                  if (password.length < 6) {
                                    CineSnack.error(
                                      context,
                                      'Password must be at least 6 characters',
                                    );
                                    return;
                                  }
                                  if (password != confirmPassword) {
                                    CineSnack.error(
                                      context,
                                      'Passwords do not match',
                                    );
                                    return;
                                  }
                                  try {
                                    await authService.signUpWithEmail(
                                      email: email,
                                      password: password,
                                    );
                                    await authService.sendEmailVerification();

                                    if (!context.mounted) return;
                                    CineSnack.success(
                                      context,
                                      'Verification email sent. Please verify before logging in.',
                                    );
                                    await Future.delayed(
                                      const Duration(seconds: 3),
                                    );
                                    if (!context.mounted) return;
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) =>
                                                VerifyEmailScreen(email: email),
                                      ),
                                    );
                                  } catch (e) {
                                    if (!context.mounted) return;

                                    CineSnack.error(context, 'Error: $e.');
                                  }
                                },

                                child: const Text(
                                  'Create Account',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),

                            const Spacer(),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Already have an account? ',
                                  style: TextStyle(color: Colors.white70),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => const LoginScreen(),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    'Log In',
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
