import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'app/router/app_routes.dart';
import 'app/localization/eco_fit_localization.dart';
import 'app/state/eco_fit_app_state.dart';
import 'data.dart';
import 'theme.dart';
import 'widgets.dart';

const pagePadding = EdgeInsets.fromLTRB(16, 8, 16, 24);
const gap8 = SizedBox(height: 8);
const gap12 = SizedBox(height: 12);
const gap16 = SizedBox(height: 16);

List<Meal> get activeMeals => localizedMeals(EcoFitAppState.instance.language);
List<GroceryGroup> get activeGroceryGroups =>
    localizedGroceryGroups(EcoFitAppState.instance.language);
List<(String, String, String, String)> get activeWorkoutDays =>
    localizedWorkoutDays(EcoFitAppState.instance.language);
List<(String, String, String, String)> get activeExercises =>
    localizedExercises(EcoFitAppState.instance.language);

String currentDateLabel({String language = 'vi', DateTime? now}) {
  final date = now ?? DateTime.now();
  if (language == 'en') {
    const weekdays = [
      'MONDAY',
      'TUESDAY',
      'WEDNESDAY',
      'THURSDAY',
      'FRIDAY',
      'SATURDAY',
      'SUNDAY',
    ];
    const months = [
      'JANUARY',
      'FEBRUARY',
      'MARCH',
      'APRIL',
      'MAY',
      'JUNE',
      'JULY',
      'AUGUST',
      'SEPTEMBER',
      'OCTOBER',
      'NOVEMBER',
      'DECEMBER',
    ];
    return '${weekdays[date.weekday - 1]}, ${months[date.month - 1]} ${date.day}';
  }
  const weekdays = [
    'THỨ HAI',
    'THỨ BA',
    'THỨ TƯ',
    'THỨ NĂM',
    'THỨ SÁU',
    'THỨ BẢY',
    'CHỦ NHẬT',
  ];
  return '${weekdays[date.weekday - 1]}, ${date.day} THÁNG ${date.month}';
}

DateTime startOfWeek(DateTime date) {
  final normalized = DateTime(date.year, date.month, date.day);
  return normalized.subtract(Duration(days: normalized.weekday - 1));
}

bool isSameDate(DateTime first, DateTime second) =>
    first.year == second.year &&
    first.month == second.month &&
    first.day == second.day;

String weekRangeLabel(DateTime date, {String language = 'vi', DateTime? now}) {
  final start = startOfWeek(date);
  final end = start.add(const Duration(days: 6));
  final todayStart = startOfWeek(now ?? DateTime.now());
  final isCurrentWeek = isSameDate(start, todayStart);
  if (language == 'en') {
    final prefix = isCurrentWeek ? 'This week · ' : '';
    return '$prefix${start.month}/${start.day} - ${end.month}/${end.day}';
  }
  final prefix = isCurrentWeek ? 'Tuần này · ' : '';
  return '$prefix${start.day}/${start.month} - ${end.day}/${end.month}';
}

void _toast(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}

Future<void> _infoDialog(BuildContext context, String title, String message) {
  return showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n('Đóng', 'Close')),
        ),
      ],
    ),
  );
}

Future<void> _showAttachmentPicker(BuildContext context) async {
  final selected = await showModalBottomSheet<String>(
    context: context,
    showDragHandle: true,
    builder: (sheetContext) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n('Thêm thông tin cho Eco Coach', 'Add context for Eco Coach'),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            Text(
              l10n(
                'Chọn loại nội dung bạn muốn đính kèm.',
                'Choose the content you want to attach.',
              ),
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            gap12,
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: Text(l10n('Ảnh món ăn', 'Meal photo')),
              subtitle: Text(
                l10n(
                  'Chụp hoặc chọn ảnh có sẵn',
                  'Take or choose an existing photo',
                ),
              ),
              onTap: () => Navigator.pop(sheetContext, 'Ảnh món ăn'),
            ),
            ListTile(
              leading: const Icon(Icons.receipt_long_outlined),
              title: Text(l10n('Thực đơn hoặc hoá đơn', 'Menu or receipt')),
              subtitle: Text(
                l10n('Tệp ảnh hoặc tài liệu', 'Image or document'),
              ),
              onTap: () => Navigator.pop(sheetContext, 'Thực đơn hoặc hoá đơn'),
            ),
            ListTile(
              leading: const Icon(Icons.monitor_heart_outlined),
              title: Text(l10n('Ảnh chỉ số sức khoẻ', 'Health metrics image')),
              subtitle: Text(
                l10n(
                  'Không gửi thông tin nhạy cảm',
                  'Do not share sensitive information',
                ),
              ),
              onTap: () => Navigator.pop(sheetContext, 'Ảnh chỉ số sức khoẻ'),
            ),
          ],
        ),
      ),
    ),
  );
  if (selected != null && context.mounted)
    _toast(context, '${l10n('Đã chọn', 'Selected')}: $selected');
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final desktop = constraints.maxWidth >= 900;
          if (kIsWeb && !desktop) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 560),
                  child: EcoCard(
                    padding: const EdgeInsets.all(28),
                    child: const Column(
                      children: [
                        EcoLogo(large: true),
                        gap16,
                        _SplashTagline(centered: true),
                        SizedBox(height: 280, child: _SplashArt()),
                        SizedBox(width: 250, child: _SplashButton()),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
          if (!desktop) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(24, 46, 24, 28),
              child: Column(
                children: [
                  const EcoLogo(large: true),
                  gap16,
                  _SplashTagline(centered: true),
                  const Expanded(child: _SplashArt()),
                  _SplashButton(),
                ],
              ),
            );
          }
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1180),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 56,
                  vertical: 40,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const EcoLogo(large: true),
                          const SizedBox(height: 28),
                          Text(
                            l10n(
                              'Sức khỏe tốt hơn,\nmỗi ngày một chút.',
                              'Better health,\none day at a time.',
                            ),
                            style: Theme.of(context).textTheme.headlineLarge
                                ?.copyWith(fontSize: 46, height: 1.08),
                          ),
                          const SizedBox(height: 18),
                          const SizedBox(
                            width: 430,
                            child: _SplashTagline(centered: false),
                          ),
                          const SizedBox(height: 34),
                          const SizedBox(width: 250, child: _SplashButton()),
                        ],
                      ),
                    ),
                    const SizedBox(width: 48),
                    Expanded(
                      child: AspectRatio(
                        aspectRatio: 1.08,
                        child: EcoCard(
                          padding: EdgeInsets.all(24),
                          child: _SplashArt(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    ),
  );
}

class _SplashTagline extends StatelessWidget {
  const _SplashTagline({required this.centered});
  final bool centered;

  @override
  Widget build(BuildContext context) => Text(
    l10n(
      'Sống khỏe hơn hôm nay cho ngày mai tươi sáng.',
      'Live healthier today for a brighter tomorrow.',
    ),
    textAlign: centered ? TextAlign.center : TextAlign.left,
    style: TextStyle(
      fontSize: centered ? 19 : 17,
      height: 1.55,
      fontWeight: FontWeight.w600,
      color: Theme.of(context).colorScheme.onSurfaceVariant,
    ),
  );
}

class _SplashButton extends StatelessWidget {
  const _SplashButton();

  @override
  Widget build(BuildContext context) => FilledButton.icon(
    onPressed: () => Navigator.pushNamed(context, AppRoutes.onboardingFood),
    icon: const Icon(Icons.arrow_forward),
    iconAlignment: IconAlignment.end,
    label: Text(l10n('Bắt đầu hành trình', 'Start Your Journey')),
  );
}

class _SplashArt extends StatelessWidget {
  const _SplashArt();

  @override
  Widget build(BuildContext context) => Stack(
    alignment: Alignment.center,
    children: [
      Positioned(
        bottom: 22,
        child: Container(
          width: 290,
          height: 240,
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color(0xFF193122)
                : const Color(0xFFDCEFD7),
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(145),
            ),
          ),
        ),
      ),
      const Positioned(
        top: 62,
        child: Text('🙂', style: TextStyle(fontSize: 90)),
      ),
      const Positioned(
        bottom: 54,
        child: Text('🎒', style: TextStyle(fontSize: 115)),
      ),
      const Positioned(
        right: 24,
        top: 40,
        child: Text('☀️', style: TextStyle(fontSize: 28)),
      ),
      Positioned(
        right: 8,
        top: 92,
        child: Text(
          l10n(
            'Sinh viên khỏe mạnh\nNgày mai tươi sáng',
            'Healthy students\nBrighter tomorrows',
          ),
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).colorScheme.primary,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
      Positioned(
        left: 20,
        top: 150,
        child: Icon(Icons.eco, color: Theme.of(context).colorScheme.primary),
      ),
    ],
  );
}

class FoodOnboardingScreen extends StatelessWidget {
  const FoodOnboardingScreen({super.key});
  @override
  Widget build(BuildContext context) => OnboardingLayout(
    eyebrow: l10n('DINH DƯỠNG CÁ NHÂN HÓA', 'PERSONALIZED NUTRITION'),
    title: l10n(
      'Ăn ngon, đủ chất\ndù là sinh viên',
      'Eat well, stay fit\neven on a student budget',
    ),
    description: l10n(
      'Thực đơn cá nhân hóa, dễ nấu, tiết kiệm và vẫn đầy đủ dinh dưỡng.',
      'Personalized meals that are easy to cook, economical, and fully nutritious.',
    ),
    art: Stack(
      alignment: Alignment.center,
      children: [
        const Text('🥗', style: TextStyle(fontSize: 125)),
        Positioned(
          right: 2,
          top: 22,
          child: Bubble(
            l10n(
              'Ăn tốt\nkhông cần tốn kém!',
              'Eating well\nwithout high costs!',
            ),
          ),
        ),
      ],
    ),
    features: [
      (
        Icons.restaurant,
        l10n('Gợi ý bữa ăn theo mục tiêu', 'Goal-based meal plans'),
        l10n(
          'Tăng cơ, giảm cân hay giữ dáng',
          'Build muscle, lose fat, or stay in shape',
        ),
      ),
      (
        Icons.savings_outlined,
        l10n('Phù hợp ngân sách sinh viên', 'Student budget friendly'),
        l10n(
          'Ngon, bổ, dễ tìm nguyên liệu',
          'Tasty, nutritious, easy-to-find ingredients',
        ),
      ),
      (
        Icons.pie_chart_outline,
        l10n('Tính calories & macros', 'Calories & macros calculated'),
        l10n(
          'Đủ protein, carb, fat cho cơ thể',
          'Optimal protein, carbs, and healthy fats',
        ),
      ),
    ],
    dot: 0,
    next: AppRoutes.onboardingWorkout,
  );
}

class WorkoutOnboardingScreen extends StatelessWidget {
  const WorkoutOnboardingScreen({super.key});
  @override
  Widget build(BuildContext context) => OnboardingLayout(
    eyebrow: l10n('TẬP LUYỆN KHOA HỌC', 'SMART TRAINING'),
    title: l10n(
      'Tập luyện hiệu quả\nTiến bộ mỗi ngày',
      'Train effectively\nProgress every day',
    ),
    description: l10n(
      'Kế hoạch tập luyện cá nhân hóa, phù hợp với thể trạng và mục tiêu của bạn.',
      'A personalized training program tailored to your fitness level and aspirations.',
    ),
    art: Stack(
      alignment: Alignment.center,
      children: const [
        Positioned(
          left: 60,
          bottom: 20,
          child: Text('😄', style: TextStyle(fontSize: 105)),
        ),
        Positioned(
          right: 62,
          bottom: 30,
          child: Text('💪', style: TextStyle(fontSize: 70)),
        ),
        Positioned(
          right: 2,
          top: 36,
          child: Text(
            'Stronger\nHappier\nYou ♥',
            style: TextStyle(
              fontSize: 15,
              color: Color(0xFF245A32),
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ],
    ),
    features: [
      (
        Icons.fitness_center,
        l10n('Bài tập theo mục tiêu', 'Goal-driven workouts'),
        l10n(
          'Tăng cơ, giảm mỡ, cải thiện vóc dáng',
          'Gain strength, burn fat, improve physique',
        ),
      ),
      (
        Icons.bar_chart,
        l10n('Theo dõi chỉ số cơ thể', 'Track body metrics'),
        l10n(
          'Cân nặng, BMR, TDEE, tiến độ',
          'Weight, BMR, TDEE, and milestones',
        ),
      ),
      (
        Icons.track_changes,
        l10n('Xây dựng thói quen bền vững', 'Build sustainable habits'),
        l10n(
          'Thiết lập lịch ăn và vận động phù hợp',
          'Step by step to become a better version',
        ),
      ),
    ],
    dot: 1,
    next: AppRoutes.login,
  );
}

class OnboardingLayout extends StatelessWidget {
  const OnboardingLayout({
    super.key,
    required this.eyebrow,
    required this.title,
    required this.description,
    required this.art,
    required this.features,
    required this.dot,
    required this.next,
  });
  final String eyebrow, title, description, next;
  final Widget art;
  final List<(IconData, String, String)> features;
  final int dot;
  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final desktop = constraints.maxWidth >= 900;
          if (kIsWeb && !desktop) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 680),
                  child: EcoCard(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _skip(context),
                        _heading(context, desktop: false),
                        SizedBox(height: 220, child: art),
                        ..._featureCards(),
                        const SizedBox(height: 12),
                        _dots(context),
                        const SizedBox(height: 16),
                        Align(
                          alignment: Alignment.centerRight,
                          child: SizedBox(
                            width: 210,
                            child: _nextButton(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
          if (!desktop) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 26),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _skip(context),
                  _heading(context, desktop: false),
                  SizedBox(height: 210, child: art),
                  ..._featureCards(),
                  const Spacer(),
                  _dots(context),
                  gap12,
                  _nextButton(context),
                ],
              ),
            );
          }
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1180),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 48,
                  vertical: 32,
                ),
                child: Column(
                  children: [
                    _skip(context),
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            flex: 6,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 56),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _heading(context, desktop: true),
                                  const SizedBox(height: 22),
                                  Expanded(child: art),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: EcoCard(
                              padding: const EdgeInsets.all(28),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    l10n(
                                      'Eco Fit đồng hành cùng bạn',
                                      'How Eco Fit supports you',
                                    ),
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge,
                                  ),
                                  const SizedBox(height: 18),
                                  ..._featureCards(),
                                  const SizedBox(height: 18),
                                  _dots(context),
                                  const SizedBox(height: 18),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: SizedBox(
                                      width: 210,
                                      child: _nextButton(context),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    ),
  );

  Widget _skip(BuildContext context) => Align(
    alignment: Alignment.centerRight,
    child: TextButton(
      onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.login),
      child: Text(
        l10n('Bỏ qua', 'Skip'),
        style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
      ),
    ),
  );

  Widget _heading(BuildContext context, {required bool desktop}) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        eyebrow,
        style: TextStyle(
          fontSize: 10,
          letterSpacing: 1.2,
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.w800,
        ),
      ),
      gap8,
      Text(
        title,
        style: Theme.of(context).textTheme.headlineLarge
            ?.copyWith(fontSize: desktop ? 42 : null),
      ),
      gap8,
      ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: Text(
          description,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            height: 1.55,
          ),
        ),
      ),
    ],
  );

  List<Widget> _featureCards() => features
      .map(
        (f) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: _Feature(f.$1, f.$2, f.$3),
        ),
      )
      .toList();

  Widget _dots(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: List.generate(
      3,
      (i) => AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.all(3),
        width: i == dot ? 20 : 6,
        height: 6,
        decoration: BoxDecoration(
          color: i == dot
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).dividerColor,
          borderRadius: BorderRadius.circular(9),
        ),
      ),
    ),
  );

  Widget _nextButton(BuildContext context) => FilledButton.icon(
    onPressed: () => Navigator.pushReplacementNamed(context, next),
    icon: const Icon(Icons.arrow_forward),
    iconAlignment: IconAlignment.end,
    label: Text(l10n('Tiếp theo', 'Next')),
  );
}

class Bubble extends StatelessWidget {
  const Bubble(this.text, {super.key});
  final String text;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.primaryContainer,
      shape: BoxShape.circle,
      border: Border.all(
        color: Theme.of(context).colorScheme.primary,
        width: 2,
      ),
    ),
    child: Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: Theme.of(context).colorScheme.onPrimaryContainer,
      ),
    ),
  );
}

class _Feature extends StatelessWidget {
  const _Feature(this.icon, this.title, this.text);
  final IconData icon;
  final String title, text;
  @override
  Widget build(BuildContext context) => EcoCard(
    padding: const EdgeInsets.all(11),
    child: Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: Theme.of(context).colorScheme.primary,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                text,
                style: TextStyle(
                  fontSize: 9,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool login = true, remember = false, obscure = true;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      if (constraints.maxWidth >= 900) return _desktop(context);
      if (kIsWeb) return _mobileWeb(context);
      return _mobile(context);
    },
  );

  Widget _mobileWeb(BuildContext context) => Scaffold(
    appBar: AppBar(title: const EcoLogo()),
    body: SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: EcoCard(
              padding: const EdgeInsets.all(26),
              child: _desktopForm(context),
            ),
          ),
        ),
      ),
    ),
  );

  Widget _mobile(BuildContext context) => Scaffold(
    appBar: AppBar(),
    body: SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 28),
        child: Column(
          children: [
            const EcoLogo(large: true),
            gap16,
            Text(
              login
                  ? l10n('Đăng nhập để bắt đầu', 'Sign in to begin')
                  : l10n(
                      'Tạo tài khoản Eco Fit',
                      'Create your Eco Fit account',
                    ),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(
              l10n('hành trình khỏe mạnh hơn', 'a healthier journey awaits'),
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 28),
            TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.mail_outline),
                hintText: l10n('Email của bạn', 'Your email address'),
              ),
            ),
            gap12,
            TextField(
              obscureText: obscure,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.lock_outline),
                hintText: l10n('Mật khẩu', 'Password'),
                suffixIcon: IconButton(
                  onPressed: () => setState(() => obscure = !obscure),
                  icon: const Icon(Icons.visibility_outlined),
                ),
              ),
            ),
            if (login)
              Row(
                children: [
                  Checkbox(
                    value: remember,
                    onChanged: (v) => setState(() => remember = v!),
                  ),
                  Text(
                    l10n('Ghi nhớ đăng nhập', 'Remember me'),
                    style: const TextStyle(fontSize: 10),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => _infoDialog(
                      context,
                      'Khôi phục mật khẩu',
                      'Liên kết đặt lại mật khẩu đã được gửi tới email của bạn.',
                    ),
                    child: Text(
                      l10n('Quên mật khẩu?', 'Forgot password?'),
                      style: const TextStyle(fontSize: 10),
                    ),
                  ),
                ],
              ),
            gap12,
            FilledButton(
              onPressed: () => Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.home,
                (_) => false,
              ),
              child: Text(
                login
                    ? l10n('Đăng nhập', 'Sign In')
                    : l10n('Tạo tài khoản', 'Create Account'),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Row(
                children: [
                  const Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      l10n('hoặc', 'or'),
                      style: TextStyle(
                        fontSize: 10,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  const Expanded(child: Divider()),
                ],
              ),
            ),
            OutlinedButton.icon(
              onPressed: () {
                _toast(context, 'Đã xác thực tài khoản Google');
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.home,
                  (_) => false,
                );
              },
              icon: const Text(
                'G',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              label: Text(
                login
                    ? l10n('Đăng nhập với Google', 'Sign in with Google')
                    : l10n('Đăng ký với Google', 'Sign up with Google'),
              ),
            ),
            gap12,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  login
                      ? l10n('Chưa có tài khoản? ', "Don't have an account? ")
                      : l10n('Đã có tài khoản? ', 'Already have an account? '),
                  style: TextStyle(
                    fontSize: 10,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                TextButton(
                  onPressed: () => setState(() => login = !login),
                  child: Text(
                    login
                        ? l10n('Tạo tài khoản', 'Create Account')
                        : l10n('Đăng nhập', 'Sign In'),
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 55),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.eco,
                  size: 18,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 6),
                Text(
                  l10n(
                    'Sức khỏe hôm nay, một tương lai tươi sáng hơn.',
                    'Health today, a brighter tomorrow.',
                  ),
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFF55705A),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );

  Widget _desktop(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1080, maxHeight: 700),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 28),
            child: EcoCard(
              padding: EdgeInsets.zero,
              child: Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: Container(
                      height: double.infinity,
                      padding: const EdgeInsets.all(36),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: const BorderRadius.horizontal(
                          left: Radius.circular(18),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const EcoLogo(large: true),
                          const SizedBox(height: 32),
                          Text(
                            l10n(
                              'Chăm sức khỏe\ntheo cách của bạn.',
                              'Wellness built\naround your life.',
                            ),
                            style: Theme.of(context).textTheme.headlineLarge
                                ?.copyWith(fontSize: 38, height: 1.12),
                          ),
                          const SizedBox(height: 18),
                          Text(
                            l10n(
                              'Dinh dưỡng, tập luyện và tiến độ trong một không gian gọn gàng, dễ sử dụng.',
                              'Nutrition, training and progress in one focused, easy-to-use space.',
                            ),
                            style: TextStyle(
                              fontSize: 15,
                              height: 1.55,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 30),
                          _LoginBenefit(
                            Icons.restaurant_menu_outlined,
                            l10n('Bữa ăn vừa mục tiêu', 'Meals for your goals'),
                          ),
                          _LoginBenefit(
                            Icons.fitness_center_outlined,
                            l10n(
                              'Lịch tập dễ theo dõi',
                              'Training that stays on track',
                            ),
                          ),
                          _LoginBenefit(
                            Icons.insights_outlined,
                            l10n(
                              'Tiến độ rõ ràng mỗi ngày',
                              'Clear daily progress',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 54,
                        vertical: 38,
                      ),
                      child: _desktopForm(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );

  Widget _desktopForm(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Text(
        login
            ? l10n('Chào mừng bạn trở lại', 'Welcome back')
            : l10n('Bắt đầu với Eco Fit', 'Get started with Eco Fit'),
        style: Theme.of(context).textTheme.headlineSmall,
      ),
      const SizedBox(height: 6),
      Text(
        login
            ? l10n(
                'Đăng nhập để tiếp tục kế hoạch hôm nay.',
                'Sign in to continue today’s plan.',
              )
            : l10n(
                'Tạo tài khoản để lưu kế hoạch của bạn.',
                'Create an account to save your plan.',
              ),
        style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
      ),
      const SizedBox(height: 28),
      TextField(
        decoration: InputDecoration(
          labelText: 'Email',
          prefixIcon: const Icon(Icons.mail_outline),
          hintText: l10n('ban@email.com', 'you@email.com'),
        ),
      ),
      gap12,
      TextField(
        obscureText: obscure,
        decoration: InputDecoration(
          labelText: l10n('Mật khẩu', 'Password'),
          prefixIcon: const Icon(Icons.lock_outline),
          suffixIcon: IconButton(
            onPressed: () => setState(() => obscure = !obscure),
            icon: Icon(
              obscure
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
            ),
          ),
        ),
      ),
      if (login)
        Row(
          children: [
            Checkbox(
              value: remember,
              onChanged: (v) => setState(() => remember = v!),
            ),
            Expanded(child: Text(l10n('Ghi nhớ đăng nhập', 'Remember me'))),
            TextButton(
              onPressed: () => _infoDialog(
                context,
                l10n('Khôi phục mật khẩu', 'Password recovery'),
                l10n(
                  'Liên kết đặt lại mật khẩu đã được gửi tới email của bạn.',
                  'A reset link has been sent to your email.',
                ),
              ),
              child: Text(l10n('Quên mật khẩu?', 'Forgot password?')),
            ),
          ],
        ),
      const SizedBox(height: 10),
      FilledButton(
        onPressed: () => Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.home,
          (_) => false,
        ),
        child: Text(
          login
              ? l10n('Đăng nhập', 'Sign In')
              : l10n('Tạo tài khoản', 'Create Account'),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 18),
        child: Row(
          children: [
            const Expanded(child: Divider()),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                l10n('hoặc', 'or'),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            const Expanded(child: Divider()),
          ],
        ),
      ),
      OutlinedButton.icon(
        onPressed: () {
          _toast(
            context,
            l10n('Đã xác thực tài khoản Google', 'Google account verified'),
          );
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.home,
            (_) => false,
          );
        },
        icon: const Text(
          'G',
          style: TextStyle(
            color: Colors.blue,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        label: Text(
          login
              ? l10n('Đăng nhập với Google', 'Sign in with Google')
              : l10n('Đăng ký với Google', 'Sign up with Google'),
        ),
      ),
      const SizedBox(height: 12),
      Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            login
                ? l10n('Chưa có tài khoản? ', "Don't have an account? ")
                : l10n('Đã có tài khoản? ', 'Already have an account? '),
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          TextButton(
            onPressed: () => setState(() => login = !login),
            child: Text(
              login
                  ? l10n('Tạo tài khoản', 'Create Account')
                  : l10n('Đăng nhập', 'Sign In'),
            ),
          ),
        ],
      ),
    ],
  );
}

class _LoginBenefit extends StatelessWidget {
  const _LoginBenefit(this.icon, this.label);
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            size: 19,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
      ],
    ),
  );
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final appState = EcoFitAppState.instance;
    return ListenableBuilder(
      listenable: appState,
      builder: (context, _) {
        final metrics = appState.metrics;
        const consumedCalories = 1250;
        final calorieProgress = (consumedCalories / metrics.calories).clamp(
          0.0,
          1.0,
        );
        return EcoShell(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final desktop = constraints.maxWidth >= 900;
              final nutrition = _NutritionPanel(
                calorieProgress: calorieProgress,
                calories: metrics.calories,
                protein: metrics.protein,
                carbs: metrics.carbs,
                fat: metrics.fat,
              );
              if (desktop) {
                return _DesktopHome(
                  name: appState.name,
                  initials: appState.initials,
                  nutrition: nutrition,
                  bmr: metrics.bmr,
                  tdee: metrics.tdee,
                );
              }
              return _MobileHome(
                name: appState.name,
                initials: appState.initials,
                nutrition: nutrition,
                bmr: metrics.bmr,
                tdee: metrics.tdee,
              );
            },
          ),
        );
      },
    );
  }
}

class _MobileHome extends StatelessWidget {
  const _MobileHome({
    required this.name,
    required this.initials,
    required this.nutrition,
    required this.bmr,
    required this.tdee,
  });

  final String name, initials;
  final Widget nutrition;
  final int bmr, tdee;

  @override
  Widget build(BuildContext context) => ListView(
    padding: pagePadding,
    children: [
      _HomeGreeting(name: name, initials: initials),
      gap12,
      FilledButton.icon(
        key: const Key('home-check-in-button'),
        onPressed: () => Navigator.pushNamed(context, AppRoutes.checkIn),
        icon: const Icon(Icons.add_task_outlined),
        label: Text(l10n('Check-in hôm nay', 'Daily check-in')),
      ),
      gap16,
      nutrition,
      gap12,
      EcoCard(
        child: Column(
          children: [
            SectionTitle(
              l10n('Chỉ số năng lượng', 'Energy metrics'),
              action: l10n('Xem chỉ số', 'View metrics'),
              onTap: () => Navigator.pushNamed(context, AppRoutes.metrics),
            ),
            Row(
              children: [
                Expanded(
                  child: StatCard(
                    icon: Icons.local_fire_department_outlined,
                    label: 'BMR',
                    value: '$bmr kcal',
                    sub: l10n('Năng lượng cơ bản', 'Basal rate'),
                    color: const Color(0xFFFFF7E8),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: StatCard(
                    icon: Icons.bar_chart,
                    label: 'TDEE',
                    value: '$tdee kcal',
                    sub: l10n('Năng lượng duy trì', 'Maintenance'),
                    color: const Color(0xFFEEF8F1),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      gap12,
      EcoCard(
        child: Column(
          children: [
            SectionTitle(
              l10n('Lịch trong ngày', "Today's schedule"),
              action: l10n('Xem kế hoạch', 'View plan'),
              onTap: () => Navigator.pushNamed(context, AppRoutes.workouts),
            ),
            _ActionCard(
              icon: Icons.fitness_center,
              title: l10n('Ngực & tay sau', 'Chest & triceps'),
              subtitle: l10n(
                '17:00 · khoảng 45 phút',
                '17:00 · about 45 minutes',
              ),
              onTap: () => Navigator.pushNamed(context, AppRoutes.exercise),
            ),
            const Divider(height: 20),
            _ActionCard(
              emoji: '🍱',
              title: activeMeals[1].name,
              subtitle: l10n('Bữa trưa · 520 kcal', 'Lunch · 520 kcal'),
              onTap: () => Navigator.pushNamed(
                context,
                AppRoutes.mealDetail('chicken-rice'),
              ),
            ),
          ],
        ),
      ),
      gap12,
      EcoCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionTitle(
              l10n('Nhịp sinh hoạt 7 ngày', '7-day routine'),
              action: l10n('Xem tiến độ', 'View progress'),
              onTap: () => Navigator.pushNamed(context, AppRoutes.progress),
            ),
            const SizedBox(
              height: 112,
              width: double.infinity,
              child: CustomPaint(painter: WeightChartPainter()),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                for (final day in l10nList(
                  const ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'],
                  const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
                ))
                  Text(
                    day,
                    style: TextStyle(
                      fontSize: 9,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    ],
  );
}

class _HomeGreeting extends StatelessWidget {
  const _HomeGreeting({required this.name, required this.initials});
  final String name, initials;
  @override
  Widget build(BuildContext context) {
    final english = EcoFitAppState.instance.language == 'en';
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                currentDateLabel(language: english ? 'en' : 'vi'),
                style: TextStyle(
                  fontSize: 10,
                  letterSpacing: 1.1,
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                english ? 'Hello, $name' : 'Chào $name',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Text(
                english ? 'You have one workout and two meals left today.' : 'Bạn còn một buổi tập và hai bữa ăn trong kế hoạch hôm nay.',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        CircleAvatar(
          radius: 23,
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Text(
            initials,
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Theme.of(context).colorScheme.onPrimaryContainer
                  : ecoText,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}

class _NutritionPanel extends StatelessWidget {
  const _NutritionPanel({
    required this.calorieProgress,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
  });
  final double calorieProgress;
  final int calories, protein, carbs, fat;
  @override
  Widget build(BuildContext context) => EcoCard(
    child: Column(
      children: [
        SectionTitle(
          l10n('Dinh dưỡng hôm nay', "Today's nutrition"),
          action: l10n('Chỉnh mục tiêu', 'Edit goals'),
          onTap: () => Navigator.pushNamed(context, AppRoutes.metrics),
        ),
        Row(
          children: [
            MacroRing(
              value: calorieProgress,
              center: '1.250',
              total: '/ $calories kcal',
            ),
            const SizedBox(width: 22),
            Expanded(
              child: MacroLegend(
                values: [
                  (ecoClay, l10n('Đạm', 'Protein'), '72 / ${protein}g'),
                  (ecoSun, l10n('Tinh bột', 'Carbs'), '130 / ${carbs}g'),
                  (Color(0xFF5B82A8), l10n('Chất béo', 'Fat'), '40 / ${fat}g'),
                ],
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

class _DesktopHome extends StatelessWidget {
  const _DesktopHome({
    required this.name,
    required this.initials,
    required this.nutrition,
    required this.bmr,
    required this.tdee,
  });
  final String name, initials;
  final Widget nutrition;
  final int bmr, tdee;
  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(32),
    children: [
      Row(
        children: [
          Expanded(
            child: _HomeGreeting(name: name, initials: initials),
          ),
          const SizedBox(width: 24),
          FilledButton.icon(
            style: FilledButton.styleFrom(minimumSize: const Size(0, 50)),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.checkIn),
            icon: const Icon(Icons.add_task),
            label: Text(l10n('Check-in hôm nay', 'Daily check-in')),
          ),
        ],
      ),
      const SizedBox(height: 24),
      GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        mainAxisExtent: 250,
        children: [
          SizedBox.expand(
            key: const ValueKey('desktop-home-card-nutrition'),
            child: nutrition,
          ),
          SizedBox.expand(
            key: const ValueKey('desktop-home-card-energy'),
            child: EcoCard(
              child: Column(
                children: [
                  SectionTitle(l10n('Chỉ số năng lượng', 'Energy metrics')),
                  StatCard(
                    icon: Icons.local_fire_department_outlined,
                    label: 'BMR',
                    value: '$bmr kcal',
                    sub: l10n('Năng lượng cơ bản', 'Basal metabolic rate'),
                    color: const Color(0xFFFFF7E8),
                  ),
                  const SizedBox(height: 10),
                  StatCard(
                    icon: Icons.bar_chart,
                    label: 'TDEE',
                    value: '$tdee kcal',
                    sub: l10n('Năng lượng duy trì', 'Daily energy expenditure'),
                    color: const Color(0xFFEEF8F1),
                  ),
                ],
              ),
            ),
          ),
          SizedBox.expand(
            key: const ValueKey('desktop-home-card-schedule'),
            child: EcoCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionTitle(
                    l10n('Lịch trong ngày', "Today's schedule"),
                    action: l10n('Xem kế hoạch tập', 'View workout plan'),
                    onTap: () =>
                        Navigator.pushNamed(context, AppRoutes.workouts),
                  ),
                  _ActionCard(
                    icon: Icons.fitness_center,
                    title: l10n('Ngực & tay sau', 'Chest & triceps'),
                    subtitle: l10n(
                      '17:00 · khoảng 45 phút',
                      '17:00 · about 45 minutes',
                    ),
                    onTap: () =>
                        Navigator.pushNamed(context, AppRoutes.exercise),
                  ),
                  const Divider(height: 24),
                  _ActionCard(
                    emoji: '🍱',
                    title: activeMeals[1].name,
                    subtitle: l10n('Bữa trưa · 520 kcal', 'Lunch · 520 kcal'),
                    onTap: () => Navigator.pushNamed(
                      context,
                      AppRoutes.mealDetail('chicken-rice'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox.expand(
            key: const ValueKey('desktop-home-card-routine'),
            child: EcoCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionTitle(
                    l10n('Nhịp sinh hoạt 7 ngày', '7-day routine'),
                    action: l10n('Xem tiến độ', 'View progress'),
                    onTap: () =>
                        Navigator.pushNamed(context, AppRoutes.progress),
                  ),
                  const SizedBox(
                    height: 150,
                    child: CustomPaint(painter: WeightChartPainter()),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      for (final day in l10nList(
                        const ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'],
                        const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
                      ))
                        Text(day),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ],
  );
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    this.icon,
    this.emoji,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
  final IconData? icon;
  final String? emoji;
  final String title, subtitle;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(16),
    child: EcoCard(
      color: Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF223027)
          : const Color(0xFFF4F8EF),
      padding: const EdgeInsets.all(11),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(13),
            ),
            child: Center(
              child: emoji != null
                  ? Text(emoji!, style: const TextStyle(fontSize: 24))
                  : Icon(icon, color: Theme.of(context).colorScheme.primary),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 8,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, size: 18),
        ],
      ),
    ),
  );
}

class MealsScreen extends StatefulWidget {
  const MealsScreen({super.key});
  @override
  State<MealsScreen> createState() => _MealsScreenState();
}

class _MealsScreenState extends State<MealsScreen> {
  int tab = 0;
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    selectedDate = DateTime(now.year, now.month, now.day);
  }

  @override
  Widget build(BuildContext context) => EcoShell(
    title: l10n('Kế hoạch bữa ăn', 'Meal Planner'),
    selected: 1,
    child: ListView(
      padding: pagePadding,
      children: [
        _DatePicker(
          date: selectedDate,
          onPrevious: () => setState(
            () => selectedDate = selectedDate.subtract(const Duration(days: 1)),
          ),
          onNext: () => setState(
            () => selectedDate = selectedDate.add(const Duration(days: 1)),
          ),
        ),
        gap12,
        const EcoCard(
          child: Row(
            children: [
              MacroRing(value: .72, center: '1.850'),
              SizedBox(width: 20),
              Expanded(
                child: MacroLegend(
                  values: [
                    (Color(0xFFE66B58), 'Protein', '90 / 120g'),
                    (Color(0xFFF1A63E), 'Carb', '220 / 250g'),
                    (Color(0xFF5C92DE), 'Fat', '60 / 70g'),
                  ],
                ),
              ),
            ],
          ),
        ),
        gap12,
        SegmentedTabs(
          l10nList(
            const ['Bữa ăn hôm nay', 'Tuần này'],
            const ["Today's Meals", 'This Week'],
          ),
          selected: tab,
          onSelected: (i) => setState(() => tab = i),
        ),
        gap12,
        ...activeMeals.map(
          (m) => Padding(
            padding: const EdgeInsets.only(bottom: 9),
            child: InkWell(
              onTap: () =>
                  Navigator.pushNamed(context, AppRoutes.mealDetail(m.id)),
              child: EcoCard(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? const Color(0xFF223027)
                            : const Color(0xFFF7EDD6),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: Center(
                        child: Text(
                          m.emoji,
                          style: const TextStyle(fontSize: 25),
                        ),
                      ),
                    ),
                    const SizedBox(width: 9),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            m.type,
                            style: TextStyle(
                              fontSize: 8,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                          ),
                          Text(
                            m.name,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            '${m.kcal} kcal',
                            style: TextStyle(
                              fontSize: 8,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(99),
                      ),
                      child: Text(
                        m.tag,
                        style: TextStyle(
                          fontSize: 8,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                    const Icon(Icons.chevron_right, size: 18),
                  ],
                ),
              ),
            ),
          ),
        ),
        OutlinedButton.icon(
          onPressed: () => Navigator.pushNamed(context, AppRoutes.grocery),
          icon: const Icon(Icons.shopping_cart_outlined),
          label: Text(l10n('Xem danh sách mua sắm', 'View Grocery List')),
        ),
      ],
    ),
  );
}

class MealDetailScreen extends StatefulWidget {
  const MealDetailScreen({super.key, required this.mealId});
  final String mealId;

  @override
  State<MealDetailScreen> createState() => _MealDetailScreenState();
}

class _MealDetailScreenState extends State<MealDetailScreen> {
  int tab = 0;
  bool favorite = false;
  bool added = false;

  @override
  Widget build(BuildContext context) {
    final meal =
        activeMeals.where((m) => m.id == widget.mealId).firstOrNull ??
        activeMeals.first;
    final ingredients = ecoFitIsEnglish
        ? const [
            ('🥣', 'Rolled oats 50g', '3,000đ'),
            ('🥛', 'Unsweetened milk 100ml', '4,000đ'),
            ('🍌', 'Banana 1 pc', '2,000đ'),
            ('🍓', 'Strawberries 50g', '5,000đ'),
            ('🌰', 'Chia seeds 5g', '2,000đ'),
          ]
        : const [
            ('🥣', 'Yến mạch cán dẹt 50g', '3.000đ'),
            ('🥛', 'Sữa tươi không đường 100ml', '4.000đ'),
            ('🍌', 'Chuối 1 quả', '2.000đ'),
            ('🍓', 'Dâu tây 50g', '5.000đ'),
            ('🌰', 'Hạt chia 5g', '2.000đ'),
          ];
    return EcoShell(
      title: meal.name,
      showNav: false,
      actions: [
        IconButton(
          onPressed: () => setState(() => favorite = !favorite),
          icon: Icon(favorite ? Icons.favorite : Icons.favorite_border),
          color: favorite ? Colors.red : null,
          tooltip: favorite
              ? l10n('Bỏ yêu thích', 'Remove favorite')
              : l10n('Yêu thích', 'Favorite'),
        ),
      ],
      child: ListView(
        padding: pagePadding,
        children: [
          Text(
            '${meal.type} · ${l10n('lành mạnh, nhanh gọn', 'healthy, quick & easy')}',
            style: TextStyle(
              fontSize: 10,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          gap12,
          Container(
            key: const Key('meal-hero'),
            height: 210,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: Theme.of(context).brightness == Brightness.dark
                    ? const [Color(0xFF183321), Color(0xFF332714)]
                    : const [Color(0xFFE8F0DA), Color(0xFFF8EAC5)],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Stack(
              children: [
                Center(
                  child: Text(
                    meal.emoji,
                    style: const TextStyle(fontSize: 105),
                  ),
                ),
                const Positioned(
                  right: 12,
                  bottom: 10,
                  child: Chip(
                    label: Text(
                      'fresh & healthy',
                      style: TextStyle(fontSize: 8),
                    ),
                  ),
                ),
              ],
            ),
          ),
          gap12,
          Row(
            children: [
              for (final n in [
                (Icons.local_fire_department, '${meal.kcal}', 'kcal'),
                (
                  Icons.fitness_center,
                  '${meal.protein}g',
                  l10n('Đạm', 'Protein'),
                ),
                (Icons.grain, '${meal.carbs}g', l10n('Tinh bột', 'Carbs')),
                (
                  Icons.water_drop_outlined,
                  '${meal.fat}g',
                  l10n('Chất béo', 'Fat'),
                ),
              ])
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: _Nutrition(n.$1, n.$2, n.$3),
                  ),
                ),
            ],
          ),
          gap16,
          SegmentedTabs(
            l10nList(
              const ['Nguyên liệu', 'Cách làm'],
              const ['Ingredients', 'Instructions'],
            ),
            selected: tab,
            onSelected: (i) => setState(() => tab = i),
          ),
          gap8,
          if (tab == 0)
            ...ingredients.map(
              (x) => Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Theme.of(context).dividerColor),
                  ),
                ),
                child: Row(
                  children: [
                    SizedBox(width: 30, child: Text(x.$1)),
                    Expanded(
                      child: Text(
                        x.$2,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Text(
                      x.$3,
                      style: TextStyle(
                        fontSize: 9,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            ...l10nList(
              const [
                'Trộn yến mạch với sữa và ngâm khoảng 10 phút.',
                'Cắt chuối, dâu tây thành miếng vừa ăn.',
                'Cho trái cây và hạt chia lên trên rồi thưởng thức.',
              ],
              const [
                'Mix the oats with milk and soak for about 10 minutes.',
                'Slice the banana and strawberries into bite-sized pieces.',
                'Top with fruit and chia seeds, then enjoy.',
              ],
            ).indexed.map(
              (step) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  radius: 14,
                  backgroundColor: Theme.of(context)
                      .colorScheme
                      .primaryContainer,
                  child: Text(
                    '${step.$1 + 1}',
                    style: TextStyle(
                      fontSize: 10,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                title: Text(step.$2, style: const TextStyle(fontSize: 10)),
              ),
            ),
          gap12,
          EcoCard(
            key: const Key('meal-cost-card'),
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color(0xFF2F2513)
                : const Color(0xFFFFF7DD),
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                const Icon(
                  Icons.account_balance_wallet_outlined,
                  color: Color(0xFFB98216),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n('Chi phí ước tính', 'Estimated Cost'),
                        style: TextStyle(
                          fontSize: 8,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      Text(
                        '~ ${money(meal.price)} ${l10n('/ khẩu phần', '/ serving')}',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                Chip(
                  label: Text(
                    l10n('Tiết kiệm', 'Budget'),
                    style: TextStyle(
                      fontSize: 8,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  backgroundColor: Theme.of(context)
                      .colorScheme
                      .primaryContainer,
                ),
              ],
            ),
          ),
          gap12,
          FilledButton.icon(
            onPressed: () {
              setState(() => added = !added);
              _toast(
                context,
                added
                    ? l10n(
                        'Đã thêm món ăn vào kế hoạch',
                        'Meal added to your plan',
                      )
                    : l10n(
                        'Đã gỡ món ăn khỏi kế hoạch',
                        'Meal removed from your plan',
                      ),
              );
            },
            icon: Icon(added ? Icons.check : Icons.add),
            label: Text(
              added
                  ? l10n('Đã thêm vào kế hoạch', 'Added to Plan')
                  : l10n('Thêm vào kế hoạch', 'Add to Plan'),
            ),
          ),
        ],
      ),
    );
  }
}

class _Nutrition extends StatelessWidget {
  const _Nutrition(this.icon, this.value, this.label);
  final IconData icon;
  final String value, label;
  @override
  Widget build(BuildContext context) => EcoCard(
    padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 2),
    child: Column(
      children: [
        Icon(icon, size: 18, color: Theme.of(context).colorScheme.primary),
        Text(
          value,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 7,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    ),
  );
}

class _DatePicker extends StatelessWidget {
  const _DatePicker({
    required this.date,
    required this.onPrevious,
    required this.onNext,
    this.week = false,
  });

  final DateTime date;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final bool week;

  @override
  Widget build(BuildContext context) {
    final language = EcoFitAppState.instance.language;
    final label = week
        ? weekRangeLabel(date, language: language)
        : currentDateLabel(language: language, now: date);
    return EcoCard(
      padding: EdgeInsets.zero,
      child: SizedBox(
        height: 40,
        child: Row(
          children: [
            IconButton(
              onPressed: onPrevious,
              icon: const Icon(Icons.chevron_left),
              tooltip: week
                  ? l10n('Tuần trước', 'Previous week')
                  : l10n('Ngày trước', 'Previous day'),
            ),
            Expanded(
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            IconButton(
              onPressed: onNext,
              icon: const Icon(Icons.chevron_right),
              tooltip: week
                  ? l10n('Tuần sau', 'Next week')
                  : l10n('Ngày sau', 'Next day'),
            ),
          ],
        ),
      ),
    );
  }
}

class GroceryScreen extends StatefulWidget {
  const GroceryScreen({super.key});
  @override
  State<GroceryScreen> createState() => _GroceryScreenState();
}

class _GroceryScreenState extends State<GroceryScreen> {
  final checked = <String, bool>{
    'Ức gà (500g)': true,
    'Rau cải bó xôi (300g)': true,
  };
  int tab = 0;
  late DateTime weekDate;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    weekDate = DateTime(now.year, now.month, now.day);
  }

  @override
  Widget build(BuildContext context) {
    final all = activeGroceryGroups.expand((g) => g.items);
    final total = all.fold(0, (s, x) => s + x.$2);
    final bought = all.fold(
      0,
      (s, x) => s + ((checked[x.$1] ?? false) ? x.$2 : 0),
    );
    return EcoShell(
      title: l10n('Danh sách mua sắm', 'Grocery List'),
      showNav: false,
      child: ListView(
        padding: pagePadding,
        children: [
          _DatePicker(
            date: weekDate,
            week: true,
            onPrevious: () => setState(
              () => weekDate = weekDate.subtract(const Duration(days: 7)),
            ),
            onNext: () => setState(
              () => weekDate = weekDate.add(const Duration(days: 7)),
            ),
          ),
          gap12,
          EcoCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n('Tổng chi phí ước tính', 'Estimated Total Cost'),
                  style: TextStyle(
                    fontSize: 8,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  '${money(total)} / ${money(300000)}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                gap8,
                LinearProgressIndicator(
                  value: total / 300000,
                  minHeight: 7,
                  borderRadius: BorderRadius.circular(10),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '${(total / 3000).round()}%',
                    style: TextStyle(
                      fontSize: 8,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
          gap12,
          SegmentedTabs(
            l10nList(
              const ['Tất cả', 'Đã mua', 'Chưa mua'],
              const ['All', 'Purchased', 'Pending'],
            ),
            selected: tab,
            onSelected: (i) => setState(() => tab = i),
          ),
          gap8,
          ...activeGroceryGroups.map(
            (g) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: EcoCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    Container(
                      key: ValueKey('grocery-header-${g.title}'),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .surfaceContainerHighest,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(18),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${g.icon}  ${g.title}',
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          Text(
                            money(g.items.fold(0, (s, x) => s + x.$2)),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ...g.items
                        .where(
                          (x) =>
                              tab == 0 ||
                              (tab == 1) == (checked[x.$1] ?? false),
                        )
                        .map(
                          (x) => CheckboxListTile(
                            dense: true,
                            visualDensity: VisualDensity.compact,
                            value: checked[x.$1] ?? false,
                            onChanged: (v) =>
                                setState(() => checked[x.$1] = v!),
                            title: Text(
                              x.$1,
                              style: const TextStyle(fontSize: 9),
                            ),
                            secondary: Text(
                              money(x.$2),
                              style: TextStyle(
                                fontSize: 9,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                              ),
                            ),
                            controlAffinity: ListTileControlAffinity.leading,
                          ),
                        ),
                  ],
                ),
              ),
            ),
          ),
          _TipCard(
            title: l10n('Mẹo tiết kiệm', 'Saving Tip'),
            text: l10n(
              'Mua thực phẩm theo mùa, chọn chợ sinh viên hoặc mua theo nhóm để tiết kiệm hơn.',
              'Buy seasonal produce, shop at local student markets or buy in bulk with friends to save more.',
            ),
          ),
          gap8,
          Text(
            '${l10n('Đã chọn:', 'Selected:')} ${money(bought)}',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 9,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class WorkoutsScreen extends StatefulWidget {
  const WorkoutsScreen({super.key});
  @override
  State<WorkoutsScreen> createState() => _WorkoutsScreenState();
}

class _WorkoutsScreenState extends State<WorkoutsScreen> {
  int tab = 0;
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    selectedDate = DateTime(now.year, now.month, now.day);
  }

  void _moveWeek(int amount) {
    setState(() {
      selectedDate = selectedDate.add(Duration(days: amount * 7));
    });
  }

  @override
  Widget build(BuildContext context) => EcoShell(
    title: l10n('Kế hoạch tập luyện', 'Workout Schedule'),
    selected: 2,
    child: ListView(
      padding: pagePadding,
      children: [
        _DatePicker(
          date: selectedDate,
          week: true,
          onPrevious: () => _moveWeek(-1),
          onNext: () => _moveWeek(1),
        ),
        gap8,
        DateStrip(
          weekOf: selectedDate,
          selectedDate: selectedDate,
          onSelected: (date) => setState(() => selectedDate = date),
        ),
        gap12,
        SegmentedTabs(
          l10nList(const ['Tuần này', 'Tất cả'], const ['This Week', 'All']),
          selected: tab,
          onSelected: (i) => setState(() => tab = i),
        ),
        gap12,
        ...List.generate(activeWorkoutDays.length, (i) {
          final w = activeWorkoutDays[i];
          return Padding(
            padding: const EdgeInsets.only(bottom: 9),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.exercise);
              },
              child: EcoCard(
                color: i == 0
                    ? (Theme.of(context).brightness == Brightness.dark
                          ? const Color(0xFF193122)
                          : const Color(0xFFEDF7EA))
                    : Theme.of(context).colorScheme.surface,
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Container(
                      width: 43,
                      height: 43,
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? const Color(0xFF223027)
                            : const Color(0xFFF3F5F1),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: Center(
                        child: Text(w.$4, style: const TextStyle(fontSize: 22)),
                      ),
                    ),
                    const SizedBox(width: 11),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${w.$1}${i == 0 ? ' · ${l10n('Hôm nay', 'Today')}' : ''}',
                            style: TextStyle(
                              fontSize: 8,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                          ),
                          Text(
                            w.$2,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            w.$3,
                            style: TextStyle(
                              fontSize: 8,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right, size: 18),
                  ],
                ),
              ),
            ),
          );
        }),
        gap8,
        QuoteCard(
          l10n(
            'Buổi tập hôm nay gồm 5 bài, khoảng 45 phút.',
            "Today's workout has 5 exercises and takes about 45 minutes.",
          ),
        ),
      ],
    ),
  );
}

class ExerciseDetailScreen extends StatefulWidget {
  const ExerciseDetailScreen({super.key});
  @override
  State<ExerciseDetailScreen> createState() => _ExerciseDetailScreenState();
}

class _ExerciseDetailScreenState extends State<ExerciseDetailScreen> {
  int tab = 0;
  int? previewing;
  @override
  Widget build(BuildContext context) => EcoShell(
    title: 'Upper Body',
    showNav: false,
    actions: [
      Padding(
        padding: const EdgeInsets.only(right: 16),
        child: Chip(
          avatar: const Icon(Icons.schedule, size: 14),
          label: Text(
            l10n('~45 phút', '~45 mins'),
            style: const TextStyle(fontSize: 9),
          ),
        ),
      ),
    ],
    child: ListView(
      padding: pagePadding,
      children: [
        Text(
          l10n('Ngực · Vai · Tay sau', 'Chest · Shoulders · Triceps'),
          style: TextStyle(
            fontSize: 10,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        gap12,
        SegmentedTabs(
          l10nList(const ['Bài tập', 'Ghi chú'], const ['Exercises', 'Notes']),
          selected: tab,
          onSelected: (i) => setState(() => tab = i),
        ),
        gap12,
        if (tab == 0)
          ...List.generate(activeExercises.length, (i) {
            final e = activeExercises[i];
            return Padding(
              padding: const EdgeInsets.only(bottom: 9),
              child: EcoCard(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 54,
                          height: 54,
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              e.$4,
                              style: const TextStyle(fontSize: 25),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${i + 1}. ${e.$1}',
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              Text(
                                e.$2,
                                style: TextStyle(
                                  fontSize: 8,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                                ),
                              ),
                              Text(
                                e.$3,
                                style: TextStyle(
                                  fontSize: 8,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton.filledTonal(
                          onPressed: () {
                            setState(
                              () => previewing = previewing == i ? null : i,
                            );
                          },
                          icon: Icon(
                            previewing == i ? Icons.pause : Icons.play_arrow,
                            size: 17,
                          ),
                        ),
                      ],
                    ),
                    if (previewing == i)
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(top: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${l10n('Hướng dẫn: giữ thân người ổn định, thực hiện chậm và kiểm soát nhịp thở. Nghỉ 60–90 giây giữa các hiệp', 'Keep your body stable, move slowly and control your breathing. Rest 60–90 seconds between sets of')} ${e.$1}.',
                          style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          })
        else
          TextField(
            maxLines: 8,
            decoration: InputDecoration(
              hintText: l10n('Ghi chú buổi tập...', 'Workout notes...'),
            ),
          ),
        gap8,
        FilledButton.icon(
          onPressed: () =>
              Navigator.pushNamed(context, AppRoutes.workoutSession),
          icon: const Icon(Icons.play_arrow),
          label: Text(l10n('Bắt đầu tập luyện', 'Start Workout Session')),
        ),
      ],
    ),
  );
}

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});
  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  int tab = 0;
  @override
  Widget build(BuildContext context) => EcoShell(
    title: l10n('Tiến độ của bạn', 'Your Progress'),
    selected: 3,
    child: ListView(
      padding: pagePadding,
      children: [
        SegmentedTabs(
          l10nList(
            const ['Tổng quan', 'Cân nặng', 'Chỉ số'],
            const ['Overview', 'Weight', 'Metrics'],
          ),
          selected: tab,
          onSelected: (i) => setState(() => tab = i),
        ),
        gap12,
        if (tab != 2)
          EcoCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionTitle(
                  l10n('Cân nặng (kg)', 'Body Weight (kg)'),
                  action: l10n('30 ngày qua ▾', 'Past 30 days ▾'),
                ),
                SizedBox(
                  height: 155,
                  child: CustomPaint(
                    painter: WeightChartPainter(),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Chip(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        label: Text(
                          '66.5 kg\n-3.5 kg',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 8,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '01/04',
                      style: TextStyle(
                        fontSize: 7,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      '08/04',
                      style: TextStyle(
                        fontSize: 7,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      '15/04',
                      style: TextStyle(
                        fontSize: 7,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      '22/04',
                      style: TextStyle(
                        fontSize: 7,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        if (tab != 2) gap12,
        if (tab != 1)
          Row(
            children: [
              Expanded(
                child: StatCard(
                  icon: Icons.eco,
                  label: 'BMI',
                  value: '22.1',
                  sub: l10n('Bình thường', 'Normal'),
                ),
              ),
              SizedBox(width: 7),
              Expanded(
                child: StatCard(
                  icon: Icons.local_fire_department_outlined,
                  label: 'BMR',
                  value: '1.520',
                  sub: l10n('kcal/ngày', 'kcal/day'),
                  color: Color(0xFFFFF7E8),
                ),
              ),
              SizedBox(width: 7),
              Expanded(
                child: StatCard(
                  icon: Icons.bar_chart,
                  label: 'TDEE',
                  value: '2.050',
                  sub: l10n('kcal/ngày', 'kcal/day'),
                  color: Color(0xFFEEF8F1),
                ),
              ),
            ],
          ),
        if (tab != 1) gap12,
        if (tab == 0)
          EcoCard(
            child: Column(
              children: [
                SectionTitle(
                  l10n('Chuỗi ngày duy trì', 'Active Streak'),
                  action: l10n('5 ngày', '5 days'),
                ),
                Row(
                  children: List.generate(
                    7,
                    (i) => Expanded(
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 15,
                            backgroundColor: i < 5
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context)
                                      .colorScheme
                                      .surfaceContainerHighest,
                            child: Text(
                              i < 5 ? '✓' : '○',
                              style: TextStyle(
                                fontSize: 10,
                                color: i < 5
                                    ? Colors.white
                                    : Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                              ),
                            ),
                          ),
                          Text(
                            l10nList(
                              const ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'],
                              const [
                                'Mon',
                                'Tue',
                                'Wed',
                                'Thu',
                                'Fri',
                                'Sat',
                                'Sun',
                              ],
                            )[i],
                            style: TextStyle(
                              fontSize: 7,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                gap8,
                const LinearProgressIndicator(value: .71, minHeight: 7),
              ],
            ),
          ),
        gap12,
        if (tab == 0)
          QuoteCard(
            l10n(
              'Bạn đã duy trì check-in 5 ngày liên tiếp.',
              'You have maintained a 5-day check-in streak.',
            ),
          ),
      ],
    ),
  );
}

class WeightChartPainter extends CustomPainter {
  const WeightChartPainter();
  @override
  void paint(Canvas canvas, Size size) {
    final line = Paint()
      ..color = const Color(0xFF4D8D59)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final fill = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0x557DBB77), Color(0x007DBB77)],
      ).createShader(Offset.zero & size);
    final path = Path()
      ..moveTo(5, 35)
      ..cubicTo(size.width * .18, 50, size.width * .28, 65, size.width * .4, 70)
      ..cubicTo(
        size.width * .58,
        80,
        size.width * .75,
        88,
        size.width - 5,
        105,
      );
    final area = Path.from(path)
      ..lineTo(size.width - 5, size.height)
      ..lineTo(5, size.height)
      ..close();
    canvas.drawPath(area, fill);
    canvas.drawPath(path, line);
    for (final p in [
      const Offset(5, 35),
      Offset(size.width * .4, 70),
      Offset(size.width * .75, 88),
      Offset(size.width - 5, 105),
    ])
      canvas.drawCircle(p, 5, Paint()..color = const Color(0xFF4D8D59));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class BodyMetricsScreen extends StatefulWidget {
  const BodyMetricsScreen({super.key});
  @override
  State<BodyMetricsScreen> createState() => _BodyMetricsScreenState();
}

class _BodyMetricsScreenState extends State<BodyMetricsScreen> {
  late int age;
  late String gender, goal;
  late double height, weight, activity;

  @override
  void initState() {
    super.initState();
    final appState = EcoFitAppState.instance;
    age = appState.age;
    gender = appState.gender;
    height = appState.height;
    weight = appState.weight;
    activity = appState.activity;
    goal = appState.goal;
  }

  @override
  Widget build(BuildContext context) {
    final m = calculateMetrics(
      age: age,
      gender: gender,
      height: height,
      weight: weight,
      activity: activity,
      goal: goal,
    );
    return EcoShell(
      title: l10n('Chỉ số cơ thể', 'Body Metrics'),
      showNav: false,
      child: ListView(
        padding: pagePadding,
        children: [
          _NumberField(
            l10n('Tuổi', 'Age'),
            age.toDouble(),
            (v) => setState(() => age = v.round()),
          ),
          gap8,
          Row(
            children: [
              SizedBox(
                width: 110,
                child: Text(
                  l10n('Giới tính', 'Gender'),
                  style: TextStyle(
                    fontSize: 10,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: ChoiceChip(
                        label: Text(l10n('♂ Nam', '♂ Male')),
                        selected: gender == 'male',
                        onSelected: (_) => setState(() => gender = 'male'),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: ChoiceChip(
                        label: Text(l10n('♀ Nữ', '♀ Female')),
                        selected: gender == 'female',
                        onSelected: (_) => setState(() => gender = 'female'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          gap8,
          _NumberField(
            l10n('Chiều cao', 'Height'),
            height,
            (v) => setState(() => height = v),
            suffix: 'cm',
          ),
          gap8,
          _NumberField(
            l10n('Cân nặng', 'Weight'),
            weight,
            (v) => setState(() => weight = v),
            suffix: 'kg',
          ),
          gap8,
          _SelectField(l10n('Mức độ hoạt động', 'Activity Level'), activity, {
            1.2: l10n('Ít vận động', 'Sedentary'),
            1.375: l10n(
              'Vận động nhẹ (1-3 buổi/tuần)',
              'Light (1-3 days/week)',
            ),
            1.55: l10n(
              'Vận động vừa (3-5 buổi/tuần)',
              'Moderate (3-5 days/week)',
            ),
            1.725: l10n('Vận động cao', 'Very Active'),
          }, (v) => setState(() => activity = v)),
          gap8,
          _SelectField(l10n('Mục tiêu', 'Goal'), goal, {
            'lose': l10n('Giảm cân', 'Weight Loss'),
            'maintain': l10n('Giữ cân', 'Maintain Weight'),
            'gain': l10n('Tăng cơ', 'Build Muscle'),
          }, (v) => setState(() => goal = v)),
          gap12,
          FilledButton(
            onPressed: () async {
              await EcoFitAppState.instance.updateMetrics(
                age: age,
                gender: gender,
                height: height,
                weight: weight,
                activity: activity,
                goal: goal,
              );
              if (!context.mounted) return;
              _toast(
                context,
                l10n(
                  'Đã lưu và tính lại chỉ số cơ thể',
                  'Body metrics saved and recalculated',
                ),
              );
            },
            child: Text(l10n('Tính chỉ số của tôi', 'Calculate My Metrics')),
          ),
          gap16,
          Text(
            l10n('Kết quả ước tính', 'Estimated Results'),
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
          ),
          gap8,
          Row(
            children: [
              Expanded(
                child: _MetricResult(Icons.eco, 'BMI', '${m.bmi}', m.bmiLabel),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _MetricResult(
                  Icons.local_fire_department,
                  'BMR',
                  '${m.bmr}',
                  l10n('kcal/ngày', 'kcal/day'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _MetricResult(
                  Icons.bar_chart,
                  'TDEE',
                  '${m.tdee}',
                  l10n('kcal/ngày', 'kcal/day'),
                ),
              ),
            ],
          ),
          gap12,
          _TipCard(
            title: l10n('Gợi ý', 'Advice'),
            text: l10n(
              'Đây là chỉ số ước tính. Hãy kết hợp chế độ ăn và tập luyện để đạt mục tiêu.',
              'These are estimates. Combine balanced nutrition with regular training to achieve your goals.',
            ),
          ),
        ],
      ),
    );
  }
}

class _NumberField extends StatelessWidget {
  const _NumberField(this.label, this.value, this.onChanged, {this.suffix});
  final String label;
  final double value;
  final ValueChanged<double> onChanged;
  final String? suffix;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      SizedBox(
        width: 110,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ),
      Expanded(
        child: TextFormField(
          initialValue: value == value.roundToDouble()
              ? '${value.round()}'
              : '$value',
          keyboardType: TextInputType.number,
          onChanged: (s) {
            final v = double.tryParse(s);
            if (v != null) onChanged(v);
          },
          decoration: InputDecoration(isDense: true, suffixText: suffix),
        ),
      ),
    ],
  );
}

class _SelectField<T> extends StatelessWidget {
  const _SelectField(this.label, this.value, this.values, this.onChanged);
  final String label;
  final T value;
  final Map<T, String> values;
  final ValueChanged<T> onChanged;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      SizedBox(
        width: 110,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ),
      Expanded(
        child: DropdownButtonFormField<T>(
          initialValue: value,
          isExpanded: true,
          decoration: const InputDecoration(isDense: true),
          items: values.entries
              .map(
                (e) => DropdownMenuItem(
                  value: e.key,
                  child: Text(e.value, style: const TextStyle(fontSize: 10)),
                ),
              )
              .toList(),
          onChanged: (v) => onChanged(v as T),
        ),
      ),
    ],
  );
}

class _MetricResult extends StatelessWidget {
  const _MetricResult(this.icon, this.label, this.value, this.sub);
  final IconData icon;
  final String label, value, sub;
  @override
  Widget build(BuildContext context) => EcoCard(
    padding: const EdgeInsets.all(9),
    child: Column(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary),
        Text(
          label,
          style: TextStyle(
            fontSize: 7,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
        ),
        Text(
          sub,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 7,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    ),
  );
}

class CheckInScreen extends StatefulWidget {
  const CheckInScreen({super.key});
  @override
  State<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends State<CheckInScreen> {
  double water = 1.5, sleep = 7.5;
  int steps = 6320, mood = 2;
  bool done = true;
  bool saved = false;
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    selectedDate = DateTime(now.year, now.month, now.day);
  }

  @override
  Widget build(BuildContext context) => EcoShell(
    title: l10n('Check-in hằng ngày', 'Daily Check-in'),
    child: ListView(
      padding: pagePadding,
      children: [
        _DatePicker(
          date: selectedDate,
          onPrevious: () => setState(
            () => selectedDate = selectedDate.subtract(const Duration(days: 1)),
          ),
          onNext: () => setState(
            () => selectedDate = selectedDate.add(const Duration(days: 1)),
          ),
        ),
        gap12,
        DateStrip(
          weekOf: selectedDate,
          selectedDate: selectedDate,
          onSelected: (date) => setState(() => selectedDate = date),
        ),
        gap12,
        _CounterCard(
          icon: Icons.water_drop_outlined,
          label: l10n('Uống nước', 'Water Intake'),
          value: '${water.toStringAsFixed(1)} / 2.0 ${l10n('lít', 'liters')}',
          minus: () => setState(() => water = (water - .25).clamp(0, 3)),
          plus: () => setState(() => water = (water + .25).clamp(0, 3)),
        ),
        _CounterCard(
          icon: Icons.bedtime_outlined,
          label: l10n('Ngủ đủ giấc', 'Adequate Sleep'),
          value: '${sleep.toStringAsFixed(1)} / 8 ${l10n('giờ', 'hours')}',
          minus: () => setState(() => sleep = (sleep - .5).clamp(0, 12)),
          plus: () => setState(() => sleep = (sleep + .5).clamp(0, 12)),
        ),
        _CounterCard(
          icon: Icons.directions_walk,
          label: l10n('Đi bộ / Vận động', 'Walking / Steps'),
          value: '$steps / 8.000 ${l10n('bước', 'steps')}',
          minus: () => setState(() => steps = (steps - 500).clamp(0, 99999)),
          plus: () => setState(() => steps += 500),
        ),
        EcoCard(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '🙂 ${l10n('Tâm trạng', 'Mood')}',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      l10n(
                        'Hôm nay bạn thấy thế nào?',
                        'How are you feeling today?',
                      ),
                      style: TextStyle(
                        fontSize: 8,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              ...List.generate(
                5,
                (i) => InkWell(
                  onTap: () => setState(() => mood = i),
                  child: Container(
                    margin: const EdgeInsets.only(left: 3),
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: mood == i
                          ? Theme.of(context).colorScheme.primaryContainer
                          : Theme.of(context)
                                .colorScheme
                                .surfaceContainerHighest,
                      shape: BoxShape.circle,
                      border: mood == i
                          ? Border.all(
                              color: Theme.of(context).colorScheme.primary,
                              width: 2,
                            )
                          : null,
                    ),
                    child: Text(['😞', '😐', '🙂', '😊', '😁'][i]),
                  ),
                ),
              ),
            ],
          ),
        ),
        gap8,
        InkWell(
          onTap: () => setState(() => done = !done),
          child: EcoCard(
            color: done
                ? (Theme.of(context).brightness == Brightness.dark
                      ? const Color(0xFF193122)
                      : const Color(0xFFEEF7EB))
                : Theme.of(context).colorScheme.surface,
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Icon(
                  Icons.fitness_center,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n('Tập luyện', 'Workout'),
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        done
                            ? l10n('Đã hoàn thành', 'Completed')
                            : l10n('Chưa hoàn thành', 'Incomplete'),
                        style: TextStyle(
                          fontSize: 8,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  done ? '✓' : '○',
                  style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
        gap12,
        Text(
          l10n('Ghi chú thêm (tuỳ chọn)', 'Additional Notes (optional)'),
          style: TextStyle(
            fontSize: 9,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        gap8,
        TextField(
          maxLines: 3,
          decoration: InputDecoration(
            hintText: l10n(
              'Hôm nay mình cảm thấy rất tốt!',
              "I'm feeling energized and ready today!",
            ),
          ),
        ),
        gap12,
        if (saved) ...[
          EcoCard(
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    ecoFitIsEnglish
                        ? 'Saved: ${water.toStringAsFixed(1)} liters water · ${sleep.toStringAsFixed(1)} hours sleep · $steps steps.'
                        : 'Đã ghi nhận: ${water.toStringAsFixed(1)} lít nước · ${sleep.toStringAsFixed(1)} giờ ngủ · $steps bước.',
                  ),
                ),
              ],
            ),
          ),
          gap12,
        ],
        FilledButton(
          onPressed: () => setState(() => saved = true),
          child: Text(
            saved
                ? l10n('Cập nhật check-in', 'Update check-in')
                : l10n('Lưu check-in', 'Save Check-in'),
          ),
        ),
      ],
    ),
  );
}

class _CounterCard extends StatelessWidget {
  const _CounterCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.minus,
    required this.plus,
  });
  final IconData icon;
  final String label, value;
  final VoidCallback minus, plus;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 9),
    child: EcoCard(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFF4B94C7), size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 8,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          IconButton.filledTonal(
            onPressed: minus,
            icon: const Icon(Icons.remove, size: 17),
          ),
          const SizedBox(width: 4),
          IconButton.filledTonal(
            onPressed: plus,
            icon: const Icon(Icons.add, size: 17),
          ),
        ],
      ),
    ),
  );
}

class AiCoachScreen extends StatefulWidget {
  const AiCoachScreen({super.key});
  @override
  State<AiCoachScreen> createState() => _AiCoachScreenState();
}

class _AiCoachScreenState extends State<AiCoachScreen> {
  final controller = TextEditingController();
  late final messages = <(bool, String)>[
    (
      false,
      l10n(
        'Xin chào Minh Anh! 👋 Mình là Eco Coach. Mình có thể gợi ý thực đơn, bài tập phù hợp với mục tiêu, thời gian và ngân sách của bạn.',
        "Hello Minh Anh! 👋 I'm Eco Coach. I can recommend meals and workouts tailored to your goals, schedule, and budget.",
      ),
    ),
    (
      true,
      l10n(
        'Gợi ý thực đơn 1 ngày đủ chất với ngân sách 50k cho sinh viên',
        'Suggest a healthy 1-day meal plan for students on a 50k budget.',
      ),
    ),
    (
      false,
      l10n(
        'Gợi ý hôm nay: sáng yến mạch + chuối + trứng, trưa cơm gà rau củ, tối cá basa + rau. Tổng khoảng 48.000đ và ưu tiên protein.',
        "Today's suggestion: oatmeal, banana and egg for breakfast; chicken rice with vegetables for lunch; fish and vegetables for dinner. Total about 48,000 VND.",
      ),
    ),
  ];
  void send() {
    final text = controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      messages.add((true, text));
      controller.clear();
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewportWidth = MediaQuery.sizeOf(context).width;
    final chatMaxWidth = viewportWidth >= 980 ? 640.0 : viewportWidth * .82;
    final chips = l10nList(
      const [
        'Gợi ý bữa ăn',
        'Lên lịch tập',
        'Tư vấn dinh dưỡng',
        'Tập tại nhà',
        'Chi phí sinh viên',
        'Khác',
      ],
      const [
        'Meal Ideas',
        'Workout Plan',
        'Nutrition Advice',
        'Home Workout',
        'Student Budget',
        'Other',
      ],
    );
    return EcoShell(
      title: 'Eco Coach',
      child: ListView(
        padding: pagePadding,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                child: Icon(
                  Icons.eco,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n('Hỏi Eco Coach', 'Ask Eco Coach'),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      l10n(
                        'Trao đổi về bữa ăn và lịch tập của bạn',
                        'Discuss your meals and workout plan',
                      ),
                      style: TextStyle(
                        fontSize: 11,
                        height: 1.35,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          gap12,
          ...messages.map(
            (m) => Align(
              alignment: m.$1 ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(11),
                constraints: BoxConstraints(maxWidth: chatMaxWidth),
                decoration: BoxDecoration(
                  color: m.$1
                      ? (Theme.of(context).brightness == Brightness.dark
                            ? const Color(0xFF1D4429)
                            : const Color(0xFFDFF0D9))
                      : Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(15),
                    topRight: const Radius.circular(15),
                    bottomLeft: Radius.circular(m.$1 ? 15 : 5),
                    bottomRight: Radius.circular(m.$1 ? 5 : 15),
                  ),
                  border: Border.all(color: Theme.of(context).dividerColor),
                ),
                child: Text(
                  m.$2,
                  style: const TextStyle(fontSize: 13, height: 1.45),
                ),
              ),
            ),
          ),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: chips
                .map(
                  (c) => ActionChip(
                    onPressed: () => controller.text = c,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 5,
                    ),
                    label: Text(
                      c,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    side: const BorderSide(color: Color(0xFFCFE0CC)),
                    backgroundColor: Theme.of(context).colorScheme.surface,
                  ),
                )
                .toList(),
          ),
          gap12,
          EcoCard(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                const Text('🥣', style: TextStyle(fontSize: 28)),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n('Bữa sáng (~12k)', 'Breakfast (~12k)'),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        l10n(
                          'Cháo yến mạch + chuối + 1 quả trứng luộc',
                          'Oatmeal + banana + 1 boiled egg',
                        ),
                        style: TextStyle(
                          fontSize: 11,
                          height: 1.35,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          gap12,
          TextField(
            controller: controller,
            onSubmitted: (_) => send(),
            style: const TextStyle(fontSize: 14),
            decoration: InputDecoration(
              prefixIcon: IconButton(
                onPressed: () => _showAttachmentPicker(context),
                icon: const Icon(Icons.attach_file),
                tooltip: l10n('Đính kèm', 'Attach'),
              ),
              hintText: l10n('Nhập tin nhắn...', 'Type your question...'),
              hintStyle: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              suffixIcon: IconButton.filled(
                onPressed: send,
                icon: const Icon(Icons.send, size: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late bool reminders;

  @override
  void initState() {
    super.initState();
    reminders = EcoFitAppState.instance.dailyReminders;
  }

  Future<void> _editProfile() async {
    final appState = EcoFitAppState.instance;
    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) => _ProfileEditorSheet(appState: appState),
    );

    if (!mounted || saved != true) return;
    setState(() {});
    _toast(context, l10n('Đã lưu thay đổi hồ sơ', 'Profile updated'));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dark = theme.brightness == Brightness.dark;
    return EcoShell(
      title: l10n('Cá nhân', 'Profile'),
      selected: 4,
      actions: [
        TextButton(
          onPressed: _editProfile,
          child: Text(
            l10n('Chỉnh sửa', 'Edit'),
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800),
          ),
        ),
      ],
      child: ListView(
        padding: pagePadding,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 32,
                backgroundColor: dark
                    ? const Color(0xFFDDE9B4)
                    : const Color(0xFFB4D4A9),
                child: Text(
                  EcoFitAppState.instance.initials,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF173126),
                  ),
                ),
              ),
              SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      EcoFitAppState.instance.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      ecoFitIsEnglish
                          ? '${EcoFitAppState.instance.school} student'
                          : 'Sinh viên ${EcoFitAppState.instance.school}',
                      style: const TextStyle(fontSize: 11),
                    ),
                    Text(
                      l10n(
                        'Sống khỏe hơn mỗi ngày 🌱',
                        'Living healthier every day 🌱',
                      ),
                      style: TextStyle(
                        fontSize: 10,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          gap16,
          Row(
            children: [
              for (final s in [
                ('128', l10n('ngày đồng hành', 'days active')),
                ('12', l10n('huy hiệu', 'badges')),
                ('5', l10n('mục tiêu hoàn thành', 'goals reached')),
              ])
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: EcoCard(
                      padding: const EdgeInsets.symmetric(
                        vertical: 11,
                        horizontal: 4,
                      ),
                      child: Column(
                        children: [
                          Text(
                            s.$1,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            s.$2,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 9,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
          gap12,
          EcoCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _Setting(
                  Icons.person_outline,
                  l10n('Thông tin tài khoản', 'Account Information'),
                  onTap: () =>
                      Navigator.pushNamed(
                        context,
                        AppRoutes.accountSettings,
                      ).then((_) {
                        if (mounted) setState(() {});
                      }),
                ),
                _Setting(
                  Icons.notifications_outlined,
                  l10n('Thông báo', 'Notifications'),
                  onTap: () => Navigator.pushNamed(
                    context,
                    AppRoutes.notificationSettings,
                  ),
                ),
                SwitchListTile(
                  dense: false,
                  visualDensity: VisualDensity.compact,
                  value: reminders,
                  onChanged: (v) {
                    setState(() => reminders = v);
                    EcoFitAppState.instance.updateDailyReminders(v);
                  },
                  secondary: Icon(
                    Icons.alarm_outlined,
                    color: theme.colorScheme.primary,
                  ),
                  title: Text(
                    l10n('Nhắc nhở hằng ngày', 'Daily Reminders'),
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                _Setting(
                  Icons.language,
                  l10n('Ngôn ngữ', 'Language'),
                  value: EcoFitAppState.instance.language == 'en'
                      ? 'English'
                      : 'Tiếng Việt',
                  onTap: () =>
                      Navigator.pushNamed(
                        context,
                        AppRoutes.languageSettings,
                      ).then((_) {
                        if (mounted) setState(() {});
                      }),
                ),
                _Setting(
                  dark ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
                  l10n('Giao diện', 'Theme'),
                  value: switch (EcoFitAppState.instance.appearance) {
                    'dark' => l10n('Tối', 'Dark'),
                    'light' => l10n('Sáng', 'Light'),
                    _ => l10n('Theo hệ thống', 'System'),
                  },
                  onTap: () =>
                      Navigator.pushNamed(
                        context,
                        AppRoutes.appearanceSettings,
                      ).then((_) {
                        if (mounted) setState(() {});
                      }),
                ),
                _Setting(
                  Icons.smart_toy_outlined,
                  'Eco Coach',
                  onTap: () => Navigator.pushNamed(context, AppRoutes.coach),
                ),
                _Setting(
                  Icons.help_outline,
                  l10n('Trợ giúp & Phản hồi', 'Help & Feedback'),
                  onTap: () => Navigator.pushNamed(context, AppRoutes.help),
                ),
                _Setting(
                  Icons.info_outline,
                  l10n('Giới thiệu về Eco Fit', 'About Eco Fit'),
                  onTap: () => Navigator.pushNamed(context, AppRoutes.about),
                ),
              ],
            ),
          ),
          gap12,
          FilledButton.tonalIcon(
            onPressed: () => Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.login,
              (_) => false,
            ),
            style: FilledButton.styleFrom(
              backgroundColor: dark
                  ? const Color(0xFF38231F)
                  : const Color(0xFFFFF0ED),
              foregroundColor: dark
                  ? const Color(0xFFF87171)
                  : const Color(0xFFD95748),
            ),
            icon: const Icon(Icons.logout),
            label: Text(l10n('Đăng xuất', 'Log Out')),
          ),
        ],
      ),
    );
  }
}

class _ProfileEditorSheet extends StatefulWidget {
  const _ProfileEditorSheet({required this.appState});

  final EcoFitAppState appState;

  @override
  State<_ProfileEditorSheet> createState() => _ProfileEditorSheetState();
}

class _ProfileEditorSheetState extends State<_ProfileEditorSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _schoolController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.appState.name);
    _schoolController = TextEditingController(text: widget.appState.school);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _schoolController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_nameController.text.trim().isEmpty ||
        _schoolController.text.trim().isEmpty) {
      _toast(
        context,
        l10n(
          'Vui lòng nhập đủ họ tên và trường học',
          'Please enter your full name and school',
        ),
      );
      return;
    }
    await widget.appState.updateProfile(
      name: _nameController.text,
      school: _schoolController.text,
    );
    if (!mounted) return;
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: EdgeInsets.fromLTRB(
      24,
      24,
      24,
      MediaQuery.viewInsetsOf(context).bottom + 24,
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          l10n('Chỉnh sửa hồ sơ', 'Edit Profile'),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
        ),
        gap16,
        TextField(
          controller: _nameController,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(labelText: l10n('Họ tên', 'Full name')),
        ),
        gap12,
        TextField(
          controller: _schoolController,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => _save(),
          decoration: InputDecoration(labelText: l10n('Trường học', 'School')),
        ),
        gap16,
        FilledButton(
          onPressed: _save,
          child: Text(l10n('Lưu thay đổi', 'Save changes')),
        ),
      ],
    ),
  );
}

class _Setting extends StatelessWidget {
  const _Setting(this.icon, this.label, {this.value, required this.onTap});
  final IconData icon;
  final String label;
  final String? value;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => ListTile(
    dense: false,
    visualDensity: VisualDensity.compact,
    contentPadding: const EdgeInsets.symmetric(horizontal: 14),
    onTap: onTap,
    leading: Icon(icon, size: 22, color: Theme.of(context).colorScheme.primary),
    title: Text(
      label,
      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
    ),
    trailing: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (value != null)
          Text(
            value!,
            style: TextStyle(
              fontSize: 11,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        Icon(
          Icons.chevron_right,
          size: 20,
          color: Theme.of(context).colorScheme.primary,
        ),
      ],
    ),
  );
}

enum _SettingsKind { account, notifications, language, appearance, help, about }

class SettingsDetailScreen extends StatefulWidget {
  const SettingsDetailScreen.account({super.key})
    : kind = _SettingsKind.account;
  const SettingsDetailScreen.notifications({super.key})
    : kind = _SettingsKind.notifications;
  const SettingsDetailScreen.language({super.key})
    : kind = _SettingsKind.language;
  const SettingsDetailScreen.appearance({super.key})
    : kind = _SettingsKind.appearance;
  const SettingsDetailScreen.help({super.key}) : kind = _SettingsKind.help;
  const SettingsDetailScreen.about({super.key}) : kind = _SettingsKind.about;

  final _SettingsKind kind;
  @override
  State<SettingsDetailScreen> createState() => _SettingsDetailScreenState();
}

class _SettingsDetailScreenState extends State<SettingsDetailScreen> {
  late final TextEditingController nameController;
  late final TextEditingController schoolController;
  final feedbackController = TextEditingController();
  bool mealReminder = true;
  bool workoutReminder = true;
  bool weeklyReport = false;
  String language = 'vi';
  String appearance = 'system';
  bool feedbackSent = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: EcoFitAppState.instance.name);
    schoolController = TextEditingController(
      text: EcoFitAppState.instance.school,
    );
    final appState = EcoFitAppState.instance;
    mealReminder = appState.mealReminder;
    workoutReminder = appState.workoutReminder;
    weeklyReport = appState.weeklyReport;
    language = appState.language;
    appearance = appState.appearance;
  }

  @override
  void dispose() {
    nameController.dispose();
    schoolController.dispose();
    feedbackController.dispose();
    super.dispose();
  }

  String get title => switch (widget.kind) {
    _SettingsKind.account => l10n('Thông tin tài khoản', 'Account Information'),
    _SettingsKind.notifications => l10n('Thông báo', 'Notifications'),
    _SettingsKind.language => l10n('Ngôn ngữ', 'Language'),
    _SettingsKind.appearance => l10n('Giao diện', 'Theme'),
    _SettingsKind.help => l10n('Trợ giúp & Phản hồi', 'Help & Feedback'),
    _SettingsKind.about => l10n('Về Eco Fit', 'About Eco Fit'),
  };

  Future<void> saveAccount() async {
    if (nameController.text.trim().isEmpty ||
        schoolController.text.trim().isEmpty) {
      _toast(
        context,
        l10n(
          'Vui lòng nhập đủ họ tên và trường học',
          'Please enter your full name and school',
        ),
      );
      return;
    }
    await EcoFitAppState.instance.updateProfile(
      name: nameController.text,
      school: schoolController.text,
    );
    if (!mounted) return;
    _toast(
      context,
      l10n('Đã lưu thông tin tài khoản', 'Account information saved'),
    );
  }

  void saveNotifications() {
    EcoFitAppState.instance.updateNotifications(
      meal: mealReminder,
      workout: workoutReminder,
      weekly: weeklyReport,
    );
  }

  @override
  Widget build(BuildContext context) => EcoShell(
    title: title,
    showNav: false,
    child: ListView(
      padding: pagePadding,
      children: [
        if (widget.kind == _SettingsKind.account) ...[
          Text(
            l10n(
              'Thông tin hiển thị trong hồ sơ của bạn.',
              'Information displayed on your profile.',
            ),
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          gap16,
          TextField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: l10n('Họ và tên', 'Full name'),
            ),
          ),
          gap12,
          TextField(
            controller: schoolController,
            decoration: InputDecoration(
              labelText: l10n('Trường học', 'School'),
            ),
          ),
          gap16,
          FilledButton(
            onPressed: saveAccount,
            child: Text(l10n('Lưu thông tin', 'Save information')),
          ),
        ] else if (widget.kind == _SettingsKind.notifications) ...[
          Text(
            l10n(
              'Chọn những lời nhắc thật sự hữu ích với lịch sinh hoạt của bạn.',
              'Choose reminders that are useful for your routine.',
            ),
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          gap12,
          EcoCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                SwitchListTile(
                  title: Text(l10n('Nhắc bữa ăn', 'Meal reminders')),
                  subtitle: Text(
                    l10n('Trước giờ ăn 15 phút', '15 minutes before meal time'),
                  ),
                  value: mealReminder,
                  onChanged: (v) {
                    setState(() => mealReminder = v);
                    saveNotifications();
                  },
                ),
                SwitchListTile(
                  title: Text(l10n('Nhắc lịch tập', 'Workout reminders')),
                  subtitle: Text(
                    l10n(
                      'Theo kế hoạch tập trong tuần',
                      'Based on your weekly workout plan',
                    ),
                  ),
                  value: workoutReminder,
                  onChanged: (v) {
                    setState(() => workoutReminder = v);
                    saveNotifications();
                  },
                ),
                SwitchListTile(
                  title: Text(l10n('Báo cáo cuối tuần', 'Weekly report')),
                  subtitle: Text(
                    l10n(
                      'Tóm tắt tiến độ vào tối Chủ nhật',
                      'Progress summary on Sunday evening',
                    ),
                  ),
                  value: weeklyReport,
                  onChanged: (v) {
                    setState(() => weeklyReport = v);
                    saveNotifications();
                  },
                ),
              ],
            ),
          ),
        ] else if (widget.kind == _SettingsKind.language) ...[
          Text(
            l10n(
              'Ngôn ngữ sử dụng trong ứng dụng.',
              'Language used throughout the application.',
            ),
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          gap12,
          EcoCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: const [('vi', 'Tiếng Việt'), ('en', 'English')]
                  .map(
                    (item) => ListTile(
                      title: Text(item.$2),
                      leading: Icon(
                        language == item.$1
                            ? Icons.radio_button_checked
                            : Icons.radio_button_off,
                        color: language == item.$1
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      onTap: () {
                        setState(() => language = item.$1);
                        EcoFitAppState.instance.updateLanguage(item.$1);
                      },
                    ),
                  )
                  .toList(),
            ),
          ),
        ] else if (widget.kind == _SettingsKind.appearance) ...[
          Text(
            l10n(
              'Eco Fit dùng màu đất và xanh lá dịu để dễ nhìn lâu.',
              'Choose the appearance that is most comfortable for you.',
            ),
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          gap12,
          EcoCard(
            padding: EdgeInsets.zero,
            child: Column(
              children:
                  [
                        (
                          'system',
                          ecoFitIsEnglish ? 'System' : 'Theo hệ thống',
                        ),
                        ('light', ecoFitIsEnglish ? 'Light' : 'Sáng'),
                        ('dark', ecoFitIsEnglish ? 'Dark' : 'Tối'),
                      ]
                      .map(
                        (item) => ListTile(
                          title: Text(item.$2),
                          leading: Icon(
                            appearance == item.$1
                                ? Icons.radio_button_checked
                                : Icons.radio_button_off,
                            color: appearance == item.$1
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                          ),
                          onTap: () {
                            setState(() => appearance = item.$1);
                            EcoFitAppState.instance.updateAppearance(item.$1);
                          },
                        ),
                      )
                      .toList(),
            ),
          ),
        ] else if (widget.kind == _SettingsKind.help) ...[
          Text(
            l10n('Bạn đang gặp vấn đề gì?', 'How can we help?'),
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
          gap12,
          EcoCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n('Câu hỏi thường gặp', 'Frequently asked questions'),
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n(
                    '• Cách thay đổi mục tiêu dinh dưỡng\n• Dữ liệu check-in được lưu ở đâu\n• Cách bắt đầu một buổi tập',
                    '• How to change nutrition goals\n• Where check-in data is stored\n• How to start a workout',
                  ),
                ),
              ],
            ),
          ),
          gap12,
          TextField(
            controller: feedbackController,
            maxLines: 5,
            decoration: InputDecoration(
              labelText: l10n('Gửi góp ý', 'Send feedback'),
              hintText: l10n(
                'Mô tả ngắn vấn đề bạn gặp...',
                'Briefly describe the issue...',
              ),
            ),
          ),
          gap12,
          if (feedbackSent)
            EcoCard(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Text(
                l10n(
                  'Đã ghi nhận góp ý. Cảm ơn bạn đã giúp Eco Fit tốt hơn.',
                  'Feedback received. Thank you for helping improve Eco Fit.',
                ),
              ),
            ),
          FilledButton(
            onPressed: () {
              if (feedbackController.text.trim().isEmpty) {
                _toast(
                  context,
                  l10n('Hãy nhập nội dung góp ý', 'Please enter your feedback'),
                );
                return;
              }
              setState(() => feedbackSent = true);
            },
            child: Text(l10n('Gửi góp ý', 'Send feedback')),
          ),
        ] else ...[
          const Center(child: EcoLogo(large: true)),
          gap16,
          const Text(
            'Eco Fit 1.0.0',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
          ),
          Text(
            l10n(
              'Ứng dụng đồng hành sức khoẻ dành cho sinh viên và người trẻ, tập trung vào những thói quen có thể duy trì mỗi ngày.',
              'A health companion for students and young adults, focused on sustainable daily habits.',
            ),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          gap16,
          EcoCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n('Cam kết của Eco Fit', "Eco Fit's commitment"),
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n(
                    'Eco Fit giúp bạn theo dõi dinh dưỡng, lập kế hoạch bữa ăn theo ngân sách, quản lý danh sách mua sắm, xây dựng lịch tập, check-in và quan sát tiến độ trong cùng một nơi. Dữ liệu được trình bày rõ ràng, gợi ý thực tế và không tạo áp lực phải hoàn hảo.',
                    'Eco Fit brings nutrition, budget meal planning, groceries, workouts, check-ins and progress into one clear place, with practical guidance and no pressure to be perfect.',
                  ),
                ),
              ],
            ),
          ),
          gap12,
          EcoCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n('Quyền riêng tư và dữ liệu', 'Privacy and data'),
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n(
                    'Thông tin hồ sơ, chỉ số cơ thể và các thiết lập hiện được lưu trên thiết bị của bạn. Eco Fit không bán dữ liệu cá nhân. Khi tính năng đồng bộ được triển khai, bạn sẽ luôn được thông báo và có quyền lựa chọn.',
                    'Your profile, body metrics and settings are stored on your device. Eco Fit does not sell personal data. You will remain in control when sync is introduced.',
                  ),
                ),
              ],
            ),
          ),
          gap12,
          EcoCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n('Lưu ý sức khoẻ', 'Health notice'),
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n(
                    'BMI, BMR, TDEE và các gợi ý trong ứng dụng chỉ mang tính tham khảo. Eco Fit không thay thế chẩn đoán, điều trị hoặc tư vấn từ bác sĩ và chuyên gia dinh dưỡng.',
                    'BMI, BMR, TDEE and in-app guidance are estimates. Eco Fit does not replace medical or dietetic advice.',
                  ),
                ),
              ],
            ),
          ),
          gap12,
          Text(
            l10n(
              'Phiên bản 1.0.0 · © 2026 Eco Fit\nThiết kế và phát triển tại Việt Nam',
              'Version 1.0.0 · © 2026 Eco Fit\nDesigned and developed in Vietnam',
            ),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ],
    ),
  );
}

class WorkoutSessionScreen extends StatefulWidget {
  const WorkoutSessionScreen({super.key});
  @override
  State<WorkoutSessionScreen> createState() => _WorkoutSessionScreenState();
}

class _WorkoutSessionScreenState extends State<WorkoutSessionScreen> {
  int exercise = 0;
  final completed = <int>{};
  bool finished = false;

  @override
  Widget build(BuildContext context) {
    final item = activeExercises[exercise];
    return EcoShell(
      title: l10n('Buổi tập đang diễn ra', 'Workout in progress'),
      showNav: false,
      child: ListView(
        padding: pagePadding,
        children: [
          LinearProgressIndicator(
            value: finished ? 1 : (exercise + 1) / activeExercises.length,
            minHeight: 8,
            borderRadius: BorderRadius.circular(8),
          ),
          gap16,
          if (finished)
            EcoCard(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Column(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: Theme.of(context).colorScheme.primary,
                    size: 54,
                  ),
                  gap8,
                  Text(
                    l10n('Đã hoàn thành buổi tập', 'Workout completed'),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    ecoFitIsEnglish
                        ? '${completed.length} exercises recorded.'
                        : '${completed.length} bài đã được ghi nhận.',
                  ),
                  gap12,
                  FilledButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      l10n('Về kế hoạch tập', 'Back to workout plan'),
                    ),
                  ),
                ],
              ),
            )
          else ...[
            Text(
              '${l10n('Bài', 'Exercise')} ${exercise + 1}/${activeExercises.length}',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(item.$1, style: Theme.of(context).textTheme.headlineLarge),
            Text(
              '${item.$2} · ${item.$3}',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            gap16,
            EcoCard(
              child: Column(
                children: [
                  Text(item.$4, style: const TextStyle(fontSize: 72)),
                  gap12,
                  Text(
                    l10n(
                      'Thực hiện chậm, giữ đúng tư thế và thở đều. Dừng lại nếu thấy đau bất thường.',
                      'Move slowly, maintain proper form and breathe evenly. Stop if you feel unusual pain.',
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            gap16,
            FilledButton.icon(
              onPressed: () {
                setState(() {
                  completed.add(exercise);
                  if (exercise == activeExercises.length - 1) {
                    finished = true;
                  } else {
                    exercise++;
                  }
                });
              },
              icon: const Icon(Icons.check),
              label: Text(
                exercise == activeExercises.length - 1
                    ? l10n('Hoàn thành buổi tập', 'Finish workout')
                    : l10n('Hoàn thành bài này', 'Complete this exercise'),
              ),
            ),
            gap8,
            OutlinedButton(
              onPressed: () => setState(() {
                if (exercise < activeExercises.length - 1) exercise++;
              }),
              child: Text(l10n('Bỏ qua bài này', 'Skip this exercise')),
            ),
          ],
        ],
      ),
    );
  }
}

class _TipCard extends StatelessWidget {
  const _TipCard({required this.title, required this.text});
  final String title, text;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF193122)
          : const Color(0xFFEFF7E8),
      borderRadius: BorderRadius.circular(14),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.lightbulb_outline,
          color: Theme.of(context).brightness == Brightness.dark
              ? const Color(0xFFC5EDD0)
              : const Color(0xFF56745A),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 10,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? const Color(0xFFC5EDD0)
                      : const Color(0xFF56745A),
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                text,
                style: TextStyle(
                  fontSize: 8,
                  height: 1.45,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? const Color(0xFFC5EDD0)
                      : const Color(0xFF56745A),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
