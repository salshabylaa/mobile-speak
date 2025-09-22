import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/report.dart';
import '../services/report_service.dart';
import 'add_report_page.dart';
import 'report_detail_page.dart';

class ReportPage extends StatefulWidget {
  final int initialTabIndex;
  const ReportPage({Key? key, this.initialTabIndex = 0}) : super(key: key);

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<String> statusList = ['Semua', 'Diproses', 'Konsultasi', 'Selesai'];

  List<Report> reports = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: statusList.length,
      vsync: this,
      initialIndex: widget.initialTabIndex,
    );
    _loadReports();
  }

  Future<void> _loadReports() async {
    setState(() => isLoading = true);
    try {
      final fetchedReports = await ReportService().getReports();
      setState(() => reports = fetchedReports);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat laporan: $e')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  List<Report> getFilteredReports(String status) {
    if (status == 'Semua') return reports;
    if (status == 'Diproses') return reports.where((r) => r.status == 'process').toList();
    if (status == 'Konsultasi') return reports.where((r) => r.status == 'counseling').toList();
    if (status == 'Selesai') return reports.where((r) => r.status == 'closed').toList();
    return reports;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFAC1754);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaduan Saya'),
        backgroundColor: primaryColor,
        bottom: TabBar(
          controller: _tabController,
          tabs: statusList.map((e) => Tab(text: e)).toList(),
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          isScrollable: true,
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: statusList.map((status) {
                final filtered = getFilteredReports(status);
                if (filtered.isEmpty) {
                  return const Center(child: Text('Belum ada laporan'));
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(12.0),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final report = filtered[index];
                    final isImage = report.proof != null &&
                        (report.proof!.endsWith('.jpg') ||
                         report.proof!.endsWith('.jpeg') ||
                         report.proof!.endsWith('.png'));

                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                width: 80,
                                height: 80,
                                color: Colors.grey[200],
                                child: report.proof == null
                                    ? const Icon(Icons.image_not_supported)
                                    : isImage
                                        ? Image.network(
                                            'https://apispeak.rynn.fun/images/${report!.proof}',
                                            width: 80,
                                            height: 80,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) {
                                              return const Icon(Icons.broken_image);
                                            },
                                          )
                                        : const Icon(Icons.insert_drive_file),
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Gunakan Flexible agar tidak overflow
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    report.title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Tanggal: ${DateFormat('dd MMM yyyy').format(report.date)}',
                                    softWrap: true,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Status: ${report.status}',
                                    softWrap: true,
                                  ),
                                  const SizedBox(height: 12),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                        foregroundColor: primaryColor,
                                      ),
                                      onPressed: () async {
                                        final updated = await Navigator.push<Report>(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => ReportDetailPage(report: report),
                                          ),
                                        );
                                        if (updated != null) {
                                          setState(() {
                                            final index = reports.indexWhere(
                                                (r) => r.code == updated.code);
                                            if (index != -1) reports[index] = updated;
                                          });
                                        }
                                      },
                                      child: const Text('Lihat Detail'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newReport = await Navigator.push<Report>(
            context,
            MaterialPageRoute(builder: (_) => const AddReportPage()),
          );

          if (newReport != null) {
            await _loadReports();
            final statusIndex = statusList.indexOf(newReport.status);
            if (statusIndex != -1) {
              _tabController.index = statusIndex;
            }
          }
        },
        backgroundColor: primaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }
}