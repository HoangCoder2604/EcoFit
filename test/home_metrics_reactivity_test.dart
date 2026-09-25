import 'package:eco_fit/app/state/eco_fit_app_state.dart';
import 'package:eco_fit/screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('trang chủ cập nhật ngay khi chỉ số cơ thể thay đổi', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final state = EcoFitAppState.instance;
    await state.updateMetrics(
      age: 20,
      gender: 'male',
      height: 170,
      weight: 65,
      activity: 1.375,
      goal: 'lose',
    );

    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
    expect(find.text('1618 kcal'), findsOneWidget);
    expect(find.text('2225 kcal'), findsOneWidget);

    await state.updateMetrics(
      age: 22,
      gender: 'female',
      height: 168,
      weight: 62,
      activity: 1.55,
      goal: 'maintain',
    );
    await tester.pump();

    expect(find.text('1399 kcal'), findsOneWidget);
    expect(find.text('2168 kcal'), findsOneWidget);
    expect(find.text('72 / 112g'), findsOneWidget);
    expect(find.text('130 / 304g'), findsOneWidget);
    expect(find.text('40 / 56g'), findsOneWidget);
  });
}
