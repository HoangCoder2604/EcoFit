import 'package:eco_fit/app/state/eco_fit_app_state.dart';
import 'package:eco_fit/screens.dart';
import 'package:eco_fit/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('bữa ăn và dữ liệu đổi sang tiếng Anh như frontend', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({'settings.language': 'en'});
    final state = EcoFitAppState.instance;
    state.resetForTesting();
    await state.load();

    await tester.pumpWidget(
      MaterialApp(theme: ecoFitTheme, home: const MealsScreen()),
    );
    await tester.pumpAndSettle();

    expect(find.text('Meal Planner'), findsOneWidget);
    expect(find.text('Chicken & Veggie Rice'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('View Grocery List'),
      350,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('View Grocery List'), findsOneWidget);
  });

  testWidgets('màn hình tập dùng dữ liệu tiếng Anh', (tester) async {
    SharedPreferences.setMockInitialValues({'settings.language': 'en'});
    final state = EcoFitAppState.instance;
    state.resetForTesting();
    await state.load();

    await tester.pumpWidget(
      MaterialApp(theme: ecoFitTheme, home: const WorkoutsScreen()),
    );
    await tester.pumpAndSettle();

    expect(find.text('Workout Schedule'), findsOneWidget);
    expect(find.textContaining('Chest · Shoulders · Triceps'), findsOneWidget);
    expect(find.textContaining('Today'), findsOneWidget);
  });
}
