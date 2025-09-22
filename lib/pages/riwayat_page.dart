import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/report_service.dart';
import '../models/report.dart';

class RiwayatPage extends StatefulWidget {
  final String? searchQuery;

  const RiwayatPage({super.key, this.searchQuery});

  @override
  State<RiwayatPage> createState() => _RiwayatPageState();
}

class _RiwayatPageState extends State<RiwayatPage> {
  List<Report> allReports = []; 
  List<Report> filteredReports = []; 
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchReports();
  }

  Future<void> fetchReports() async {
    try {
      final data = await ReportService().getReports();
      setState(() {
        allReports = data; 
        if (widget.searchQuery != null && widget.searchQuery!.isNotEmpty) {
          filteredReports = allReports.where((report) {
            final titleLower = report.title.toLowerCase();
            final searchLower = widget.searchQuery!.toLowerCase();
            // final reporterLower = report.reporterName.toLowerCase();
            return titleLower.contains(searchLower);
          }).toList();
        } else {
          filteredReports = allReports;
        }
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengambil data: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Laporan'),
        backgroundColor: const Color(0xFFCC1550),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : filteredReports.isEmpty
              ? const Center(child: Text('Belum ada laporan'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredReports.length,
                  itemBuilder: (context, index) {
                    final r = filteredReports[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              r.title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(DateFormat('dd MMM yyyy').format(r.date)),
                            const SizedBox(height: 4),
                            Text('Status: ${r.status}'),
                            const SizedBox(height: 4),
                            Text('Pelapor: ${r.reporterName}'),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
