abstract final class AppRoutes {
  static const splash = '/';
  static const onboardingFood = '/onboarding-food';
  static const onboardingWorkout = '/onboarding-workout';
  static const login = '/login';
  static const home = '/home';
  static const meals = '/meals';
  static const grocery = '/grocery';
  static const workouts = '/workouts';
  static const exercise = '/exercise';
  static const progress = '/progress';
  static const metrics = '/metrics';
  static const checkIn = '/checkin';
  static const coach = '/coach';
  static const profile = '/profile';
  static const workoutSession = '/workout/session';
  static const accountSettings = '/settings/account';
  static const notificationSettings = '/settings/notifications';
  static const languageSettings = '/settings/language';
  static const appearanceSettings = '/settings/appearance';
  static const help = '/settings/help';
  static const about = '/settings/about';

  static const _mealPrefix = '/meal/';

  static String mealDetail(String mealId) => '$_mealPrefix$mealId';

  static String? mealIdFrom(String? routeName) {
    if (routeName == null || !routeName.startsWith(_mealPrefix)) return null;
    final id = routeName.substring(_mealPrefix.length).trim();
    return id.isEmpty ? null : id;
  }

  static const knownRoutes = <String>{
    splash,
    onboardingFood,
    onboardingWorkout,
    login,
    home,
    meals,
    grocery,
    workouts,
    exercise,
    progress,
    metrics,
    checkIn,
    coach,
    profile,
    workoutSession,
    accountSettings,
    notificationSettings,
    languageSettings,
    appearanceSettings,
    help,
    about,
  };
}
