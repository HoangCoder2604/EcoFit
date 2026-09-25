import 'package:eco_fit/screens.dart';
import 'package:eco_fit/theme.dart';
import 'package:eco_fit/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> pumpDesktop(WidgetTester tester, Widget home) async {
    await tester.binding.setSurfaceSize(const Size(1440, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        theme: ecoFitTheme,
        darkTheme: ecoFitDarkTheme,
        themeMode: ThemeMode.dark,
        home: home,
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  }

  testWidgets('trang mở đầu dùng hero hai cột trên web', (tester) async {
    await pumpDesktop(tester, const SplashScreen());

    expect(find.textContaining('Sức khỏe tốt hơn'), findsOneWidget);
    expect(find.byType(EcoCard), findsOneWidget);
    expect(
      tester.getSize(find.byType(FilledButton)).width,
      lessThanOrEqualTo(260),
    );
  });

  testWidgets('onboarding giới hạn card tính năng trên web', (tester) async {
    await pumpDesktop(tester, const FoodOnboardingScreen());

    expect(find.text('Eco Fit đồng hành cùng bạn'), findsOneWidget);
    final featureTitle = find.text('Gợi ý bữa ăn theo mục tiêu');
    expect(featureTitle, findsOneWidget);
    expect(tester.getSize(featureTitle).width, lessThan(500));
  });

  testWidgets('đăng nhập dùng panel trung tâm thay vì form toàn màn hình', (
    tester,
  ) async {
    await pumpDesktop(tester, const LoginScreen());

    expect(find.text('Chào mừng bạn trở lại'), findsOneWidget);
    final emailField = find.byType(TextField).first;
    expect(tester.getSize(emailField).width, lessThan(600));
    expect(find.textContaining('Chăm sức khỏe'), findsOneWidget);
  });
}
