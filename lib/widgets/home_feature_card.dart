import 'package:flutter/material.dart';

class HomeFeatureCard extends StatelessWidget {
  final String title;
  final String description;
  final String imageAsset;
  final String route;
  final Color primaryColor;

  const HomeFeatureCard({
    Key? key,
    required this.title,
    required this.description,
    required this.imageAsset,
    required this.route,
    this.primaryColor = const Color(0xFFCC1550),
  }) : super(key: key);

  void handleCardTap(BuildContext context) {
    Navigator.pushNamed(context, route);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => handleCardTap(context),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            // Gambar fitur
            Container(
              height: 160,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFFFEEF1),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Center(
                child: Image.asset(
                  imageAsset,
                  height: 100,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            // Judul dan deskripsi
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.featured_play_list, color: primaryColor),
                  const SizedBox(width: 8),
                  Expanded( // Penting untuk mencegah overflow
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
