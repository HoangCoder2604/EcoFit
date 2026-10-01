import 'package:flutter/material.dart';

import '../../features/features.dart';
import '../state/eco_fit_app_state.dart';
import 'app_routes.dart';

class AppRouter {
  AppRouter({this.enforceAuthentication = false});

  final bool enforceAuthentication;

  final RouteObserver<ModalRoute<void>> routeObserver =
      RouteObserver<ModalRoute<void>>();

  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final mealId = AppRoutes.mealIdFrom(settings.name);
    if (enforceAuthentication &&
        !_isPublicRoute(settings.name) &&
        !EcoFitAppState.instance.isAuthenticated) {
      return _page(
        const RouteSettings(name: AppRoutes.login),
        const LoginScreen(),
      );
    }
    if (mealId != null) {
      return _page(settings, MealDetailScreen(mealId: mealId));
    }

    final screen = switch (settings.name) {
      AppRoutes.splash => const SplashScreen(),
      AppRoutes.onboardingFood => const FoodOnboardingScreen(),
      AppRoutes.onboardingWorkout => const WorkoutOnboardingScreen(),
      AppRoutes.login => const LoginScreen(),
      AppRoutes.home => const HomeScreen(),
      AppRoutes.meals => const MealsScreen(),
      AppRoutes.grocery => const GroceryScreen(),
      AppRoutes.workouts => const WorkoutsScreen(),
      AppRoutes.exercise => const ExerciseDetailScreen(),
      AppRoutes.progress => const ProgressScreen(),
      AppRoutes.metrics => const BodyMetricsScreen(),
      AppRoutes.checkIn => const CheckInScreen(),
      AppRoutes.coach => const AiCoachScreen(),
      AppRoutes.profile => const ProfileScreen(),
      AppRoutes.workoutSession => const WorkoutSessionScreen(),
      AppRoutes.accountSettings => const SettingsDetailScreen.account(),
      AppRoutes.notificationSettings =>
        const SettingsDetailScreen.notifications(),
      AppRoutes.languageSettings => const SettingsDetailScreen.language(),
      AppRoutes.appearanceSettings => const SettingsDetailScreen.appearance(),
      AppRoutes.help => const SettingsDetailScreen.help(),
      AppRoutes.about => const SettingsDetailScreen.about(),
      _ => const _UnknownRouteScreen(),
    };

    return _page(settings, screen);
  }

  bool _isPublicRoute(String? route) =>
      route == AppRoutes.splash ||
      route == AppRoutes.onboardingFood ||
      route == AppRoutes.onboardingWorkout ||
      route == AppRoutes.login;

  MaterialPageRoute<void> _page(RouteSettings settings, Widget screen) {
    return MaterialPageRoute<void>(settings: settings, builder: (_) => screen);
  }
}

class _UnknownRouteScreen extends StatelessWidget {
  const _UnknownRouteScreen();

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Không tìm thấy trang')),
    body: Center(
      child: FilledButton.icon(
        onPressed: () => Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.splash,
          (_) => false,
        ),
        icon: const Icon(Icons.home_outlined),
        label: const Text('Về trang bắt đầu'),
      ),
    ),
  );
}
