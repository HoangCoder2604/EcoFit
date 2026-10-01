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
  late bool _stateReady;

  @override
  void initState() {
    super.initState();
    _router = widget._router ?? AppRouter(enforceAuthentication: true);
    _appearance = EcoFitAppState.instance.appearance;
    _stateReady = EcoFitAppState.instance.isLoaded;
    EcoFitAppState.instance.addListener(_handleSettingsChanged);
    _loadAppState();
  }

  Future<void> _loadAppState() async {
    await EcoFitAppState.instance.load();
    if (!mounted) return;
    setState(() {
      _appearance = EcoFitAppState.instance.appearance;
      _stateReady = true;
    });
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
  Widget build(BuildContext context) {
    if (!_stateReady) {
      return const Directionality(
        textDirection: TextDirection.ltr,
        child: ColoredBox(
          color: Color(0xFF0D1A13),
          child: Center(
            child: SizedBox.square(
              dimension: 30,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: Color(0xFF49C96D),
              ),
            ),
          ),
        ),
      );
    }

    return MaterialApp(
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
}
