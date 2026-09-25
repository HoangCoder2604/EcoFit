import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../core/theme/eco_fit_theme.dart';
import 'router/app_router.dart';
import 'router/app_routes.dart';
import 'state/eco_fit_app_state.dart';

class EcoFitApp extends StatefulWidget {
  const EcoFitApp({super.key, AppRouter? router}) : _router = router;

  final AppRouter? _router;

  @override
  State<EcoFitApp> createState() => _EcoFitAppState();
}

class _EcoFitAppState extends State<EcoFitApp> {
  late final AppRouter _router;
  late String _appearance;

  @override
  void initState() {
    super.initState();
    _router = widget._router ?? AppRouter();
    _appearance = EcoFitAppState.instance.appearance;
    EcoFitAppState.instance.addListener(_handleSettingsChanged);
    EcoFitAppState.instance.load();
  }

  void _handleSettingsChanged() {
    final next = EcoFitAppState.instance.appearance;
    if (next != _appearance && mounted) setState(() => _appearance = next);
  }

  @override
  void dispose() {
    EcoFitAppState.instance.removeListener(_handleSettingsChanged);
    super.dispose();
  }

  ThemeMode get _themeMode => switch (_appearance) {
    'light' => ThemeMode.light,
    'dark' => ThemeMode.dark,
    _ => ThemeMode.system,
  };

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Eco Fit',
    debugShowCheckedModeBanner: false,
    theme: ecoFitTheme,
    darkTheme: ecoFitDarkTheme,
    themeMode: _themeMode,
    initialRoute: AppRoutes.splash,
    onGenerateRoute: _router.onGenerateRoute,
    navigatorObservers: [_router.routeObserver],
    builder: (context, child) {
      if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) {
        return child ?? const SizedBox.shrink();
      }
      final media = MediaQuery.of(context);
      final systemScale = media.textScaler.scale(10) / 10;
      final androidScale = (systemScale * 1.12).clamp(1.0, 1.4);
      return MediaQuery(
        data: media.copyWith(textScaler: TextScaler.linear(androidScale)),
        child: child ?? const SizedBox.shrink(),
      );
    },
  );
}
