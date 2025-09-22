import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:Speak_project/controllers/auth_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/colors.dart';
import '../widgets/custom_primary_button.dart';
import '../widgets/custom_input_field.dart';
import '../services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  late final AuthController _authController;
  late final AuthService _auth;

  bool _showResendVerification = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _auth = AuthService();
    _authController = AuthController(authService: _auth);
  }

  Future<void> handleLogin() async {
    setState(() {
      _isLoading = true;
      _showResendVerification = false;
    });

    try {
      // Mencoba menjalankan kode yang berpotensi error
      log(email.text);
      log(password.text);

      final result = await _authController.login(
        email: email.text.trim(),
        password: password.text,
      );

      if (result['success'] == true) {
        final prefs = await SharedPreferences.getInstance();
        final lastRedirect = prefs.getString('lastRedirect');

        setState(() {
          _showResendVerification = lastRedirect == '/resend-verification';
        });

        if (!_showResendVerification) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      } else {
        // Menangani kegagalan logis dari server (misal: password salah)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  result['message'] ?? 'Login gagal, cek email atau password')),
        );
      }
    } catch (e) {
      // Menangkap semua jenis error/exception, termasuk DioException
      log('Login failed with exception: $e'); // Untuk debugging di konsol
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login gagal, cek email atau password')),
      );
    } finally {
      // Blok ini akan selalu dieksekusi, baik sukses maupun error
      // Memastikan loading indicator selalu berhenti
      if (mounted) {
        // Cek apakah widget masih ada di tree
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Image.asset(
                'assets/login_illustration.png',
                height: 240,
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Login',
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Masuk untuk mendapatkan dukungan yang kamu butuhkan!',
                      style: GoogleFonts.poppins(fontSize: 13),
                    ),
                    const SizedBox(height: 20),
                    CustomInputField(
                      controller: email,
                      label: 'Alamat Email',
                      hint: 'Masukkan email',
                      icon: Icons.email,
                    ),
                    const SizedBox(height: 16),
                    CustomInputField(
                      controller: password,
                      label: 'Password',
                      hint: 'Masukkan password',
                      icon: Icons.lock,
                      obscureText: true,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/register');
                          },
                          child: Text(
                            'Register',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.black87,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/forgot-password');
                          },
                          child: Text(
                            'Lupa Password?',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.black87,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : CustomPrimaryButton(
                            text: 'Login',
                            onPressed: handleLogin,
                          ),
                    if (_showResendVerification)
                      TextButton(
                        onPressed: () async {
                          try {
                            final userEmail = email.text.trim();
                            if (userEmail.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Tolong masukkan emailmu untuk mengirim verifikasi')),
                              );
                              return;
                            }
                            await _auth.resendVerification(userEmail);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Verifikasi email terkirim')),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      'Gagal mengirim ulang verifikasi: $e')),
                            );
                          }
                        },
                        child: const Text('Kirim Ulang Verifikasi'),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Image.asset(
                'assets/logo.png',
                height: 36,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
