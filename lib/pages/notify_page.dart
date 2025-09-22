import 'package:flutter/material.dart';

class NotifyPage extends StatelessWidget {
  const NotifyPage({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFAC1754);

    final List<Map<String, dynamic>> notifications = [
      {
        'title': 'Laporan Diterima',
        'message': 'Laporan Anda telah diterima dan sedang dalam proses verifikasi.',
        'time': '2 jam lalu',
      },
      {
        'title': 'Laporan Ditinjau',
        'message': 'Tim kami sedang mempelajari laporan Anda.',
        'time': 'Kemarin',
      },
      {
        'title': 'Formulir Belum Lengkap',
        'message': 'Mohon lengkapi kronologi kejadian agar bisa diproses.',
        'time': '3 hari lalu',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifikasi'),
        backgroundColor: primaryColor,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: notifications.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final notif = notifications[index];
          return ListTile(
            tileColor: Colors.grey[100],
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            leading: const Icon(Icons.notifications, color: primaryColor),
            title: Text(
              notif['title'],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(notif['message']),
            trailing: Text(
              notif['time'],
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          );
        },
      ),
    );
  }
}
