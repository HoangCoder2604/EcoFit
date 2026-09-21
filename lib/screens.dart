import 'package:flutter/material.dart';

import 'data.dart';
import 'theme.dart';
import 'widgets.dart';

const pagePadding = EdgeInsets.fromLTRB(16, 8, 16, 24);
const gap8 = SizedBox(height: 8);
const gap12 = SizedBox(height: 12);
const gap16 = SizedBox(height: 16);

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
          child: const Text('Đóng'),
        ),
      ],
    ),
  );
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 46, 24, 28),
        child: Column(
          children: [
            const EcoLogo(large: true),
            gap16,
            const Text(
              'Sống khỏe hơn hôm nay\ncho ngày mai tươi sáng',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 19,
                height: 1.45,
                fontWeight: FontWeight.w700,
                color: Color(0xFF415044),
              ),
            ),
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    bottom: 38,
                    child: Container(
                      width: 290,
                      height: 240,
                      decoration: const BoxDecoration(
                        color: Color(0xFFDCEFD7),
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(145),
                        ),
                      ),
                    ),
                  ),
                  const Positioned(
                    top: 90,
                    child: Text('🙂', style: TextStyle(fontSize: 90)),
                  ),
                  const Positioned(
                    bottom: 70,
                    child: Text('🎒', style: TextStyle(fontSize: 115)),
                  ),
                  const Positioned(
                    right: 28,
                    top: 55,
                    child: Text('☀️', style: TextStyle(fontSize: 28)),
                  ),
                  const Positioned(
                    right: 0,
                    top: 105,
                    child: Text(
                      'Healthy students\nBrighter tomorrows',
                      style: TextStyle(
                        fontSize: 15,
                        color: Color(0xFF468053),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                  const Positioned(
                    left: 20,
                    top: 170,
                    child: Icon(Icons.eco, color: Color(0xFF6EA365)),
                  ),
                ],
              ),
            ),
            FilledButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/onboarding-food'),
              icon: const Icon(Icons.arrow_forward),
              iconAlignment: IconAlignment.end,
              label: const Text('Bắt đầu hành trình'),
            ),
          ],
        ),
      ),
    ),
  );
}

class FoodOnboardingScreen extends StatelessWidget {
  const FoodOnboardingScreen({super.key});
  @override
  Widget build(BuildContext context) => OnboardingLayout(
    eyebrow: 'DINH DƯỠNG CÁ NHÂN HÓA',
    title: 'Ăn ngon, đủ chất\ndù là sinh viên',
    description:
        'Thực đơn cá nhân hóa, dễ nấu, tiết kiệm và vẫn đầy đủ dinh dưỡng.',
    art: Stack(
      alignment: Alignment.center,
      children: const [
        Text('🥗', style: TextStyle(fontSize: 125)),
        Positioned(
          right: 2,
          top: 22,
          child: Bubble('Ăn tốt\nkhông cần tốn kém!'),
        ),
      ],
    ),
    features: const [
      (
        Icons.restaurant,
        'Gợi ý bữa ăn theo mục tiêu',
        'Tăng cơ, giảm cân hay giữ dáng',
      ),
      (
        Icons.savings_outlined,
        'Phù hợp ngân sách sinh viên',
        'Ngon, bổ, dễ tìm nguyên liệu',
      ),
      (
        Icons.pie_chart_outline,
        'Tính calories & macros',
        'Đủ protein, carb, fat cho cơ thể',
      ),
    ],
    dot: 0,
    next: '/onboarding-workout',
  );
}

class WorkoutOnboardingScreen extends StatelessWidget {
  const WorkoutOnboardingScreen({super.key});
  @override
  Widget build(BuildContext context) => OnboardingLayout(
    eyebrow: 'TẬP LUYỆN KHOA HỌC',
    title: 'Tập luyện hiệu quả\nTiến bộ mỗi ngày',
    description: 'Kế hoạch tập luyện cá nhân hóa, phù hợp với thể trạng và mục tiêu của bạn.',
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
    features: const [
      (
        Icons.fitness_center,
        'Bài tập theo mục tiêu',
        'Tăng cơ, giảm mỡ, cải thiện vóc dáng',
      ),
      (
        Icons.bar_chart,
        'Theo dõi chỉ số cơ thể',
        'Cân nặng, BMR, TDEE, tiến độ',
      ),
      (
        Icons.track_changes,
        'Xây dựng thói quen bền vững',
        'Từng bước tạo phiên bản tốt hơn',
      ),
    ],
    dot: 1,
    next: '/login',
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
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 26),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, '/login'),
                child: const Text('Bỏ qua', style: TextStyle(color: ecoMuted)),
              ),
            ),
            Text(
              eyebrow,
              style: const TextStyle(
                fontSize: 9,
                letterSpacing: 1.2,
                color: ecoGreen,
                fontWeight: FontWeight.w800,
              ),
            ),
            gap8,
            Text(title, style: Theme.of(context).textTheme.headlineLarge),
            gap8,
            Text(
              description,
              style: const TextStyle(color: ecoMuted, height: 1.55),
            ),
            SizedBox(height: 210, child: art),
            ...features.map(
              (f) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _Feature(f.$1, f.$2, f.$3),
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                3,
                (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.all(3),
                  width: i == dot ? 20 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: i == dot ? ecoGreen : const Color(0xFFD9DFD6),
                    borderRadius: BorderRadius.circular(9),
                  ),
                ),
              ),
            ),
            gap12,
            FilledButton.icon(
              onPressed: () => Navigator.pushReplacementNamed(context, next),
              icon: const Icon(Icons.arrow_forward),
              iconAlignment: IconAlignment.end,
              label: const Text('Tiếp theo'),
            ),
          ],
        ),
      ),
    ),
  );
}

class Bubble extends StatelessWidget {
  const Bubble(this.text, {super.key});
  final String text;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: const Color(0xFFF8FBF3),
      shape: BoxShape.circle,
      border: Border.all(color: const Color(0xFF7DAD74), width: 2),
    ),
    child: Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: Color(0xFF4A744F),
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
            color: ecoGreenSoft,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: ecoGreen, size: 20),
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
              Text(text, style: const TextStyle(fontSize: 9, color: ecoMuted)),
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
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(),
    body: SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 28),
        child: Column(
          children: [
            const EcoLogo(large: true),
            gap16,
            Text(
              login ? 'Đăng nhập để bắt đầu' : 'Tạo tài khoản Eco Fit',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Text(
              'hành trình khỏe mạnh hơn',
              style: TextStyle(color: ecoMuted),
            ),
            const SizedBox(height: 28),
            const TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.mail_outline),
                hintText: 'Email của bạn',
              ),
            ),
            gap12,
            TextField(
              obscureText: obscure,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.lock_outline),
                hintText: 'Mật khẩu',
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
                  const Text(
                    'Ghi nhớ đăng nhập',
                    style: TextStyle(fontSize: 10),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => _infoDialog(
                      context,
                      'Khôi phục mật khẩu',
                      'Liên kết đặt lại mật khẩu đã được gửi tới email của bạn.',
                    ),
                    child: const Text(
                      'Quên mật khẩu?',
                      style: TextStyle(fontSize: 10),
                    ),
                  ),
                ],
              ),
            gap12,
            FilledButton(
              onPressed: () => Navigator.pushNamedAndRemoveUntil(
                context,
                '/home',
                (_) => false,
              ),
              child: Text(login ? 'Đăng nhập' : 'Tạo tài khoản'),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Row(
                children: [
                  Expanded(child: Divider(color: ecoLine)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      'hoặc',
                      style: TextStyle(fontSize: 10, color: ecoMuted),
                    ),
                  ),
                  Expanded(child: Divider(color: ecoLine)),
                ],
              ),
            ),
            OutlinedButton.icon(
              onPressed: () {
                _toast(context, 'Đã xác thực tài khoản Google');
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/home',
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
                login ? 'Đăng nhập với Google' : 'Đăng ký với Google',
              ),
            ),
            gap12,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  login ? 'Chưa có tài khoản? ' : 'Đã có tài khoản? ',
                  style: const TextStyle(fontSize: 10, color: ecoMuted),
                ),
                TextButton(
                  onPressed: () => setState(() => login = !login),
                  child: Text(
                    login ? 'Tạo tài khoản' : 'Đăng nhập',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 55),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.eco, size: 18, color: ecoGreen),
                SizedBox(width: 6),
                Text(
                  'Sức khỏe hôm nay, một tương lai tươi sáng hơn.',
                  style: TextStyle(fontSize: 10, color: Color(0xFF55705A)),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) => EcoShell(
    child: ListView(
      padding: pagePadding,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'CHÀO BUỔI SÁNG',
                    style: TextStyle(
                      fontSize: 9,
                      letterSpacing: 1.2,
                      color: ecoGreen,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Xin chào,\nMinh Anh! 👋',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const Text(
                    'Cùng cố gắng vì phiên bản tốt hơn mỗi ngày nhé!',
                    style: TextStyle(fontSize: 10, color: ecoMuted),
                  ),
                ],
              ),
            ),
            const CircleAvatar(
              radius: 22,
              backgroundColor: Color(0xFFB4D4A9),
              child: Text(
                'MA',
                style: TextStyle(color: ecoText, fontWeight: FontWeight.w800),
              ),
            ),
          ],
        ),
        gap16,
        EcoCard(
          child: Column(
            children: [
              SectionTitle(
                'Mục tiêu hôm nay',
                action: 'Xem chi tiết ›',
                onTap: () => Navigator.pushNamed(context, '/metrics'),
              ),
              Row(
                children: const [
                  MacroRing(),
                  SizedBox(width: 20),
                  Expanded(
                    child: MacroLegend(
                      values: [
                        (Color(0xFFE66B58), 'Protein', '72 / 120g'),
                        (Color(0xFFF1A63E), 'Carb', '130 / 250g'),
                        (Color(0xFF5C92DE), 'Fat', '40 / 70g'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        gap12,
        const Row(
          children: [
            Expanded(
              child: StatCard(
                icon: Icons.local_fire_department_outlined,
                label: 'BMR',
                value: '1.520 kcal',
                sub: 'Năng lượng cơ bản',
                color: Color(0xFFFFF7E8),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: StatCard(
                icon: Icons.bar_chart,
                label: 'TDEE',
                value: '2.050 kcal',
                sub: 'Năng lượng duy trì',
                color: Color(0xFFEEF8F1),
              ),
            ),
          ],
        ),
        gap16,
        SectionTitle(
          'Bài tập tiếp theo',
          action: 'Xem lịch ›',
          onTap: () => Navigator.pushNamed(context, '/workouts'),
        ),
        _ActionCard(
          icon: Icons.fitness_center,
          title: 'Push - Ngực & Tay sau',
          subtitle: 'Hôm nay · 17:00 · 45 phút',
          label: 'Bắt đầu',
          onTap: () => Navigator.pushNamed(context, '/exercise'),
        ),
        gap16,
        SectionTitle(
          'Gợi ý bữa ăn hôm nay',
          action: 'Xem thực đơn ›',
          onTap: () => Navigator.pushNamed(context, '/meals'),
        ),
        _ActionCard(
          emoji: '🍱',
          title: meals[1].name,
          subtitle: '520 kcal · P 35g · C 65g · F 12g',
          onTap: () => Navigator.pushNamed(context, '/meal/chicken-rice'),
        ),
        gap16,
        const QuoteCard(
          '🌱 “Cơ thể khỏe mạnh là nền tảng cho những ước mơ lớn.”',
        ),
      ],
    ),
  );
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    this.icon,
    this.emoji,
    required this.title,
    required this.subtitle,
    this.label,
    required this.onTap,
  });
  final IconData? icon;
  final String? emoji, label;
  final String title, subtitle;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(16),
    child: EcoCard(
      color: const Color(0xFFF4F8EF),
      padding: const EdgeInsets.all(11),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: ecoGreenSoft,
              borderRadius: BorderRadius.circular(13),
            ),
            child: Center(
              child: emoji != null
                  ? Text(emoji!, style: const TextStyle(fontSize: 24))
                  : Icon(icon, color: ecoGreen),
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
                  style: const TextStyle(fontSize: 8, color: ecoMuted),
                ),
              ],
            ),
          ),
          if (label != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
              decoration: BoxDecoration(
                color: ecoGreen,
                borderRadius: BorderRadius.circular(99),
              ),
              child: Text(
                label!,
                style: const TextStyle(
                  fontSize: 9,
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
            )
          else
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
  @override
  Widget build(BuildContext context) => EcoShell(
    title: 'Kế hoạch bữa ăn',
    selected: 1,
    child: ListView(
      padding: pagePadding,
      children: [
        const _DatePicker('Hôm nay, Thứ 2, 12 Tháng 4'),
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
          const ['Bữa ăn hôm nay', 'Tuần này'],
          selected: tab,
          onSelected: (i) => setState(() => tab = i),
        ),
        gap12,
        ...meals.map(
          (m) => Padding(
            padding: const EdgeInsets.only(bottom: 9),
            child: InkWell(
              onTap: () => Navigator.pushNamed(context, '/meal/${m.id}'),
              child: EcoCard(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7EDD6),
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
                            style: const TextStyle(
                              fontSize: 8,
                              color: ecoMuted,
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
                            style: const TextStyle(
                              fontSize: 8,
                              color: ecoMuted,
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
                        color: ecoGreenSoft,
                        borderRadius: BorderRadius.circular(99),
                      ),
                      child: Text(
                        m.tag,
                        style: const TextStyle(fontSize: 8, color: ecoGreen),
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
          onPressed: () => Navigator.pushNamed(context, '/grocery'),
          icon: const Icon(Icons.shopping_cart_outlined),
          label: const Text('Xem danh sách mua sắm'),
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
        meals.where((m) => m.id == widget.mealId).firstOrNull ?? meals.first;
    const ingredients = [
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
          tooltip: favorite ? 'Bỏ yêu thích' : 'Yêu thích',
        ),
      ],
      child: ListView(
        padding: pagePadding,
        children: [
          Text(
            '${meal.type} lành mạnh, nhanh gọn',
            style: const TextStyle(fontSize: 10, color: ecoMuted),
          ),
          gap12,
          Container(
            height: 210,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFE8F0DA), Color(0xFFF8EAC5)],
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
                (Icons.fitness_center, '${meal.protein}g', 'Protein'),
                (Icons.grain, '${meal.carbs}g', 'Carb'),
                (Icons.water_drop_outlined, '${meal.fat}g', 'Fat'),
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
            const ['Nguyên liệu', 'Cách làm'],
            selected: tab,
            onSelected: (i) => setState(() => tab = i),
          ),
          gap8,
          if (tab == 0)
            ...ingredients.map(
              (x) => Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: ecoLine)),
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
                      style: const TextStyle(fontSize: 9, color: ecoMuted),
                    ),
                  ],
                ),
              ),
            )
          else
            ...[
              'Trộn yến mạch với sữa và ngâm khoảng 10 phút.',
              'Cắt chuối, dâu tây thành miếng vừa ăn.',
              'Cho trái cây và hạt chia lên trên rồi thưởng thức.',
            ].indexed.map(
              (step) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  radius: 14,
                  backgroundColor: ecoGreenSoft,
                  child: Text(
                    '${step.$1 + 1}',
                    style: const TextStyle(fontSize: 10, color: ecoGreen),
                  ),
                ),
                title: Text(step.$2, style: const TextStyle(fontSize: 10)),
              ),
            ),
          gap12,
          EcoCard(
            color: const Color(0xFFFFF7DD),
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
                      const Text(
                        'Chi phí ước tính',
                        style: TextStyle(fontSize: 8, color: ecoMuted),
                      ),
                      Text(
                        '~ ${money(meal.price)} / khẩu phần',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                const Chip(
                  label: Text(
                    'Tiết kiệm',
                    style: TextStyle(fontSize: 8, color: ecoGreen),
                  ),
                  backgroundColor: ecoGreenSoft,
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
                    ? 'Đã thêm món ăn vào kế hoạch'
                    : 'Đã gỡ món ăn khỏi kế hoạch',
              );
            },
            icon: Icon(added ? Icons.check : Icons.add),
            label: Text(added ? 'Đã thêm vào kế hoạch' : 'Thêm vào kế hoạch'),
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
        Icon(icon, size: 18, color: ecoGreen),
        Text(
          value,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800),
        ),
        Text(label, style: const TextStyle(fontSize: 7, color: ecoMuted)),
      ],
    ),
  );
}

class _DatePicker extends StatefulWidget {
  const _DatePicker(this.label);
  final String label;

  @override
  State<_DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<_DatePicker> {
  int offset = 0;

  @override
  Widget build(BuildContext context) => EcoCard(
    padding: EdgeInsets.zero,
    child: SizedBox(
      height: 40,
      child: Row(
        children: [
          IconButton(
            onPressed: () => setState(() => offset--),
            icon: const Icon(Icons.chevron_left),
            tooltip: 'Ngày trước',
          ),
          Expanded(
            child: Text(
              offset == 0
                  ? widget.label
                  : '${widget.label} · ${offset > 0 ? '+' : ''}$offset',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
            ),
          ),
          IconButton(
            onPressed: () => setState(() => offset++),
            icon: const Icon(Icons.chevron_right),
            tooltip: 'Ngày sau',
          ),
        ],
      ),
    ),
  );
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
  @override
  Widget build(BuildContext context) {
    final all = groceryGroups.expand((g) => g.items);
    final total = all.fold(0, (s, x) => s + x.$2);
    final bought = all.fold(
      0,
      (s, x) => s + ((checked[x.$1] ?? false) ? x.$2 : 0),
    );
    return EcoShell(
      title: 'Danh sách mua sắm',
      showNav: false,
      child: ListView(
        padding: pagePadding,
        children: [
          const _DatePicker('Tuần này (8/4 - 14/4)'),
          gap12,
          EcoCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tổng chi phí ước tính',
                  style: TextStyle(fontSize: 8, color: ecoMuted),
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
                    style: const TextStyle(fontSize: 8, color: ecoMuted),
                  ),
                ),
              ],
            ),
          ),
          gap12,
          SegmentedTabs(
            const ['Tất cả', 'Đã mua', 'Chưa mua'],
            selected: tab,
            onSelected: (i) => setState(() => tab = i),
          ),
          gap8,
          ...groceryGroups.map(
            (g) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: EcoCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: Color(0xFFF4F8F1),
                        borderRadius: BorderRadius.vertical(
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
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: ecoGreen,
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
                              style: const TextStyle(
                                fontSize: 9,
                                color: ecoMuted,
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
          const _TipCard(
            title: 'Mẹo tiết kiệm',
            text: 'Mua thực phẩm theo mùa, chọn chợ sinh viên hoặc mua theo nhóm để tiết kiệm hơn.',
          ),
          gap8,
          Text(
            'Đã chọn: ${money(bought)}',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 9, color: ecoMuted),
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
  @override
  Widget build(BuildContext context) => EcoShell(
    title: 'Kế hoạch tập luyện',
    selected: 2,
    child: ListView(
      padding: pagePadding,
      children: [
        const DateStrip(),
        gap12,
        SegmentedTabs(
          const ['Tuần này', 'Tất cả'],
          selected: tab,
          onSelected: (i) => setState(() => tab = i),
        ),
        gap12,
        ...List.generate(workoutDays.length, (i) {
          final w = workoutDays[i];
          return Padding(
            padding: const EdgeInsets.only(bottom: 9),
            child: InkWell(
              onTap: () {
                _toast(context, 'Đã chọn ${w.$2}');
                Navigator.pushNamed(context, '/exercise');
              },
              child: EcoCard(
                color: i == 0 ? const Color(0xFFEDF7EA) : Colors.white,
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Container(
                      width: 43,
                      height: 43,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F5F1),
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
                            '${w.$1}${i == 0 ? ' · Hôm nay' : ''}',
                            style: const TextStyle(
                              fontSize: 8,
                              color: ecoMuted,
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
                            style: const TextStyle(
                              fontSize: 8,
                              color: ecoMuted,
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
        const QuoteCard('🌿 “Kỷ luật hôm nay, phiên bản tốt hơn ngày mai.”'),
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
  bool started = false;
  @override
  Widget build(BuildContext context) => EcoShell(
    title: 'Upper Body',
    showNav: false,
    actions: const [
      Padding(
        padding: EdgeInsets.only(right: 16),
        child: Chip(
          avatar: Icon(Icons.schedule, size: 14),
          label: Text('~45 phút', style: TextStyle(fontSize: 9)),
        ),
      ),
    ],
    child: ListView(
      padding: pagePadding,
      children: [
        const Text(
          'Ngực · Vai · Tay sau',
          style: TextStyle(fontSize: 10, color: ecoMuted),
        ),
        gap12,
        SegmentedTabs(
          const ['Bài tập', 'Ghi chú'],
          selected: tab,
          onSelected: (i) => setState(() => tab = i),
        ),
        gap12,
        if (tab == 0)
          ...List.generate(exercises.length, (i) {
            final e = exercises[i];
            return Padding(
              padding: const EdgeInsets.only(bottom: 9),
              child: EcoCard(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEEF2EA),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(e.$4, style: const TextStyle(fontSize: 25)),
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
                            style: const TextStyle(
                              fontSize: 8,
                              color: ecoMuted,
                            ),
                          ),
                          Text(
                            e.$3,
                            style: const TextStyle(
                              fontSize: 8,
                              color: ecoMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton.filledTonal(
                      onPressed: () {
                        setState(() => previewing = previewing == i ? null : i);
                        _toast(
                          context,
                          previewing == i
                              ? 'Đang xem hướng dẫn ${e.$1}'
                              : 'Đã dừng hướng dẫn',
                        );
                      },
                      icon: Icon(
                        previewing == i ? Icons.pause : Icons.play_arrow,
                        size: 17,
                      ),
                    ),
                  ],
                ),
              ),
            );
          })
        else
          const TextField(
            maxLines: 8,
            decoration: InputDecoration(hintText: 'Ghi chú buổi tập...'),
          ),
        gap8,
        FilledButton.icon(
          onPressed: () {
            setState(() => started = !started);
            _infoDialog(
              context,
              started ? 'Buổi tập đã bắt đầu' : 'Đã kết thúc buổi tập',
              started
                  ? 'Bài đầu tiên: ${exercises.first.$1}. Hãy hoàn thành ${exercises.first.$2}.'
                  : 'Tiến độ buổi tập đã được lưu.',
            );
          },
          icon: Icon(started ? Icons.stop : Icons.play_arrow),
          label: Text(started ? 'Kết thúc tập luyện' : 'Bắt đầu tập luyện'),
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
    title: 'Tiến độ của bạn',
    selected: 3,
    child: ListView(
      padding: pagePadding,
      children: [
        SegmentedTabs(
          const ['Tổng quan', 'Cân nặng', 'Chỉ số'],
          selected: tab,
          onSelected: (i) => setState(() => tab = i),
        ),
        gap12,
        EcoCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionTitle('Cân nặng (kg)', action: '30 ngày qua ▾'),
              SizedBox(
                height: 155,
                child: CustomPaint(
                  painter: WeightChartPainter(),
                  child: const Align(
                    alignment: Alignment.topRight,
                    child: Chip(
                      backgroundColor: ecoGreen,
                      label: Text(
                        '66.5 kg\n-3.5 kg',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 8, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('01/04', style: TextStyle(fontSize: 7, color: ecoMuted)),
                  Text('08/04', style: TextStyle(fontSize: 7, color: ecoMuted)),
                  Text('15/04', style: TextStyle(fontSize: 7, color: ecoMuted)),
                  Text('22/04', style: TextStyle(fontSize: 7, color: ecoMuted)),
                ],
              ),
            ],
          ),
        ),
        gap12,
        const Row(
          children: [
            Expanded(
              child: StatCard(
                icon: Icons.eco,
                label: 'BMI',
                value: '22.1',
                sub: 'Bình thường',
              ),
            ),
            SizedBox(width: 7),
            Expanded(
              child: StatCard(
                icon: Icons.local_fire_department_outlined,
                label: 'BMR',
                value: '1.520',
                sub: 'kcal/ngày',
                color: Color(0xFFFFF7E8),
              ),
            ),
            SizedBox(width: 7),
            Expanded(
              child: StatCard(
                icon: Icons.bar_chart,
                label: 'TDEE',
                value: '2.050',
                sub: 'kcal/ngày',
                color: Color(0xFFEEF8F1),
              ),
            ),
          ],
        ),
        gap12,
        EcoCard(
          child: Column(
            children: [
              const SectionTitle('Chuỗi ngày duy trì', action: '5 ngày'),
              Row(
                children: List.generate(
                  7,
                  (i) => Expanded(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 15,
                          backgroundColor: i < 5
                              ? ecoGreen
                              : const Color(0xFFEEF1EC),
                          child: Text(
                            i < 5 ? '✓' : '○',
                            style: TextStyle(
                              fontSize: 10,
                              color: i < 5 ? Colors.white : ecoMuted,
                            ),
                          ),
                        ),
                        Text(
                          ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'][i],
                          style: const TextStyle(fontSize: 7, color: ecoMuted),
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
        const QuoteCard(
          '🌱 Tiến bộ không cần hoàn hảo, chỉ cần không bỏ cuộc!',
        ),
      ],
    ),
  );
}

class WeightChartPainter extends CustomPainter {
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
  int age = 20;
  String gender = 'male', goal = 'lose';
  double height = 170, weight = 65, activity = 1.375;
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
      title: 'Chỉ số cơ thể',
      showNav: false,
      child: ListView(
        padding: pagePadding,
        children: [
          _NumberField(
            'Tuổi',
            age.toDouble(),
            (v) => setState(() => age = v.round()),
          ),
          gap8,
          Row(
            children: [
              const SizedBox(
                width: 110,
                child: Text(
                  'Giới tính',
                  style: TextStyle(fontSize: 10, color: ecoMuted),
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: ChoiceChip(
                        label: const Text('♂ Nam'),
                        selected: gender == 'male',
                        onSelected: (_) => setState(() => gender = 'male'),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: ChoiceChip(
                        label: const Text('♀ Nữ'),
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
            'Chiều cao',
            height,
            (v) => setState(() => height = v),
            suffix: 'cm',
          ),
          gap8,
          _NumberField(
            'Cân nặng',
            weight,
            (v) => setState(() => weight = v),
            suffix: 'kg',
          ),
          gap8,
          _SelectField('Mức độ hoạt động', activity, {
            1.2: 'Ít vận động',
            1.375: 'Vận động nhẹ (1-3 buổi/tuần)',
            1.55: 'Vận động vừa (3-5 buổi/tuần)',
            1.725: 'Vận động cao',
          }, (v) => setState(() => activity = v)),
          gap8,
          _SelectField('Mục tiêu', goal, const {
            'lose': 'Giảm cân',
            'maintain': 'Giữ cân',
            'gain': 'Tăng cơ',
          }, (v) => setState(() => goal = v)),
          gap12,
          FilledButton(
            onPressed: () {
              setState(() {});
              _toast(context, 'Đã tính lại chỉ số cơ thể');
            },
            child: const Text('Tính chỉ số của tôi'),
          ),
          gap16,
          const Text(
            'Kết quả ước tính',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
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
                  'kcal/ngày',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _MetricResult(
                  Icons.bar_chart,
                  'TDEE',
                  '${m.tdee}',
                  'kcal/ngày',
                ),
              ),
            ],
          ),
          gap12,
          const _TipCard(
            title: 'Gợi ý',
            text: 'Đây là chỉ số ước tính. Hãy kết hợp chế độ ăn và tập luyện để đạt mục tiêu.',
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
          style: const TextStyle(fontSize: 10, color: ecoMuted),
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
          style: const TextStyle(fontSize: 10, color: ecoMuted),
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
        Icon(icon, color: ecoGreen),
        Text(label, style: const TextStyle(fontSize: 7, color: ecoMuted)),
        Text(
          value,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
        ),
        Text(
          sub,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 7, color: ecoMuted),
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
  @override
  Widget build(BuildContext context) => EcoShell(
    title: 'Check-in hằng ngày',
    child: ListView(
      padding: pagePadding,
      children: [
        const _DatePicker('Hôm nay, 12 Tháng 4'),
        gap12,
        const DateStrip(active: 4),
        gap12,
        _CounterCard(
          icon: Icons.water_drop_outlined,
          label: 'Uống nước',
          value: '${water.toStringAsFixed(1)} / 2.0 lít',
          minus: () => setState(() => water = (water - .25).clamp(0, 3)),
          plus: () => setState(() => water = (water + .25).clamp(0, 3)),
        ),
        _CounterCard(
          icon: Icons.bedtime_outlined,
          label: 'Ngủ đủ giấc',
          value: '${sleep.toStringAsFixed(1)} / 8 giờ',
          minus: () => setState(() => sleep = (sleep - .5).clamp(0, 12)),
          plus: () => setState(() => sleep = (sleep + .5).clamp(0, 12)),
        ),
        _CounterCard(
          icon: Icons.directions_walk,
          label: 'Đi bộ / Vận động',
          value: '$steps / 8.000 bước',
          minus: () => setState(() => steps = (steps - 500).clamp(0, 99999)),
          plus: () => setState(() => steps += 500),
        ),
        EcoCard(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '🙂 Tâm trạng',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      'Hôm nay bạn thấy thế nào?',
                      style: TextStyle(fontSize: 8, color: ecoMuted),
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
                      color: mood == i ? ecoGreenSoft : const Color(0xFFF2F3EF),
                      shape: BoxShape.circle,
                      border: mood == i
                          ? Border.all(color: ecoGreen, width: 2)
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
            color: done ? const Color(0xFFEEF7EB) : Colors.white,
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                const Icon(Icons.fitness_center, color: ecoGreen),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Tập luyện',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        done ? 'Đã hoàn thành' : 'Chưa hoàn thành',
                        style: const TextStyle(fontSize: 8, color: ecoMuted),
                      ),
                    ],
                  ),
                ),
                Text(
                  done ? '✓' : '○',
                  style: const TextStyle(fontSize: 18, color: ecoGreen),
                ),
              ],
            ),
          ),
        ),
        gap12,
        const Text(
          'Ghi chú thêm (tuỳ chọn)',
          style: TextStyle(fontSize: 9, color: ecoMuted),
        ),
        gap8,
        const TextField(
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'Hôm nay mình cảm thấy rất tốt!',
          ),
        ),
        gap12,
        FilledButton(
          onPressed: () => ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Đã lưu check-in'))),
          child: const Text('Lưu check-in'),
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
              color: const Color(0xFFEEF6F4),
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
                  style: const TextStyle(fontSize: 8, color: ecoMuted),
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
  final messages = <(bool, String)>[
    (
      false,
      'Xin chào Minh Anh! 👋 Mình là Eco Coach. Mình có thể gợi ý thực đơn, bài tập phù hợp với mục tiêu, thời gian và ngân sách của bạn.',
    ),
    (true, 'Gợi ý thực đơn 1 ngày đủ chất với ngân sách 50k cho sinh viên'),
    (
      false,
      'Gợi ý hôm nay: sáng yến mạch + chuối + trứng, trưa cơm gà rau củ, tối cá basa + rau. Tổng khoảng 48.000đ và ưu tiên protein.',
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
    const chips = [
      'Gợi ý bữa ăn',
      'Lên lịch tập',
      'Tư vấn dinh dưỡng',
      'Tập tại nhà',
      'Chi phí sinh viên',
      'Khác',
    ];
    return EcoShell(
      title: 'AI Coach',
      child: ListView(
        padding: pagePadding,
        children: [
          const Row(
            children: [
              CircleAvatar(
                backgroundColor: ecoGreenSoft,
                child: Icon(Icons.eco, color: ecoGreen),
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Trợ lý đồng hành của bạn',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800),
                  ),
                  Text(
                    'Gợi ý nhanh, dễ hiểu, phù hợp sinh viên',
                    style: TextStyle(fontSize: 8, color: ecoMuted),
                  ),
                ],
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
                constraints: const BoxConstraints(maxWidth: 310),
                decoration: BoxDecoration(
                  color: m.$1 ? const Color(0xFFDFF0D9) : Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(15),
                    topRight: const Radius.circular(15),
                    bottomLeft: Radius.circular(m.$1 ? 15 : 5),
                    bottomRight: Radius.circular(m.$1 ? 5 : 15),
                  ),
                  border: Border.all(color: ecoLine),
                ),
                child: Text(
                  m.$2,
                  style: const TextStyle(fontSize: 9, height: 1.5),
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
                    label: Text(c, style: const TextStyle(fontSize: 8)),
                    side: const BorderSide(color: Color(0xFFCFE0CC)),
                    backgroundColor: Colors.white,
                  ),
                )
                .toList(),
          ),
          gap12,
          const EcoCard(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Text('🥣', style: TextStyle(fontSize: 28)),
                SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bữa sáng (~12k)',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        'Cháo yến mạch + chuối + 1 quả trứng luộc',
                        style: TextStyle(fontSize: 8, color: ecoMuted),
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
            decoration: InputDecoration(
              prefixIcon: IconButton(
                onPressed: () =>
                    _toast(context, 'Đã mở trình chọn tệp đính kèm'),
                icon: const Icon(Icons.attach_file),
                tooltip: 'Đính kèm',
              ),
              hintText: 'Nhập tin nhắn...',
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
  bool reminders = true;
  @override
  Widget build(BuildContext context) => EcoShell(
    title: 'Cá nhân',
    selected: 4,
    actions: [
      TextButton(
        onPressed: () => showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          builder: (sheetContext) => Padding(
            padding: EdgeInsets.fromLTRB(
              24,
              24,
              24,
              MediaQuery.viewInsetsOf(sheetContext).bottom + 24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Chỉnh sửa hồ sơ',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                ),
                gap16,
                const TextField(
                  decoration: InputDecoration(labelText: 'Họ tên'),
                  controller: null,
                ),
                gap12,
                const TextField(
                  decoration: InputDecoration(labelText: 'Trường học'),
                ),
                gap16,
                FilledButton(
                  onPressed: () {
                    Navigator.pop(sheetContext);
                    _toast(context, 'Đã lưu thay đổi hồ sơ');
                  },
                  child: const Text('Lưu thay đổi'),
                ),
              ],
            ),
          ),
        ),
        child: const Text(
          'Chỉnh sửa',
          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800),
        ),
      ),
    ],
    child: ListView(
      padding: pagePadding,
      children: [
        const Row(
          children: [
            CircleAvatar(
              radius: 32,
              backgroundColor: Color(0xFFB4D4A9),
              child: Text(
                'MA',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: ecoText,
                ),
              ),
            ),
            SizedBox(width: 13),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Minh Anh',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                ),
                Text(
                  'Sinh viên Đại học Kinh tế',
                  style: TextStyle(fontSize: 9),
                ),
                Text(
                  'Sống khỏe hơn mỗi ngày 🌱',
                  style: TextStyle(fontSize: 8, color: ecoMuted),
                ),
              ],
            ),
          ],
        ),
        gap16,
        Row(
          children: [
            for (final s in [
              ('128', 'ngày đồng hành'),
              ('12', 'huy hiệu'),
              ('5', 'mục tiêu hoàn thành'),
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
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          s.$2,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 7, color: ecoMuted),
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
              const _Setting(Icons.person_outline, 'Thông tin tài khoản'),
              const _Setting(Icons.notifications_outlined, 'Thông báo'),
              SwitchListTile(
                dense: true,
                value: reminders,
                onChanged: (v) => setState(() => reminders = v),
                secondary: const Icon(Icons.alarm_outlined, color: ecoMuted),
                title: const Text(
                  'Nhắc nhở hằng ngày',
                  style: TextStyle(fontSize: 9),
                ),
              ),
              const _Setting(Icons.language, 'Ngôn ngữ', value: 'Tiếng Việt'),
              const _Setting(
                Icons.light_mode_outlined,
                'Giao diện',
                value: 'Sáng',
              ),
              _Setting(
                Icons.smart_toy_outlined,
                'AI Coach',
                onTap: () => Navigator.pushNamed(context, '/coach'),
              ),
              const _Setting(Icons.help_outline, 'Trợ giúp & Phản hồi'),
              const _Setting(Icons.info_outline, 'Giới thiệu về Eco Fit'),
            ],
          ),
        ),
        gap12,
        FilledButton.tonalIcon(
          onPressed: () => Navigator.pushNamedAndRemoveUntil(
            context,
            '/login',
            (_) => false,
          ),
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFFFFF0ED),
            foregroundColor: const Color(0xFFD95748),
          ),
          icon: const Icon(Icons.logout),
          label: const Text('Đăng xuất'),
        ),
      ],
    ),
  );
}

class _Setting extends StatelessWidget {
  const _Setting(this.icon, this.label, {this.value, this.onTap});
  final IconData icon;
  final String label;
  final String? value;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) => ListTile(
    dense: true,
    onTap:
        onTap ??
        () => _infoDialog(
          context,
          label,
          value == null
              ? 'Tính năng $label đã sẵn sàng.'
              : 'Thiết lập hiện tại: $value',
        ),
    leading: Icon(icon, size: 20, color: ecoMuted),
    title: Text(label, style: const TextStyle(fontSize: 9)),
    trailing: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (value != null)
          Text(value!, style: const TextStyle(fontSize: 8, color: ecoMuted)),
        const Icon(Icons.chevron_right, size: 17),
      ],
    ),
  );
}

class _TipCard extends StatelessWidget {
  const _TipCard({required this.title, required this.text});
  final String title, text;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: const Color(0xFFEFF7E8),
      borderRadius: BorderRadius.circular(14),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.lightbulb_outline, color: Color(0xFF56745A)),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 10,
                  color: Color(0xFF56745A),
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                text,
                style: const TextStyle(
                  fontSize: 8,
                  height: 1.45,
                  color: Color(0xFF56745A),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
