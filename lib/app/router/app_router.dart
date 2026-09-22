import 'package:flutter/material.dart';

import '../../features/features.dart';
import 'app_routes.dart';

class AppRouter {
  AppRouter();

  final RouteObserver<ModalRoute<void>> routeObserver =
      RouteObserver<ModalRoute<void>>();

  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final mealId = AppRoutes.mealIdFrom(settings.name);
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
      _ => const _UnknownRouteScreen(),
    };

    return _page(settings, screen);
  }

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
