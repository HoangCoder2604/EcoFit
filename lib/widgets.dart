import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'app/router/app_routes.dart';
import 'app/state/eco_fit_app_state.dart';
import 'theme.dart';

enum EcoShellLayout { desktopSidebar, mobileWebDrawer, nativeBottomBar, plain }

EcoShellLayout ecoShellLayoutFor({
  required bool isWeb,
  required double width,
  required bool showNav,
}) {
  if (!showNav) return EcoShellLayout.plain;
  if (width >= 980) return EcoShellLayout.desktopSidebar;
  if (isWeb) return EcoShellLayout.mobileWebDrawer;
  return EcoShellLayout.nativeBottomBar;
}

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
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final layout = ecoShellLayoutFor(
        isWeb: kIsWeb,
        width: constraints.maxWidth,
        showNav: showNav,
      );
      final english = EcoFitAppState.instance.language == 'en';
      final content = SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: layout == EcoShellLayout.mobileWebDrawer ? 760 : 1440,
            ),
            child: child,
          ),
        ),
      );
      if (layout == EcoShellLayout.desktopSidebar) {
        return Scaffold(
          body: Row(
            children: [
              _EcoSidebar(selected: selected, routes: routes),
              Expanded(
                child: Column(
                  children: [
                    _DesktopHeader(title: title, actions: actions),
                    Expanded(child: content),
                  ],
                ),
              ),
            ],
          ),
        );
      }
      if (layout == EcoShellLayout.mobileWebDrawer) {
        return Scaffold(
          appBar: AppBar(
            toolbarHeight: 64,
            leading: Builder(
              builder: (menuContext) => IconButton(
                tooltip: english ? 'Open menu' : 'Mở menu',
                onPressed: () => Scaffold.of(menuContext).openDrawer(),
                icon: const Icon(Icons.menu_rounded),
              ),
            ),
            title: title == null
                ? const EcoLogo()
                : Text(title!, overflow: TextOverflow.ellipsis),
            actions: actions,
          ),
          drawer: _MobileWebDrawer(
            selected: selected,
            routes: routes,
            english: english,
          ),
          body: content,
        );
      }
      return Scaffold(
        appBar: title == null
            ? null
            : AppBar(title: Text(title!), actions: actions),
        body: content,
        bottomNavigationBar: layout == EcoShellLayout.nativeBottomBar
            ? NavigationBar(
                height: 68,
                selectedIndex: selected,
                indicatorColor: Theme.of(context).colorScheme.primaryContainer,
                labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
                onDestinationSelected: (i) {
                  if (i != selected)
                    Navigator.pushReplacementNamed(context, routes[i]);
                },
                destinations: [
                  NavigationDestination(
                    icon: const Icon(Icons.home_outlined),
                    selectedIcon: const Icon(Icons.home),
                    label: english ? 'Home' : 'Trang chủ',
                  ),
                  NavigationDestination(
                    icon: const Icon(Icons.restaurant_outlined),
                    selectedIcon: const Icon(Icons.restaurant),
                    label: english ? 'Meals' : 'Bữa ăn',
                  ),
                  NavigationDestination(
                    icon: const Icon(Icons.fitness_center_outlined),
                    selectedIcon: const Icon(Icons.fitness_center),
                    label: english ? 'Workout' : 'Tập luyện',
                  ),
                  NavigationDestination(
                    icon: const Icon(Icons.bar_chart_outlined),
                    selectedIcon: const Icon(Icons.bar_chart),
                    label: english ? 'Progress' : 'Tiến độ',
                  ),
                  NavigationDestination(
                    icon: const Icon(Icons.person_outline),
                    selectedIcon: const Icon(Icons.person),
                    label: english ? 'Profile' : 'Cá nhân',
                  ),
                ],
              )
            : null,
      );
    },
  );
}

class _MobileWebDrawer extends StatelessWidget {
  const _MobileWebDrawer({
    required this.selected,
    required this.routes,
    required this.english,
  });

  final int selected;
  final List<String> routes;
  final bool english;

  @override
  Widget build(BuildContext context) {
    final items = <(IconData, String)>[
      (Icons.space_dashboard_outlined, english ? 'Overview' : 'Tổng quan'),
      (Icons.restaurant_menu_outlined, english ? 'Meals' : 'Bữa ăn'),
      (Icons.fitness_center_outlined, english ? 'Workout' : 'Tập luyện'),
      (Icons.monitor_heart_outlined, english ? 'Progress' : 'Tiến độ'),
      (Icons.person_outline, english ? 'Profile' : 'Cá nhân'),
    ];
    return Drawer(
      width: 310,
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 22, 18, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  const EcoLogo(),
                  const Spacer(),
                  IconButton(
                    tooltip: english ? 'Close menu' : 'Đóng menu',
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 26),
              Text(
                english ? 'YOUR SPACE' : 'KHÔNG GIAN CỦA BẠN',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 10,
                  letterSpacing: 1.1,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 10),
              for (var i = 0; i < items.length; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: ListTile(
                    selected: i == selected,
                    selectedColor: Theme.of(context).colorScheme.primary,
                    selectedTileColor: Theme.of(context)
                        .colorScheme
                        .primaryContainer,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    leading: Icon(items[i].$1),
                    title: Text(
                      items[i].$2,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      if (i != selected) {
                        Navigator.pushReplacementNamed(context, routes[i]);
                      }
                    },
                  ),
                ),
              const Spacer(),
              OutlinedButton.icon(
                onPressed: () =>
                    Navigator.pushNamed(context, AppRoutes.checkIn),
                icon: const Icon(Icons.add_task_rounded),
                label: Text(english ? 'Daily check-in' : 'Check-in hôm nay'),
              ),
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: () => Navigator.pushNamed(context, AppRoutes.coach),
                icon: const Icon(Icons.chat_bubble_outline),
                label: Text(english ? 'Ask Eco Coach' : 'Hỏi Eco Coach'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DesktopHeader extends StatelessWidget {
  const _DesktopHeader({this.title, this.actions});
  final String? title;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) => Container(
    height: 76,
    padding: const EdgeInsets.symmetric(horizontal: 32),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surface,
      border: Border(bottom: BorderSide(color: Theme.of(context).dividerColor)),
    ),
    child: Row(
      children: [
        Text(
          title ?? 'Tổng quan hôm nay',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const Spacer(),
        if (actions != null) ...actions!,
        IconButton(
          tooltip: 'Thông báo',
          onPressed: () => Navigator.pushNamed(context, AppRoutes.profile),
          icon: const Badge(child: Icon(Icons.notifications_none_rounded)),
        ),
        const SizedBox(width: 8),
        CircleAvatar(
          radius: 18,
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Icon(
            Icons.person_outline,
            color: Theme.of(context).colorScheme.primary,
            size: 20,
          ),
        ),
      ],
    ),
  );
}

class _EcoSidebar extends StatelessWidget {
  const _EcoSidebar({required this.selected, required this.routes});
  final int selected;
  final List<String> routes;

  @override
  Widget build(BuildContext context) {
    final english = EcoFitAppState.instance.language == 'en';
    final items = <(IconData, String)>[
      (Icons.space_dashboard_outlined, english ? 'Dashboard' : 'Tổng quan'),
      (Icons.restaurant_menu_outlined, english ? 'Meals' : 'Bữa ăn'),
      (Icons.fitness_center_outlined, english ? 'Workout' : 'Tập luyện'),
      (Icons.monitor_heart_outlined, english ? 'Progress' : 'Tiến độ'),
      (Icons.person_outline, english ? 'Profile' : 'Cá nhân'),
    ];
    return Container(
      width: 248,
      color: ecoText,
      padding: const EdgeInsets.fromLTRB(20, 26, 20, 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const EcoLogo(onDark: true),
          const SizedBox(height: 34),
          const Padding(
            padding: EdgeInsets.only(left: 12, bottom: 10),
            child: Text(
              'KHÔNG GIAN CỦA BẠN',
              style: TextStyle(
                color: Color(0xFF9FB0A7),
                fontSize: 10,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          for (var i = 0; i < items.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Material(
                color: Colors.transparent,
                child: ListTile(
                  selected: i == selected,
                  selectedTileColor: const Color(0xFF335F4B),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  leading: Icon(
                    items[i].$1,
                    color: i == selected
                        ? Colors.white
                        : const Color(0xFFB9C6BF),
                  ),
                  title: Text(
                    items[i].$2,
                    style: TextStyle(
                      color: i == selected
                          ? Colors.white
                          : const Color(0xFFD4DED8),
                      fontWeight: i == selected
                          ? FontWeight.w700
                          : FontWeight.w500,
                    ),
                  ),
                  onTap: () {
                    if (i != selected) {
                      Navigator.pushReplacementNamed(context, routes[i]);
                    }
                  },
                ),
              ),
            ),
          const Spacer(),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: const BorderSide(color: Color(0xFF496D5C)),
            ),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.checkIn),
            icon: const Icon(Icons.add_task_rounded),
            label: const Text('Check-in hôm nay'),
          ),
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: () => Navigator.pushNamed(context, AppRoutes.coach),
            icon: const Icon(
              Icons.chat_bubble_outline,
              color: Color(0xFFB9C6BF),
            ),
            label: const Text(
              'Hỏi Eco Coach',
              style: TextStyle(color: Color(0xFFD4DED8)),
            ),
          ),
        ],
      ),
    );
  }
}

class EcoLogo extends StatelessWidget {
  const EcoLogo({super.key, this.large = false, this.onDark = false});
  final bool large;
  final bool onDark;
  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: large ? 58 : 40,
        height: large ? 58 : 40,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
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
              color: onDark
                  ? Colors.white
                  : Theme.of(context).colorScheme.onSurface,
            ),
          ),
          if (!large)
            Text(
              'SỐNG KHỎE MỖI NGÀY',
              style: TextStyle(
                fontSize: 7,
                letterSpacing: .6,
                color: onDark
                    ? const Color(0xFFB9C6BF)
                    : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
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
        if (action != null && onTap != null)
          InkWell(
            onTap: onTap,
            child: Text(
              action!,
              style: TextStyle(
                fontSize: 10,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
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
          color: Theme.of(context).colorScheme.primary,
          backgroundColor: Theme.of(context).dividerColor,
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
              Text(
                total,
                style: TextStyle(
                  fontSize: 8,
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
                  style: TextStyle(
                    fontSize: 9,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
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
    this.color,
  });
  final IconData icon;
  final String label, value, sub;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dark = theme.brightness == Brightness.dark;
    final background = dark
        ? switch (label) {
            'BMR' => const Color(0xFF332714),
            'TDEE' => const Color(0xFF173623),
            _ => theme.colorScheme.surface,
          }
        : color ?? theme.colorScheme.surface;
    return Container(
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Row(
        children: [
          Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(icon, size: 19, color: theme.colorScheme.primary),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 8,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
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
                  style: TextStyle(
                    fontSize: 8,
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
}

class EcoCard extends StatelessWidget {
  const EcoCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(15),
    this.color,
  });
  final Widget child;
  final EdgeInsets padding;
  final Color? color;
  @override
  Widget build(BuildContext context) => Material(
    color: color ?? Theme.of(context).colorScheme.surface,
    clipBehavior: Clip.antiAlias,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(18),
      side: BorderSide(color: Theme.of(context).dividerColor),
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
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
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
                color: i == selected
                    ? Theme.of(context).colorScheme.primary
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(99),
              ),
              child: Text(
                items[i],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: i == selected
                      ? Colors.white
                      : Theme.of(context).colorScheme.onSurfaceVariant,
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
  const DateStrip({super.key, this.weekOf, this.selectedDate, this.onSelected});

  final DateTime? weekOf;
  final DateTime? selectedDate;
  final ValueChanged<DateTime>? onSelected;

  @override
  State<DateStrip> createState() => _DateStripState();
}

class _DateStripState extends State<DateStrip> {
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    final initial = widget.selectedDate ?? DateTime.now();
    selectedDate = DateTime(initial.year, initial.month, initial.day);
  }

  @override
  void didUpdateWidget(covariant DateStrip oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedDate != null &&
        !_sameDate(widget.selectedDate!, selectedDate)) {
      final value = widget.selectedDate!;
      selectedDate = DateTime(value.year, value.month, value.day);
    }
  }

  DateTime _weekStart(DateTime date) {
    final normalized = DateTime(date.year, date.month, date.day);
    return normalized.subtract(Duration(days: normalized.weekday - 1));
  }

  bool _sameDate(DateTime first, DateTime second) =>
      first.year == second.year &&
      first.month == second.month &&
      first.day == second.day;

  @override
  Widget build(BuildContext context) {
    final anchor = widget.weekOf ?? selectedDate;
    final start = _weekStart(anchor);
    final isEnglish = EcoFitAppState.instance.language == 'en';
    const viDays = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];
    const enDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final weekdayLabels = isEnglish ? enDays : viDays;

    return Row(
      children: List.generate(7, (i) {
        final date = start.add(Duration(days: i));
        final active = _sameDate(date, selectedDate);
        return Expanded(
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () {
              setState(() => selectedDate = date);
              widget.onSelected?.call(date);
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              padding: const EdgeInsets.symmetric(vertical: 7),
              decoration: BoxDecoration(
                color: active
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${weekdayLabels[i]}\n${date.day}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.w700,
                  color: active
                      ? Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

class QuoteCard extends StatelessWidget {
  const QuoteCard(this.text, {super.key});
  final String text;
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF193122)
          : const Color(0xFFEFF6E9),
      borderRadius: BorderRadius.circular(14),
    ),
    child: Text(
      text,
      style: TextStyle(
        fontSize: 10,
        color: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFFC5EDD0)
            : const Color(0xFF4D6552),
      ),
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
