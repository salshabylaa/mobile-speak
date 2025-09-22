import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFCC1550);

    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0,
      child: SizedBox(
        height: 65, // Berikan tinggi yang cukup
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                _buildNavItem(
                  context,
                  icon: Icons.home,
                  label: 'Beranda',
                  color: primaryColor,
                  route: '/home',
                ),
                _buildNavItem(
                  context,
                  icon: Icons.chat,
                  label: 'Chatbot AI',
                  color: Colors.grey,
                  route: '/chatbot',
                ),
              ],
            ),
            Row(
              children: [
                _buildNavItem(
                  context,
                  icon: Icons.notifications,
                  label: 'Notifikasi',
                  color: Colors.grey,
                  route: '/notify',
                ),
                _buildNavItem(
                  context,
                  icon: Icons.receipt_long,
                  label: 'Riwayat',
                  color: Colors.grey,
                  route: '/riwayat',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required String route,
  }) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(color: color, fontSize: 11)),
          ],
        ),
      ),
    );
  }
}
