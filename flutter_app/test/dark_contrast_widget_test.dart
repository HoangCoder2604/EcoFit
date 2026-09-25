import 'package:eco_fit/app/state/eco_fit_app_state.dart';
import 'package:eco_fit/screens.dart';
import 'package:eco_fit/theme.dart';
import 'package:eco_fit/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  Future<void> prepareVietnamese() async {
    SharedPreferences.setMockInitialValues({'settings.language': 'vi'});
    EcoFitAppState.instance.resetForTesting();
    await EcoFitAppState.instance.load();
  }

  Widget darkApp(Widget home) => MaterialApp(
    theme: ecoFitTheme,
    darkTheme: ecoFitDarkTheme,
    themeMode: ThemeMode.dark,
    home: home,
  );

  testWidgets('meal detail không dùng hero và cost card nền trắng khi tối', (
    tester,
  ) async {
    await prepareVietnamese();
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      darkApp(const MealDetailScreen(mealId: 'chicken-rice')),
    );
    await tester.pumpAndSettle();

    final hero = tester.widget<Container>(find.byKey(const Key('meal-hero')));
    final decoration = hero.decoration! as BoxDecoration;
    final gradient = decoration.gradient! as LinearGradient;
    expect(gradient.colors, const [Color(0xFF183321), Color(0xFF332714)]);

    await tester.scrollUntilVisible(
      find.byKey(const Key('meal-cost-card')),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    final cost = tester.widget<EcoCard>(
      find.byKey(const Key('meal-cost-card')),
    );
    expect(cost.color, const Color(0xFF2F2513));
  });

  testWidgets('grocery header dùng surface tối thay vì nền trắng', (
    tester,
  ) async {
    await prepareVietnamese();
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(darkApp(const GroceryScreen()));
    await tester.pumpAndSettle();

    final header = tester.widget<Container>(
      find.byKey(const ValueKey('grocery-header-Protein')),
    );
    final decoration = header.decoration! as BoxDecoration;
    expect(decoration.color, ecoDarkSurfaceSubtle);
  });
}
