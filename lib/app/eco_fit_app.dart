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

  @override
  void initState() {
    super.initState();
    _router = widget._router ?? AppRouter();
    EcoFitAppState.instance.load();
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Eco Fit',
    debugShowCheckedModeBanner: false,
    theme: ecoFitTheme,
    initialRoute: AppRoutes.splash,
    onGenerateRoute: _router.onGenerateRoute,
    navigatorObservers: [_router.routeObserver],
  );
}
