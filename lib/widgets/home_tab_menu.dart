import 'package:flutter/material.dart';

class HomeTabMenu extends StatelessWidget {
  const HomeTabMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFCC1550);

    final List<Map<String, dynamic>> tabs = [
      { "icon": Icons.list_alt, "text": "Semua" },
      { "icon": Icons.visibility, "text": "Ditinjau" },
      { "icon": Icons.check_circle, "text": "Diterima" },
      { "icon": Icons.cancel, "text": "Ditolak" },
      { "icon": Icons.verified, "text": "Selesai" },
    ];

    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: tabs.length,
        separatorBuilder: (context, _) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final tab = tabs[index];
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(12),
                child: Icon(tab['icon'], color: primaryColor, size: 28),
              ),
              const SizedBox(height: 8),
              Text(
                tab['text'],
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
