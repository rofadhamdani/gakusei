import "package:go_router/go_router.dart";

import "../../features/auth/presentation/login_screen.dart";
import "../../features/auth/presentation/onboarding_screen.dart";
import "../../features/auth/presentation/splash_screen.dart";
import "../../features/home/presentation/home_screen.dart";
import "../../main_shell.dart";

class AppRouter {
  static final GoRouter router = GoRouter(
    routes: [
      GoRoute(
        path: "/splash",
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: "/onboarding",
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: "/login",
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: "/",
        builder: (context, state) => const MainShell(),
        routes: [
          GoRoute(
            path: "home",
            builder: (context, state) => const HomeScreen(),
          ),
        ],
      ),
    ],
    initialLocation: "/splash",
  );
}

