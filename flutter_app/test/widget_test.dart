import 'package:eco_fit/app/state/eco_fit_app_state.dart';
import 'package:eco_fit/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('mở màn hình chào Eco Fit', (tester) async {
    SharedPreferences.setMockInitialValues({});
    EcoFitAppState.instance.resetForTesting();
    await tester.pumpWidget(const EcoFitApp());
    await tester.pumpAndSettle();
    expect(find.text('Eco Fit'), findsOneWidget);
    expect(find.text('Bắt đầu hành trình'), findsOneWidget);
  });
}
