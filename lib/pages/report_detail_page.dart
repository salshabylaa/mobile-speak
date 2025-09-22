import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:open_file/open_file.dart';
import '../models/report.dart';
import '../services/report_service.dart';

class ReportDetailPage extends StatefulWidget {
  final Report report;

  const ReportDetailPage({Key? key, required this.report}) : super(key: key);

  @override
  State<ReportDetailPage> createState() => _ReportDetailPageState();
}

class _ReportDetailPageState extends State<ReportDetailPage> {
  late Report _report;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchDetail();
  }

  Future<void> _fetchDetail() async {
    try {
      final fresh = await ReportService().getReportDetail(widget.report.code);
      setState(() {
        _report = fresh;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat detail: $e')),
      );
    }
  }

  bool _isImage(String path) {
    final ext = p.extension(path).toLowerCase();
    return ['.jpg', '.jpeg', '.png', '.gif', '.bmp', '.webp'].contains(ext);
  }

  Widget _buildProofWidget() {
    final proof = _report.proof;

    log(proof.toString());

    if (proof == null || proof.isEmpty) {
      return Container(
        height: 200,
        color: Colors.grey[200],
        child: const Center(child: Icon(Icons.image_not_supported, size: 50)),
      );
    }

    return Image.network('https://apispeak.rynn.fun/images/${proof}', height: 200, width: double.infinity, fit: BoxFit.cover);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Icon(Icons.insert_drive_file, size: 40, color: Colors.grey),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              p.basename(proof),
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          TextButton(
            onPressed: () => OpenFile.open(proof),
            child: const Text("Buka"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFAC1754);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Pengaduan'),
        backgroundColor: primaryColor,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: _buildProofWidget(),
                ),
                const SizedBox(height: 16),
                Text(
                  _report.title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const SizedBox(height: 8),
                Text('Tanggal: ${_report.date.toLocal().toString().split(' ')[0]}'),
                const SizedBox(height: 4),
                Text('Status: ${_report.status}'),
                const SizedBox(height: 16),
                const Text(
                  'Deskripsi',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(_report.description),
              ],
            ),
    );
  }
}
