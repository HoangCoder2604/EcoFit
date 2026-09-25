import 'package:eco_fit/screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('chỉnh sửa hồ sơ cập nhật tên và đóng bảng an toàn', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const MaterialApp(home: ProfileScreen()));

    await tester.tap(find.text('Chỉnh sửa'));
    await tester.pumpAndSettle();

    final fields = find.byType(TextField);
    expect(fields, findsNWidgets(2));
    await tester.enterText(fields.at(0), 'Lan Anh');
    await tester.enterText(fields.at(1), 'Đại học Quốc gia');
    await tester.tap(find.text('Lưu thay đổi'));
    await tester.pumpAndSettle();

    expect(find.text('Lan Anh'), findsOneWidget);
    expect(find.text('Sinh viên Đại học Quốc gia'), findsOneWidget);
  });
}
