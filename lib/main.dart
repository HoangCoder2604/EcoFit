import 'package:flutter/material.dart';

import 'screens.dart';
import 'theme.dart';

void main() => runApp(const EcoFitApp());

class EcoFitApp extends StatelessWidget {
  const EcoFitApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Eco Fit',
    debugShowCheckedModeBanner: false,
    theme: ecoFitTheme,
    initialRoute: '/',
    routes: {
      '/': (_) => const SplashScreen(),
      '/onboarding-food': (_) => const FoodOnboardingScreen(),
      '/onboarding-workout': (_) => const WorkoutOnboardingScreen(),
      '/login': (_) => const LoginScreen(),
      '/home': (_) => const HomeScreen(),
      '/meals': (_) => const MealsScreen(),
      '/grocery': (_) => const GroceryScreen(),
      '/workouts': (_) => const WorkoutsScreen(),
      '/exercise': (_) => const ExerciseDetailScreen(),
      '/progress': (_) => const ProgressScreen(),
      '/metrics': (_) => const BodyMetricsScreen(),
      '/checkin': (_) => const CheckInScreen(),
      '/coach': (_) => const AiCoachScreen(),
      '/profile': (_) => const ProfileScreen(),
    },
    onGenerateRoute: (settings) {
      if (settings.name?.startsWith('/meal/') ?? false) {
        return MaterialPageRoute(
          builder: (_) =>
              MealDetailScreen(mealId: settings.name!.split('/').last),
        );
      }
      return MaterialPageRoute(builder: (_) => const SplashScreen());
    },
  );
}
