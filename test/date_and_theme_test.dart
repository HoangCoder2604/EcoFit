import 'package:eco_fit/app/eco_fit_app.dart';
import 'package:eco_fit/app/state/eco_fit_app_state.dart';
import 'package:eco_fit/screens.dart';
import 'package:eco_fit/theme.dart';
import 'package:eco_fit/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('hiển thị đúng thứ theo ngày hiện tại', () {
    final date = DateTime(2026, 9, 24);
    expect(currentDateLabel(now: date), 'THỨ NĂM, 24 THÁNG 9');
    expect(
      currentDateLabel(language: 'en', now: date),
      'THURSDAY, SEPTEMBER 24',
    );
  });

  test('tính đúng tuần hiện tại từ thứ Hai đến Chủ nhật', () {
    final friday = DateTime(2026, 9, 25);
    expect(startOfWeek(friday), DateTime(2026, 9, 21));
    expect(weekRangeLabel(friday, now: friday), 'Tuần này · 21/9 - 27/9');
    expect(
      weekRangeLabel(friday, language: 'en', now: friday),
      'This week · 9/21 - 9/27',
    );
  });

  testWidgets('dải ngày tạo từ tuần thật và chọn đúng ngày', (tester) async {
    EcoFitAppState.instance.resetForTesting();
    DateTime? selected;
    await tester.pumpWidget(
      MaterialApp(
        theme: ecoFitTheme,
        home: Scaffold(
          body: DateStrip(
            weekOf: DateTime(2026, 9, 25),
            selectedDate: DateTime(2026, 9, 25),
            onSelected: (value) => selected = value,
          ),
        ),
      ),
    );

    expect(find.text('T2\n21'), findsOneWidget);
    expect(find.text('T6\n25'), findsOneWidget);
    expect(find.text('CN\n27'), findsOneWidget);
    await tester.tap(find.text('CN\n27'));
    expect(selected, DateTime(2026, 9, 27));
  });

  testWidgets('chế độ tối đã lưu được áp dụng khi khởi động', (tester) async {
    SharedPreferences.setMockInitialValues({'settings.appearance': 'dark'});
    EcoFitAppState.instance.resetForTesting();

    await tester.pumpWidget(const EcoFitApp());
    await tester.pumpAndSettle();

    final context = tester.element(find.byType(Scaffold).first);
    expect(Theme.of(context).brightness, Brightness.dark);
    expect(Theme.of(context).scaffoldBackgroundColor, ecoDarkBackground);
    expect(Theme.of(context).colorScheme.surface, ecoDarkSurface);
    expect(Theme.of(context).colorScheme.primary, ecoDarkGreen);
    expect(Theme.of(context).dividerColor, ecoDarkLine);
    expect(MediaQuery.textScalerOf(context).scale(10), closeTo(11.2, 0.01));
  });
}
