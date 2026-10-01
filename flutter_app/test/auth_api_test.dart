import 'dart:convert';

import 'package:eco_fit/data/remote/auth_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  test('login đọc đúng response envelope của NestJS', () async {
    final client = MockClient((request) async {
      expect(request.url.toString(), 'http://api.test/api/v1/auth/login');
      expect(jsonDecode(request.body), {
        'email': 'minh@example.com',
        'password': 'EcoFit123',
      });
      return http.Response(
        jsonEncode({
          'success': true,
          'data': {
            'accessToken': 'access-token',
            'refreshToken': 'refresh-token',
            'user': {
              'id': 'user-id',
              'email': 'minh@example.com',
              'displayName': 'Minh Anh',
              'role': 'USER',
            },
          },
        }),
        200,
        headers: {'content-type': 'application/json'},
      );
    });
    final api = AuthApi(client: client, baseUrl: 'http://api.test/api/v1/');

    final session = await api.login(
      email: ' Minh@Example.com ',
      password: 'EcoFit123',
    );

    expect(session.accessToken, 'access-token');
    expect(session.refreshToken, 'refresh-token');
    expect(session.user.displayName, 'Minh Anh');
  });

  test('login chuyển lỗi backend thành AuthApiException', () async {
    final client = MockClient(
      (_) async => http.Response.bytes(
        utf8.encode(
          jsonEncode({
            'success': false,
            'error': {
              'code': 'UNAUTHORIZED',
              'message': 'Email hoặc mật khẩu không đúng',
            },
          }),
        ),
        401,
        headers: {'content-type': 'application/json; charset=utf-8'},
      ),
    );
    final api = AuthApi(client: client, baseUrl: 'http://api.test/api/v1');

    expect(
      () => api.login(email: 'minh@example.com', password: 'Wrong123'),
      throwsA(
        isA<AuthApiException>()
            .having((error) => error.statusCode, 'statusCode', 401)
            .having(
              (error) => error.message,
              'message',
              'Email hoặc mật khẩu không đúng',
            ),
      ),
    );
  });
}
