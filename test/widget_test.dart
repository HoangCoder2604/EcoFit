import 'package:eco_fit/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('mở màn hình chào Eco Fit', (tester) async {
    await tester.pumpWidget(const EcoFitApp());
    expect(find.text('Eco Fit'), findsOneWidget);
    expect(find.text('Bắt đầu hành trình'), findsOneWidget);
  });
}
