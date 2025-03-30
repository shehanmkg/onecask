import 'dart:async'; // Import for StreamSubscription

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/bloc/auth_bloc.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/welcome_screen.dart';
// Import Collection/Details screens
import '../../features/collection/presentation/screens/collection_screen.dart';
import '../../features/collection/presentation/screens/details_screen.dart';
import '../../features/collection/presentation/screens/bottle_details_screen.dart';

class AppRouter {
  final AuthBloc authBloc;

  AppRouter({required this.authBloc});

  late final GoRouter router = GoRouter(
    // Observe auth state changes for redirection
    refreshListenable: GoRouterRefreshStream(authBloc.stream),
    initialLocation: SplashScreen.routeName, // Start at splash screen
    debugLogDiagnostics: true, // Log routing diagnostics (useful for debugging)

    routes: <RouteBase>[
      // Splash Screen
      GoRoute(
        path: SplashScreen.routeName, // '/' or '/splash'
        name: SplashScreen.routeName,
        builder: (context, state) => const SplashScreen(),
      ),
      // Welcome Screen
      GoRoute(
        path: WelcomeScreen.routeName, // '/welcome'
        name: WelcomeScreen.routeName,
        builder: (context, state) => const WelcomeScreen(),
      ),
      // Login Screen
      GoRoute(
        path: LoginScreen.routeName, // '/login'
        name: LoginScreen.routeName,
        builder: (context, state) => const LoginScreen(),
      ),
      // Collection Screen (Protected)
      GoRoute(
          path: CollectionScreen.routeName, // Use actual screen route name
          name: CollectionScreen.routeName, // Use actual screen route name
          builder: (context, state) => const CollectionScreen(), // Use actual screen widget
          // Add redirection logic here if needed, though redirect handles main auth flow
          routes: [
            // Details Screen (Nested under collection)
            GoRoute(
              path: 'details/:itemId', // e.g., /collection/details/123
              name: DetailsScreen.routeName, // Use actual screen route name
              builder: (context, state) {
                final itemId = state.pathParameters['itemId']!;
                return DetailsScreen(itemId: itemId); // Use actual screen widget
              },
            ),
            // Bottle Details Screen
            GoRoute(
              path: 'bottle/:bottleId',
              name: BottleDetailsScreen.routeName,
              builder: (context, state) {
                final bottleId = state.pathParameters['bottleId'] ?? '1';
                return BottleDetailsScreen(bottleId: bottleId);
              },
            ),
          ]),
    ],

    redirect: (BuildContext context, GoRouterState state) {
      final bool loggedIn = authBloc.state is Authenticated;
      final bool loggingIn = state.matchedLocation == LoginScreen.routeName ||
          state.matchedLocation == WelcomeScreen.routeName ||
          state.matchedLocation == SplashScreen.routeName;

      print("Redirect Check: loggedIn=$loggedIn, location=${state.matchedLocation}");

      // If user is not logged in and not on an auth screen, redirect to Welcome
      if (!loggedIn && !loggingIn) {
        print("Redirecting to Welcome");
        return WelcomeScreen.routeName;
      }

      // If user is logged in and on an auth screen (Splash, Welcome, Login), redirect to Collection
      if (loggedIn && loggingIn) {
        print("Redirecting to Collection");
        return CollectionScreen.routeName; // Use actual screen route name
      }

      // No redirect needed
      print("No redirect needed.");
      return null;
    },
  );
}

// Helper class to make GoRouter listen to BLoC stream changes
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
