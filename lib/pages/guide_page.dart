import 'package:flutter/material.dart';

class GuidePage extends StatelessWidget {
  const GuidePage({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFAC1754);

    final List<Map<String, dynamic>> steps = [
      {
        'icon': Icons.edit_note,
        'title': 'Isi Formulir',
        'desc': 'Lengkapi data diri dan kronologi kejadian dengan jujur dan lengkap.',
      },
      {
        'icon': Icons.upload_file,
        'title': 'Unggah Bukti',
        'desc': 'Sertakan bukti pendukung seperti foto, video, atau dokumen terkait.',
      },
      {
        'icon': Icons.verified,
        'title': 'Proses Verifikasi',
        'desc': 'Tim kami akan memverifikasi laporan Anda secara rahasia dan profesional.',
      },
      {
        'icon': Icons.mark_email_read,
        'title': 'Tindak Lanjut',
        'desc': 'Anda akan mendapat notifikasi jika laporan diterima atau membutuhkan info tambahan.',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Panduan Pengaduan'),
        backgroundColor: primaryColor,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Langkah-langkah Pengaduan',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ...steps.map((step) {
            return Card(
              elevation: 3,
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: primaryColor.withOpacity(0.1),
                      child: Icon(step['icon'], color: primaryColor, size: 28),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            step['title'],
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(height: 6),
                          Text(step['desc']),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'Semua laporan akan diproses secara rahasia dan aman oleh tim profesional kami. Jangan ragu untuk melaporkan tindakan yang tidak pantas.',
              style: TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
