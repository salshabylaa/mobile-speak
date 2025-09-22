import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  Future<void> _handleLogout(BuildContext context) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final dio = Dio();
      dio.options.headers['Authorization'] = 'Bearer $token';

      await dio.post('https://apispeak.rynn.fun/auth/logout');
      await prefs.remove('token');

      // Pindah ke halaman boarding dan hapus semua route sebelumnya
      Navigator.pushNamedAndRemoveUntil(context, '/boarding', (route) => false);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal logout. Silakan coba lagi.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFAC1754);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Saya'),
        backgroundColor: primaryColor,
      ),
      body: Column(
        children: [
          const SizedBox(height: 30),
          const CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage('assets/profile.jpg'),
          ),
          const SizedBox(height: 16),
          const Text(
            'Nama Pengguna',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Text('user@email.com'),
          const SizedBox(height: 30),
          ListTile(
            leading: const Icon(Icons.edit, color: primaryColor),
            title: const Text('Edit Profil'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.lock, color: primaryColor),
            title: const Text('Ubah Kata Sandi'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: primaryColor),
            title: const Text('Keluar'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              _handleLogout(context);
            },
          ),
        ],
      ),
    );
  }
}