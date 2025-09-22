import 'package:Speak_project/pages/add_report_page.dart';
import 'package:Speak_project/pages/resend_verification_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

//Pages
import 'pages/splash_page.dart';
import 'pages/boarding_page.dart';
import 'pages/login_page.dart';
import 'pages/forgot_password.dart';
import 'pages/register_page.dart' as register;
import 'pages/home.dart' as home;
import 'pages/report_page.dart';
import 'pages/chatbot_page.dart';
import 'pages/guide_page.dart';
import 'pages/notify_page.dart';
import 'pages/profile_page.dart';
import 'pages/riwayat_page.dart';

// Theme
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Speak App',
      theme: AppTheme.lightTheme,
      initialRoute: '/boarding',
      routes: {
        '/splash': (context) => const SplashPage(),
        '/boarding': (context) => const BoardingPage(),
        '/login': (context) => LoginPage(),
        '/register': (context) => const register.RegisterPage(),
        '/forgot-password': (context) => const ForgotPasswordPage(),
        '/home': (context) => const home.HomePage(),
        '/report': (context) => const ReportPage(),
        '/chatbot': (context) => const ChatbotPage(),
        '/guide': (context) => const GuidePage(),
        '/notify': (context) => NotifyPage(),
        '/profile': (context) => ProfilePage(),
        '/add-report': (context) => AddReportPage(),
        '/resend-verification': (context) => ResendVerificationPage(),
        '/riwayat': (context) => RiwayatPage(),
      },
    );
  }
}