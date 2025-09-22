import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/custom_input_field.dart';
import '../widgets/custom_primary_button.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController emailController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose(); 
    super.dispose();
  }

  Future<void> handleResetPassword() async {
    final email = emailController.text.trim();
    debugPrint('Kirim reset ke: $email');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Link verifikasi telah dikirim ke email'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDE8F2),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Image.asset(
                'assets/forgot_password_illustration.png',
                height: 280,
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Lupa Password',
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFB0005E),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Lupa password?\nKami bisa kirim bantuan masuk ke akun kamu.',
                      style: GoogleFonts.poppins(fontSize: 13),
                    ),
                    const SizedBox(height: 20),
                    CustomInputField(
                      label: 'Alamat Email',
                      hint: 'Masukkan email',
                      icon: Icons.email,
                      controller: emailController,
                    ),
                    const SizedBox(height: 24),
                    isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : CustomPrimaryButton(
                            text: 'Kirim',
                            color: const Color(0xFFB0005E),
                            onPressed: handleResetPassword,
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
