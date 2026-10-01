import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class AuthUser {
  const AuthUser({
    required this.id,
    required this.email,
    required this.displayName,
    required this.role,
  });

  final String id;
  final String email;
  final String displayName;
  final String role;

  factory AuthUser.fromJson(Map<String, dynamic> json) => AuthUser(
    id: json['id'] as String,
    email: json['email'] as String,
    displayName: json['displayName'] as String,
    role: json['role'] as String,
  );
}

class AuthSession {
  const AuthSession({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  final String accessToken;
  final String refreshToken;
  final AuthUser user;

  factory AuthSession.fromJson(Map<String, dynamic> json) => AuthSession(
    accessToken: json['accessToken'] as String,
    refreshToken: json['refreshToken'] as String,
    user: AuthUser.fromJson(json['user'] as Map<String, dynamic>),
  );
}

class EmailVerificationChallenge {
  const EmailVerificationChallenge({
    required this.email,
    required this.expiresAt,
    this.developmentCode,
  });

  final String email;
  final DateTime expiresAt;
  final String? developmentCode;

  factory EmailVerificationChallenge.fromJson(Map<String, dynamic> json) =>
      EmailVerificationChallenge(
        email: json['email'] as String,
        expiresAt: DateTime.parse(json['expiresAt'] as String),
        developmentCode: json['developmentCode'] as String?,
      );
}

class AuthApiException implements Exception {
  const AuthApiException(this.message, {this.statusCode, this.code});

  final String message;
  final int? statusCode;
  final String? code;

  @override
  String toString() => message;
}

class AuthApi {
  AuthApi({http.Client? client, String? baseUrl})
    : _client = client ?? http.Client(),
      baseUrl = (baseUrl ?? defaultBaseUrl()).replaceFirst(RegExp(r'/$'), '');

  final http.Client _client;
  final String baseUrl;

  static const _configuredBaseUrl = String.fromEnvironment('API_BASE_URL');

  static String defaultBaseUrl() {
    if (_configuredBaseUrl.isNotEmpty) return _configuredBaseUrl;
    if (kIsWeb) {
      final page = Uri.base;
      if (page.host == 'localhost' || page.host == '127.0.0.1') {
        return '${page.scheme}://${page.host}:3000/api/v1';
      }
      return '${page.origin}/api/v1';
    }
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:3000/api/v1';
    }
    return 'http://127.0.0.1:3000/api/v1';
  }

  Future<AuthSession> login({
    required String email,
    required String password,
  }) async {
    final data = await _post('/auth/login', {
      'email': email.trim().toLowerCase(),
      'password': password,
    });
    return AuthSession.fromJson(data);
  }

  Future<EmailVerificationChallenge> register({
    required String email,
    required String displayName,
    required String password,
  }) async {
    final data = await _post('/auth/register', {
      'email': email.trim().toLowerCase(),
      'displayName': displayName.trim(),
      'password': password,
    });
    return EmailVerificationChallenge.fromJson(data);
  }

  Future<AuthSession> verifyEmail({
    required String email,
    required String code,
  }) async {
    final data = await _post('/auth/email/verify', {
      'email': email.trim().toLowerCase(),
      'code': code.trim(),
    });
    return AuthSession.fromJson(data);
  }

  Future<EmailVerificationChallenge?> resendVerification(String email) async {
    final data = await _post('/auth/email/resend', {
      'email': email.trim().toLowerCase(),
    });
    return data['verificationRequired'] == true
        ? EmailVerificationChallenge.fromJson(data)
        : null;
  }

  Future<AuthSession> loginWithGoogle(String idToken) async {
    final data = await _post('/auth/google', {'idToken': idToken});
    return AuthSession.fromJson(data);
  }

  Future<AuthSession> refresh(String refreshToken) async {
    final data = await _post('/auth/refresh', {'refreshToken': refreshToken});
    return AuthSession.fromJson(data);
  }

  Future<AuthUser> me(String accessToken) async {
    final data = await _request(
      'GET',
      '/auth/me',
      headers: {'Authorization': 'Bearer $accessToken'},
    );
    return AuthUser.fromJson(data);
  }

  Future<void> logout(String refreshToken) async {
    await _post('/auth/logout', {'refreshToken': refreshToken});
  }

  Future<Map<String, dynamic>> _post(String path, Map<String, dynamic> body) =>
      _request('POST', path, body: body);

  Future<Map<String, dynamic>> _request(
    String method,
    String path, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$path');
      final requestHeaders = <String, String>{
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        ...?headers,
      };
      final response = method == 'GET'
          ? await _client
                .get(uri, headers: requestHeaders)
                .timeout(const Duration(seconds: 15))
          : await _client
                .post(uri, headers: requestHeaders, body: jsonEncode(body))
                .timeout(const Duration(seconds: 15));
      final decoded = jsonDecode(utf8.decode(response.bodyBytes));
      if (decoded is! Map<String, dynamic>) {
        throw const AuthApiException('Phản hồi từ máy chủ không hợp lệ');
      }
      if (response.statusCode < 200 || response.statusCode >= 300) {
        final error = decoded['error'];
        final details = error is Map<String, dynamic> ? error : null;
        throw AuthApiException(
          details?['message'] as String? ?? 'Không thể xác thực tài khoản',
          statusCode: response.statusCode,
          code: details?['code'] as String?,
        );
      }
      final data = decoded['data'];
      if (data is! Map<String, dynamic>) {
        throw const AuthApiException('Phản hồi từ máy chủ thiếu dữ liệu');
      }
      return data;
    } on TimeoutException {
      throw const AuthApiException(
        'Máy chủ phản hồi quá lâu. Vui lòng thử lại.',
      );
    } on http.ClientException {
      throw const AuthApiException(
        'Không thể kết nối máy chủ Eco Fit. Hãy kiểm tra backend và mạng.',
      );
    } on FormatException {
      throw const AuthApiException('Phản hồi từ máy chủ không hợp lệ');
    }
  }
}
