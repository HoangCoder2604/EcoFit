import 'package:eco_fit/app/state/eco_fit_app_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('lưu hồ sơ và chỉ số cơ thể vào bộ nhớ cục bộ', () async {
    SharedPreferences.setMockInitialValues({});
    final state = EcoFitAppState.instance;

    await state.updateProfile(name: 'Lan Anh', school: 'Đại học Quốc gia');
    await state.updateMetrics(
      age: 22,
      gender: 'female',
      height: 168,
      weight: 62,
      activity: 1.55,
      goal: 'maintain',
    );

    expect(state.name, 'Lan Anh');
    expect(state.school, 'Đại học Quốc gia');
    expect(state.initials, 'LA');
    expect(state.age, 22);
    expect(state.height, 168);
    expect(state.weight, 62);

    final preferences = await SharedPreferences.getInstance();
    expect(preferences.getString('profile.name'), 'Lan Anh');
    expect(preferences.getString('profile.school'), 'Đại học Quốc gia');
    expect(preferences.getInt('metrics.age'), 22);
    expect(preferences.getDouble('metrics.height'), 168);
    expect(preferences.getDouble('metrics.weight'), 62);
  });
}
