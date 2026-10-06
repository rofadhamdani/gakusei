import "package:flutter/foundation.dart";
import "package:go_router/go_router.dart";

import "../config/supabase_config.dart";
import "../../features/auth/presentation/login_screen.dart";
import "../../features/auth/presentation/onboarding_screen.dart";
import "../../features/auth/presentation/splash_screen.dart";
import "../../features/home/presentation/home_screen.dart";
import "../../main_shell.dart";

class AppRouter {
  static final _authRefresh = _AuthRefreshListenable();

  static final GoRouter router = GoRouter(
    refreshListenable: _authRefresh,
    redirect: (context, state) {
      final isAuthenticated = SupabaseConfig.client.auth.currentSession != null;
      final isPublicRoute = {
        "/splash",
        "/onboarding",
        "/login",
      }.contains(state.matchedLocation);

      if (isAuthenticated && isPublicRoute) return "/";
      if (!isAuthenticated && !isPublicRoute) return "/login";
      return null;
    },
    routes: [
      GoRoute(
        path: "/splash",
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: "/onboarding",
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(path: "/login", builder: (context, state) => const LoginScreen()),
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

class _AuthRefreshListenable extends ChangeNotifier {
  _AuthRefreshListenable() {
    SupabaseConfig.client.auth.onAuthStateChange.listen((_) {
      notifyListeners();
    });
  }
}
