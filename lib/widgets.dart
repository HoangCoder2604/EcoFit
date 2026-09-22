import 'package:flutter/material.dart';

import 'app/router/app_routes.dart';
import 'theme.dart';

class EcoShell extends StatelessWidget {
  const EcoShell({
    super.key,
    required this.child,
    this.title,
    this.selected = 0,
    this.showNav = true,
    this.actions,
  });
  final Widget child;
  final String? title;
  final int selected;
  final bool showNav;
  final List<Widget>? actions;
  static const routes = [
    AppRoutes.home,
    AppRoutes.meals,
    AppRoutes.workouts,
    AppRoutes.progress,
    AppRoutes.profile,
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: title == null
        ? null
        : AppBar(title: Text(title!), actions: actions),
    body: SafeArea(child: child),
    bottomNavigationBar: showNav
        ? NavigationBar(
            height: 68,
            selectedIndex: selected,
            indicatorColor: ecoGreenSoft,
            labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
            onDestinationSelected: (i) {
              if (i != selected)
                Navigator.pushReplacementNamed(context, routes[i]);
            },
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home),
                label: 'Trang chủ',
              ),
              NavigationDestination(
                icon: Icon(Icons.restaurant_outlined),
                selectedIcon: Icon(Icons.restaurant),
                label: 'Bữa ăn',
              ),
              NavigationDestination(
                icon: Icon(Icons.fitness_center_outlined),
                selectedIcon: Icon(Icons.fitness_center),
                label: 'Tập luyện',
              ),
              NavigationDestination(
                icon: Icon(Icons.bar_chart_outlined),
                selectedIcon: Icon(Icons.bar_chart),
                label: 'Tiến độ',
              ),
              NavigationDestination(
                icon: Icon(Icons.person_outline),
                selectedIcon: Icon(Icons.person),
                label: 'Cá nhân',
              ),
            ],
          )
        : null,
  );
}

class EcoLogo extends StatelessWidget {
  const EcoLogo({super.key, this.large = false});
  final bool large;
  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: large ? 58 : 40,
        height: large ? 58 : 40,
        decoration: BoxDecoration(
          color: ecoGreen,
          borderRadius: BorderRadius.circular(large ? 20 : 14),
        ),
        child: Icon(Icons.eco, color: Colors.white, size: large ? 34 : 22),
      ),
      const SizedBox(width: 10),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Eco Fit',
            style: TextStyle(
              fontSize: large ? 34 : 19,
              fontWeight: FontWeight.w900,
            ),
          ),
          if (!large)
            const Text(
              'HEALTHY STUDENT LIFE',
              style: TextStyle(fontSize: 8, letterSpacing: 1, color: ecoMuted),
            ),
        ],
      ),
    ],
  );
}

class SectionTitle extends StatelessWidget {
  const SectionTitle(this.title, {super.key, this.action, this.onTap});
  final String title;
  final String? action;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
          ),
        ),
        if (action != null)
          InkWell(
            onTap:
                onTap ??
                () =>
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(action!))),
            child: Text(
              action!,
              style: const TextStyle(fontSize: 10, color: ecoMuted),
            ),
          ),
      ],
    ),
  );
}

class MacroRing extends StatelessWidget {
  const MacroRing({
    super.key,
    this.value = .62,
    this.center = '1.250',
    this.total = '/ 2.000 kcal',
  });
  final double value;
  final String center, total;
  @override
  Widget build(BuildContext context) => SizedBox.square(
    dimension: 112,
    child: Stack(
      fit: StackFit.expand,
      alignment: Alignment.center,
      children: [
        CircularProgressIndicator(
          value: value,
          strokeWidth: 13,
          color: ecoGreen,
          backgroundColor: const Color(0xFFEEF1EC),
          strokeCap: StrokeCap.round,
        ),
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                center,
                style: const TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(total, style: const TextStyle(fontSize: 8, color: ecoMuted)),
            ],
          ),
        ),
      ],
    ),
  );
}

class MacroLegend extends StatelessWidget {
  const MacroLegend({super.key, required this.values});
  final List<(Color, String, String)> values;
  @override
  Widget build(BuildContext context) => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: values
        .map(
          (e) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              children: [
                Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: e.$1,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 7),
                Expanded(
                  child: Text(
                    e.$2,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Text(
                  e.$3,
                  style: const TextStyle(fontSize: 9, color: ecoMuted),
                ),
              ],
            ),
          ),
        )
        .toList(),
  );
}

class StatCard extends StatelessWidget {
  const StatCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.sub,
    this.color = Colors.white,
  });
  final IconData icon;
  final String label, value, sub;
  final Color color;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(11),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: ecoLine),
    ),
    child: Row(
      children: [
        Container(
          width: 35,
          height: 35,
          decoration: BoxDecoration(
            color: Colors.white70,
            borderRadius: BorderRadius.circular(11),
          ),
          child: Icon(icon, size: 19, color: ecoGreen),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 8, color: ecoMuted)),
              Text(
                value,
                maxLines: 1,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                sub,
                maxLines: 2,
                style: const TextStyle(fontSize: 8, color: ecoMuted),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class EcoCard extends StatelessWidget {
  const EcoCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(15),
    this.color = Colors.white,
  });
  final Widget child;
  final EdgeInsets padding;
  final Color color;
  @override
  Widget build(BuildContext context) => Material(
    color: color,
    clipBehavior: Clip.antiAlias,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(18),
      side: const BorderSide(color: ecoLine),
    ),
    child: Padding(padding: padding, child: child),
  );
}

class SegmentedTabs extends StatelessWidget {
  const SegmentedTabs(
    this.items, {
    super.key,
    this.selected = 0,
    this.onSelected,
  });
  final List<String> items;
  final int selected;
  final ValueChanged<int>? onSelected;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(3),
    decoration: BoxDecoration(
      color: const Color(0xFFEEF1EC),
      borderRadius: BorderRadius.circular(99),
    ),
    child: Row(
      children: List.generate(
        items.length,
        (i) => Expanded(
          child: InkWell(
            borderRadius: BorderRadius.circular(99),
            onTap: () => onSelected?.call(i),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: i == selected ? ecoGreen : Colors.transparent,
                borderRadius: BorderRadius.circular(99),
              ),
              child: Text(
                items[i],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: i == selected ? Colors.white : ecoMuted,
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

class DateStrip extends StatefulWidget {
  const DateStrip({super.key, this.active = 2});
  final int active;

  @override
  State<DateStrip> createState() => _DateStripState();
}

class _DateStripState extends State<DateStrip> {
  late int active;

  @override
  void initState() {
    super.initState();
    active = widget.active;
  }

  @override
  Widget build(BuildContext context) => Row(
    children: List.generate(7, (i) {
      const days = [
        'T2\n8',
        'T3\n9',
        'T4\n10',
        'T5\n11',
        'T6\n12',
        'T7\n13',
        'CN\n14',
      ];
      return Expanded(
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () => setState(() => active = i),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 2),
            padding: const EdgeInsets.symmetric(vertical: 7),
            decoration: BoxDecoration(
              color: i == active ? ecoGreen : const Color(0xFFF1F4EF),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              days[i],
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 8,
                fontWeight: FontWeight.w700,
                color: i == active ? Colors.white : ecoMuted,
              ),
            ),
          ),
        ),
      );
    }),
  );
}

class QuoteCard extends StatelessWidget {
  const QuoteCard(this.text, {super.key});
  final String text;
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: const Color(0xFFEFF6E9),
      borderRadius: BorderRadius.circular(14),
    ),
    child: Text(
      text,
      style: const TextStyle(fontSize: 10, color: Color(0xFF4D6552)),
    ),
  );
}

String money(int value) {
  final raw = value.toString();
  final out = StringBuffer();
  for (var i = 0; i < raw.length; i++) {
    if (i > 0 && (raw.length - i) % 3 == 0) out.write('.');
    out.write(raw[i]);
  }
  return '${out}đ';
}
