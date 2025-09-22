import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/custom_input_field.dart';
import '../widgets/custom_primary_button.dart';
import 'package:Speak_project/controllers/auth_controller.dart';
import 'package:Speak_project/services/auth_service.dart';

class ResendVerificationPage extends StatefulWidget {
  const ResendVerificationPage({super.key});

  @override
  State<ResendVerificationPage> createState() => _ResendVerificationPageState();
}

class _ResendVerificationPageState extends State<ResendVerificationPage> {
  final TextEditingController emailController = TextEditingController();
  bool isLoading = false;
  late final AuthController _authController;

  @override
  void initState() {
    super.initState();
    _authController = AuthController(authService: AuthService());
  }

  Future<void> resendVerification() async {
    setState(() => isLoading = true);

    try {
      final email = emailController.text.trim();
      await _authController.resendVerification(
        context: context,
        email: email,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Verification email sent successfully'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to resend verification: $e'),
        ),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
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
                'assets/resend_email_illustration.png',
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
                      'Resend Verification',
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFB0005E),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Enter your email to resend the verification.',
                      style: GoogleFonts.poppins(fontSize: 13),
                    ),
                    const SizedBox(height: 20),
                    CustomInputField(
                      label: 'Email Address',
                      hint: 'Enter email',
                      icon: Icons.email,
                      controller: emailController,
                    ),
                    const SizedBox(height: 24),
                    isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : CustomPrimaryButton(
                            text: 'Resend Verification',
                            color: const Color(0xFFB0005E),
                            onPressed: resendVerification,
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
