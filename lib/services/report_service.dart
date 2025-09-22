import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path/path.dart';
import '../models/report.dart';
import 'auth_service.dart';

class ReportService {
  final Dio _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 15),
  ));

  final String _base = 'http://apispeak.rynn.fun';
  final AuthService _auth = AuthService();

  Future<Options> _authHeaders({Map<String, String>? extraHeaders}) async {
    final token = await _auth.getAuthToken();
    if (token == null) throw Exception('No authentication token found.');

    return Options(headers: {
      'Authorization': 'Bearer $token',
      ...?extraHeaders,
    });
  }

  Future<Report> createReport({
    required String title,
    required String description,
    required DateTime date,
    File? proofFile,
  }) async {
    try {
      final form = FormData.fromMap({
        'title': title,
        'description': description,
        'date': date.toIso8601String(),
        if (proofFile != null && proofFile.path.isNotEmpty)
          'proof': await MultipartFile.fromFile(
            proofFile.path,
            filename: basename(proofFile.path),
          ),
      });

      final response = await _dio.post(
        '$_base/reports',
        data: form,
        options: await _authHeaders(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Report.fromJson({'data': response.data['data']});
      } else {
        throw Exception('Failed to send report: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      final msg = e.response?.data ?? e.message;
      throw Exception('DioException while creating report: $msg');
    } catch (e) {
      throw Exception('Error while creating report: $e');
    }
  }

  Future<List<Report>> getReports() async {
    try {
      final response = await _dio.get(
        '$_base/reports',
        options: await _authHeaders(),
      );

      if (response.statusCode == 200) {
        final List data = response.data['data'] as List;
        return data.map((json) => Report.fromJson({'data': json})).toList();
      } else {
        throw Exception('Failed to fetch reports');
      }
    } on DioException catch (e) {
      final msg = e.response?.data ?? e.message;
      throw Exception('DioException while fetching reports: $msg');
    } catch (e) {
      throw Exception('Error while fetching reports: $e');
    }
  }

  Future<Report> getReportDetail(String code) async {
    try {
      final response = await _dio.get(
        '$_base/reports/$code',
        options: await _authHeaders(),
      );

      if (response.statusCode == 200) {
        return Report.fromJson({'data': response.data['data']});
      } else {
        throw Exception('Failed to fetch report detail');
      }
    } on DioException catch (e) {
      final msg = e.response?.data ?? e.message;
      throw Exception('DioException while fetching report detail: $msg');
    } catch (e) {
      throw Exception('Error while fetching report detail: $e');
    }
  }

  Future<void> deleteReport(String code) async {
    try {
      final response = await _dio.delete(
        '$_base/reports/$code',
        options: await _authHeaders(),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to delete report');
      }
    } on DioException catch (e) {
      final msg = e.response?.data ?? e.message;
      throw Exception('DioException while deleting report: $msg');
    } catch (e) {
      throw Exception('Error while deleting report: $e');
    }
  }

  Future<void> updateReportStatus(String code, String newStatus) async {
    try {
      final response = await _dio.patch(
        '$_base/reports/$code/status',
        data: {'status': newStatus},
        options: await _authHeaders(),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update report status');
      }
    } on DioException catch (e) {
      final msg = e.response?.data ?? e.message;
      throw Exception('DioException while updating report status: $msg');
    } catch (e) {
      throw Exception('Error while updating report status: $e');
    }
  }
}
