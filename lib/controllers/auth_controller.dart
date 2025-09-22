import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:Speak_project/services/auth_service.dart';

class AuthController {
  final AuthService authService;

  AuthController({required this.authService});

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await authService.login(email, password);
      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': response.data,
        };
      } else {
        return {
          'success': false,
          'message': response.data['message'] ?? 'Login failed',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Login error: $e',
      };
    }
  }

  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await authService.register(name, email, password);
      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'Registration successful',
          'data': response.data,
        };
      } else {
        return {
          'success': false,
          'message': response.data['message'] ?? 'Registration failed',
        };
      }
    } catch (e) {
      log(e.toString());
      return {
        'success': false,
        'message': 'Registration error: $e',
      };
    }
  }

  Future<void> resendVerification({
    required BuildContext context,
    required String email,
  }) async {
    try {
      final response = await authService.resendVerification(email);
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Verification email sent')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to resend verification: ${response.data}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Resend error: $e')),
      );
    }
  }

  Future<void> logout() async {
    try {
      final response = await authService.logout();
      if (response.statusCode == 200) {
        debugPrint('Logout success');
      } else {
        debugPrint('Logout failed: ${response.data}');
      }
    } catch (e) {
      debugPrint('Logout error: $e');
    }
  }

  Future<void> verifyEmail(String token) async {
    try {
      final response = await authService.verifyEmail(token);
      debugPrint('Verify email: ${response.data}');
    } catch (e) {
      debugPrint('Verify email error: $e');
    }
  }

  Future<void> validateSuccessToken(String token) async {
    try {
      final response = await authService.validateSuccessToken(token);
      debugPrint('Validate token success: ${response.data}');
    } catch (e) {
      debugPrint('Validate token error: $e');
    }
  }

  Future<void> verifyStatus() async {
    try {
      final response = await authService.verifyStatus();
      debugPrint('Auth status: ${response.data}');
    } catch (e) {
      debugPrint('Verify status error: $e');
    }
  }
}
