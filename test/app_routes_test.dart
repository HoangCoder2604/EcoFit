import 'package:eco_fit/app/router/app_routes.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppRoutes', () {
    test('tạo và đọc route chi tiết món ăn', () {
      final route = AppRoutes.mealDetail('oatmeal');

      expect(route, '/meal/oatmeal');
      expect(AppRoutes.mealIdFrom(route), 'oatmeal');
    });

    test('từ chối route món ăn không hợp lệ', () {
      expect(AppRoutes.mealIdFrom('/meal/'), isNull);
      expect(AppRoutes.mealIdFrom('/unknown'), isNull);
      expect(AppRoutes.mealIdFrom(null), isNull);
    });

    test('danh sách route tĩnh không trùng nhau', () {
      expect(AppRoutes.knownRoutes.length, 14);
    });
  });
}
