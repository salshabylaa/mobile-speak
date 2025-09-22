import 'package:flutter/material.dart';

class HeaderReport extends StatelessWidget implements PreferredSizeWidget {
  final bool isLoggedIn;
  final Color primaryColor;
  final VoidCallback onNotificationTap;
  final VoidCallback onProfileTap;
  final VoidCallback onLoginTap;

  const HeaderReport({
    super.key,
    required this.isLoggedIn,
    required this.primaryColor,
    required this.onNotificationTap,
    required this.onProfileTap,
    required this.onLoginTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: Image.asset(
          'assets/logo.png', // Ganti dengan logo kamu
          height: 32,
        ),
      ),
      title: const Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: 'Spe',
              style: TextStyle(color: Colors.black),
            ),
            TextSpan(
              text: 'ak',
              style: TextStyle(color: Color(0xFFCC1550)),
            ),
          ],
        ),
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
      ),
      actions: isLoggedIn
          ? [
              IconButton(
                icon: Icon(Icons.notifications_none, color: primaryColor, size: 22),
                onPressed: onNotificationTap,
              ),
              GestureDetector(
                onTap: onProfileTap,
                child: Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: CircleAvatar(
                    radius: 16,
                    backgroundImage: AssetImage('assets/user.png'),
                  ),
                ),
              ),
            ]
          : [
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                  ),
                  onPressed: onLoginTap,
                  child: const Text('Login'),
                ),
              ),
            ],
    );
  }
}
