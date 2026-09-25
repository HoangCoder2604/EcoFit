import 'package:eco_fit/app/state/eco_fit_app_state.dart';
import 'package:eco_fit/screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('tính chỉ số lưu các số liệu đã nhập', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const MaterialApp(home: BodyMetricsScreen()));

    final fields = find.byType(TextFormField);
    expect(fields, findsNWidgets(3));
    await tester.enterText(fields.at(0), '22');
    await tester.tap(find.text('♀ Nữ'));
    await tester.enterText(fields.at(1), '168');
    await tester.enterText(fields.at(2), '62');
    await tester.tap(find.text('Tính chỉ số của tôi'));
    await tester.pumpAndSettle();

    final state = EcoFitAppState.instance;
    expect(state.age, 22);
    expect(state.gender, 'female');
    expect(state.height, 168);
    expect(state.weight, 62);

    final preferences = await SharedPreferences.getInstance();
    expect(preferences.getInt('metrics.age'), 22);
    expect(preferences.getString('metrics.gender'), 'female');
    expect(preferences.getDouble('metrics.height'), 168);
    expect(preferences.getDouble('metrics.weight'), 62);
  });
}
