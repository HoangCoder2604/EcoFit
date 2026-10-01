import 'dart:convert';

import 'package:eco_fit/app/router/app_routes.dart';
import 'package:eco_fit/app/state/eco_fit_app_state.dart';
import 'package:eco_fit/data/remote/auth_api.dart';
import 'package:eco_fit/screens.dart';
import 'package:eco_fit/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  AuthApi successfulApi() => AuthApi(
    baseUrl: 'http://api.test/api/v1',
    client: MockClient(
      (_) async => http.Response(
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
      ),
    ),
  );

  Future<void> pumpLogin(WidgetTester tester, Size size) async {
    await tester.binding.setSurfaceSize(size);
    await tester.pumpWidget(
      MaterialApp(
        theme: ecoFitTheme,
        home: const LoginScreen(),
        routes: {
          AppRoutes.home: (_) =>
              const Scaffold(body: Text('AUTHENTICATED_HOME')),
        },
      ),
    );
    await tester.pumpAndSettle();
  }

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    EcoFitAppState.instance.resetForTesting();
  });

  tearDown(() {
    EcoFitAppState.instance.resetForTesting();
  });

  testWidgets('mobile không cho đăng nhập khi để trống', (tester) async {
    await pumpLogin(tester, const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.tap(find.byKey(const Key('auth-submit')));
    await tester.pump();

    expect(find.text('Vui lòng nhập email'), findsOneWidget);
    expect(find.text('Vui lòng nhập mật khẩu'), findsOneWidget);
    expect(find.text('AUTHENTICATED_HOME'), findsNothing);
  });

  testWidgets('desktop không cho đăng nhập khi để trống', (tester) async {
    await pumpLogin(tester, const Size(1440, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.tap(find.byKey(const Key('auth-submit')));
    await tester.pump();

    expect(find.text('Vui lòng nhập email'), findsOneWidget);
    expect(find.text('Vui lòng nhập mật khẩu'), findsOneWidget);
    expect(find.text('AUTHENTICATED_HOME'), findsNothing);
  });

  testWidgets('mặc định duy trì đăng nhập để refresh không mất phiên', (
    tester,
  ) async {
    await pumpLogin(tester, const Size(1440, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    expect(tester.widget<Checkbox>(find.byType(Checkbox)).value, isTrue);
  });

  testWidgets('chỉ vào Home sau khi API trả token hợp lệ', (tester) async {
    final state = EcoFitAppState.instance;
    state.setAuthApiForTesting(successfulApi());
    await pumpLogin(tester, const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.enterText(
      find.byKey(const Key('auth-email')),
      'minh@example.com',
    );
    await tester.enterText(find.byKey(const Key('auth-password')), 'EcoFit123');
    await tester.tap(find.byKey(const Key('auth-submit')));
    await tester.pumpAndSettle();

    expect(find.text('AUTHENTICATED_HOME'), findsOneWidget);
    expect(state.isAuthenticated, isTrue);
    final preferences = await SharedPreferences.getInstance();
    expect(preferences.getString('auth.accessToken'), 'access-token');
    expect(preferences.getString('auth.refreshToken'), 'refresh-token');
  });

  testWidgets('hiển thị lỗi API thay vì vào Home', (tester) async {
    EcoFitAppState.instance.setAuthApiForTesting(
      AuthApi(
        baseUrl: 'http://api.test/api/v1',
        client: MockClient(
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
        ),
      ),
    );
    await pumpLogin(tester, const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.enterText(
      find.byKey(const Key('auth-email')),
      'minh@example.com',
    );
    await tester.enterText(find.byKey(const Key('auth-password')), 'Wrong123');
    await tester.tap(find.byKey(const Key('auth-submit')));
    await tester.pumpAndSettle();

    expect(find.text('Email hoặc mật khẩu không đúng'), findsOneWidget);
    expect(find.text('AUTHENTICATED_HOME'), findsNothing);
  });

  testWidgets('đăng ký phải xác minh email trước khi vào Home', (tester) async {
    EcoFitAppState.instance.setAuthApiForTesting(
      AuthApi(
        baseUrl: 'http://api.test/api/v1',
        client: MockClient((request) async {
          if (request.url.path.endsWith('/auth/register')) {
            return http.Response(
              jsonEncode({
                'success': true,
                'data': {
                  'verificationRequired': true,
                  'email': 'new@example.com',
                  'expiresAt': '2026-09-25T15:00:00.000Z',
                  'developmentCode': '123456',
                },
              }),
              201,
            );
          }
          return http.Response(
            jsonEncode({
              'success': true,
              'data': {
                'accessToken': 'verified-access',
                'refreshToken': 'verified-refresh',
                'user': {
                  'id': 'new-user',
                  'email': 'new@example.com',
                  'displayName': 'New User',
                  'role': 'USER',
                },
              },
            }),
            200,
          );
        }),
      ),
    );
    await pumpLogin(tester, const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.tap(find.text('Tạo tài khoản'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('auth-display-name')),
      'New User',
    );
    await tester.enterText(
      find.byKey(const Key('auth-email')),
      'new@example.com',
    );
    await tester.enterText(find.byKey(const Key('auth-password')), 'EcoFit123');
    await tester.tap(find.byKey(const Key('auth-submit')));
    await tester.pumpAndSettle();

    expect(find.text('Xác minh email'), findsOneWidget);
    expect(find.text('AUTHENTICATED_HOME'), findsNothing);
    expect(
      tester
          .widget<TextField>(find.byKey(const Key('auth-verification-code')))
          .controller!
          .text,
      '123456',
    );

    await tester.tap(find.byKey(const Key('auth-verify-submit')));
    await tester.pumpAndSettle();
    expect(find.text('AUTHENTICATED_HOME'), findsOneWidget);
  });
}
