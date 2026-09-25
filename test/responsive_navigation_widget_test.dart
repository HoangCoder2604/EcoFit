import 'package:eco_fit/app/router/app_router.dart';
import 'package:eco_fit/app/router/app_routes.dart';
import 'package:eco_fit/app/state/eco_fit_app_state.dart';
import 'package:eco_fit/screens.dart';
import 'package:eco_fit/theme.dart';
import 'package:eco_fit/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('chọn đúng kiểu điều hướng theo nền tảng và chiều rộng', () {
    expect(
      ecoShellLayoutFor(isWeb: true, width: 390, showNav: true),
      EcoShellLayout.mobileWebDrawer,
    );
    expect(
      ecoShellLayoutFor(isWeb: true, width: 1440, showNav: true),
      EcoShellLayout.desktopSidebar,
    );
    expect(
      ecoShellLayoutFor(isWeb: false, width: 390, showNav: true),
      EcoShellLayout.nativeBottomBar,
    );
  });

  testWidgets('mobile dùng thanh điều hướng dưới', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.binding.setSurfaceSize(const Size(390, 844));
    await tester.pumpWidget(
      MaterialApp(theme: ecoFitTheme, home: const HomeScreen()),
    );
    await tester.pumpAndSettle();

    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.text('KHÔNG GIAN CỦA BẠN'), findsNothing);
    addTearDown(() => tester.binding.setSurfaceSize(null));
  });

  testWidgets('home Android có dashboard đầy đủ và mở được check-in', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final router = AppRouter();
    await tester.binding.setSurfaceSize(const Size(390, 844));
    await tester.pumpWidget(
      MaterialApp(
        theme: ecoFitTheme,
        darkTheme: ecoFitDarkTheme,
        themeMode: ThemeMode.dark,
        home: const HomeScreen(),
        onGenerateRoute: router.onGenerateRoute,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Check-in hôm nay'), findsOneWidget);
    expect(find.text('Dinh dưỡng hôm nay'), findsOneWidget);
    expect(find.text('Chỉ số năng lượng'), findsOneWidget);
    expect(find.text('Lịch trong ngày'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Nhịp sinh hoạt 7 ngày'),
      350,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Nhịp sinh hoạt 7 ngày'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.byKey(const Key('home-check-in-button')),
      -350,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.byKey(const Key('home-check-in-button')));
    await tester.pumpAndSettle();
    expect(find.text('Check-in hằng ngày'), findsOneWidget);
    addTearDown(() => tester.binding.setSurfaceSize(null));
  });

  testWidgets('web dùng sidebar dashboard', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.binding.setSurfaceSize(const Size(1440, 1000));
    await tester.pumpWidget(
      MaterialApp(theme: ecoFitTheme, home: const HomeScreen()),
    );
    await tester.pumpAndSettle();

    expect(find.byType(NavigationBar), findsNothing);
    expect(find.text('KHÔNG GIAN CỦA BẠN'), findsOneWidget);
    expect(find.text('Nhịp sinh hoạt 7 ngày'), findsOneWidget);
    final cardKeys = [
      'desktop-home-card-nutrition',
      'desktop-home-card-energy',
      'desktop-home-card-schedule',
      'desktop-home-card-routine',
    ];
    final sizes = cardKeys
        .map((key) => tester.getSize(find.byKey(ValueKey(key))))
        .toList();
    expect(sizes.toSet(), hasLength(1));
    addTearDown(() => tester.binding.setSurfaceSize(null));
  });

  testWidgets('nhãn cài đặt cá nhân đủ lớn để đọc trên điện thoại', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    await tester.binding.setSurfaceSize(const Size(390, 844));
    await tester.pumpWidget(
      MaterialApp(theme: ecoFitTheme, home: const ProfileScreen()),
    );
    await tester.pumpAndSettle();

    final label = tester.widget<Text>(find.text('Thông tin tài khoản'));
    expect(label.style?.fontSize, greaterThanOrEqualTo(13));
    addTearDown(() => tester.binding.setSurfaceSize(null));
  });

  testWidgets('chat Eco Coach dễ đọc trên màn hình nhỏ và desktop', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    EcoFitAppState.instance.resetForTesting();
    const greeting =
        'Xin chào Minh Anh! 👋 Mình là Eco Coach. Mình có thể gợi ý thực đơn, bài tập phù hợp với mục tiêu, thời gian và ngân sách của bạn.';

    await tester.binding.setSurfaceSize(const Size(390, 844));
    await tester.pumpWidget(
      MaterialApp(theme: ecoFitTheme, home: const AiCoachScreen()),
    );
    await tester.pumpAndSettle();
    expect(
      tester.widget<Text>(find.text(greeting)).style?.fontSize,
      greaterThanOrEqualTo(13),
    );
    expect(tester.takeException(), isNull);

    await tester.binding.setSurfaceSize(const Size(1440, 1000));
    await tester.pumpWidget(
      MaterialApp(theme: ecoFitTheme, home: const AiCoachScreen()),
    );
    await tester.pumpAndSettle();
    expect(find.text(greeting), findsOneWidget);
    expect(tester.takeException(), isNull);
    addTearDown(() => tester.binding.setSurfaceSize(null));
  });

  testWidgets('mục cá nhân mở trang cài đặt thật', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final router = AppRouter();
    await tester.binding.setSurfaceSize(const Size(390, 844));
    await tester.pumpWidget(
      MaterialApp(
        theme: ecoFitTheme,
        initialRoute: AppRoutes.profile,
        onGenerateRoute: router.onGenerateRoute,
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Thông tin tài khoản'));
    await tester.pumpAndSettle();
    expect(find.text('Lưu thông tin'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(2));
    addTearDown(() => tester.binding.setSurfaceSize(null));
  });
}
