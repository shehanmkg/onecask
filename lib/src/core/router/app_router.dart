import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/bloc/auth_bloc.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/welcome_screen.dart';
import '../../features/collection/presentation/screens/collection_screen.dart';
import '../../features/collection/presentation/screens/details_screen.dart';
import '../../features/collection/presentation/screens/bottle_details_screen.dart';

class AppRouter {
  final AuthBloc authBloc;

  AppRouter({required this.authBloc});

  late final GoRouter router = GoRouter(
    refreshListenable: GoRouterRefreshStream(authBloc.stream),
    initialLocation: SplashScreen.routeName,
    debugLogDiagnostics: true,

    routes: <RouteBase>[
      GoRoute(
        path: SplashScreen.routeName,
        name: SplashScreen.routeName,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: WelcomeScreen.routeName,
        name: WelcomeScreen.routeName,
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: LoginScreen.routeName,
        name: LoginScreen.routeName,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
          path: CollectionScreen.routeName,
          name: CollectionScreen.routeName,
          builder: (context, state) => const CollectionScreen(),
          routes: [
            GoRoute(
              path: 'details/:itemId',
              name: DetailsScreen.routeName,
              builder: (context, state) {
                final itemId = state.pathParameters['itemId']!;
                return DetailsScreen(itemId: itemId);
              },
            ),
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

      if (!loggedIn && !loggingIn) {
        print("Redirecting to Welcome");
        return WelcomeScreen.routeName;
      }

      if (loggedIn && loggingIn) {
        print("Redirecting to Collection");
        return CollectionScreen.routeName;
      }

      print("No redirect needed.");
      return null;
    },
  );
}

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
