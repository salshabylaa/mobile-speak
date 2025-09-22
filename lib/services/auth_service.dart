import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final Dio _dio = Dio();
  final String baseUrl = 'http://apispeak.rynn.fun';

  Future<Response> register(String name, String email, String password) async {
    try {
      final response = await _dio.post(
        '$baseUrl/auth/register',
        data: {
          'name': name,
          'email': email,
          'password': password,
        },
      );
      return response;
    } on DioException catch (e) {
      log(e.response.toString());
      rethrow;
    }
  }

  Future<Response> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '$baseUrl/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );
      log(response.toString());
      if (response.statusCode == 200) {
        final token = response.data['data']['token'];
        log(token.toString());
        if (token != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_token', token);
        }
      }
      return response;
    } on DioException catch (e) {
      log(e.response.toString());
      rethrow;
    }
  }

  Future<Response> resendVerification(String email) async {
    try {
      final response = await _dio.post(
        '$baseUrl/auth/resend-verification',
        data: {'email': email},
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> verifyEmail(String token) async {
    try {
      final response = await _dio.get(
        '$baseUrl/auth/verify-email',
        queryParameters: {'token': token},
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> validateSuccessToken(String token) async {
    try {
      final response = await _dio.get(
        '$baseUrl/auth/validate-success-token',
        queryParameters: {'token': token},
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> verifyStatus() async {
    final token = await getAuthToken();
    try {
      final response = await _dio.get(
        '$baseUrl/auth/verify',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> logout() async {
    final token = await getAuthToken();
    try {
      final response = await _dio.post(
        '$baseUrl/auth/logout',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('auth_token');
      }
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<String?> getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }
}
