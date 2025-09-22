import 'dart:io';
import 'package:flutter/material.dart';
import '../services/report_service.dart';

class ReportController {
  final ReportService _svc = ReportService();

  Future<void> createReport(
    Map<String, dynamic> data,
    BuildContext context,
  ) async {
    try {
      final title = data['title'] as String;
      final description = data['description'] as String;
      final date = DateTime.parse(data['date'] as String);
      final proofFile = data['proof'] as File;

      await _svc.createReport(
        title: title,
        description: description,
        date: date,
        proofFile: proofFile,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Laporan berhasil dikirim')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  Future<List> getReports() async {
    try {
      return await _svc.getReports();
    } catch (e) {
      throw Exception('Error getting reports: $e');
    }
  }

  Future<dynamic> getReportDetail(String code) async {
    try {
      return await _svc.getReportDetail(code);
    } catch (e) {
      throw Exception('Error getting report detail: $e');
    }
  }

  Future<void> deleteReport(String code, BuildContext context) async {
    try {
      await _svc.deleteReport(code);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Laporan berhasil dihapus')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  Future<void> updateReportStatus(String code, String newStatus, BuildContext context) async {
    try {
      await _svc.updateReportStatus(code, newStatus);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Status laporan berhasil diubah')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }
}
