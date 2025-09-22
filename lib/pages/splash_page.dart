import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _progress = 0;
  final Color progressColor = const Color(0xFFC2185B); // warna loading dan teks

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _controller.forward();
    _startLoading();
  }

  Future<void> _startLoading() async {
    const totalDuration = 3000; // 3 detik
    const updateInterval = 30; // setiap 30 ms
    final totalSteps = totalDuration ~/ updateInterval;

    for (int i = 1; i <= totalSteps; i++) {
      await Future.delayed(const Duration(milliseconds: updateInterval));
      setState(() {
        _progress = (i / totalSteps) * 100;
      });
    }

    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    final hasBoarded = prefs.getBool('hasBoarded') ?? false;

    if (!mounted) return;

    if (!hasBoarded) {
      Navigator.pushReplacementNamed(context, '/boarding');
    } else if (!isLoggedIn) {
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF1F7),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _animation.value * 20),
                    child: Image.asset(
                      'assets/logo.png',
                      width: 200,
                      height: 200,
                      fit: BoxFit.contain,
                    ),
                  );
                },
              ),
              const SizedBox(height: 40),
              LinearProgressIndicator(
                value: _progress / 100,
                color: progressColor,
                backgroundColor: progressColor.withOpacity(0.3),
                minHeight: 10,
              ),
              const SizedBox(height: 20),
              Text(
                '${_progress.toInt()}%',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: progressColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
