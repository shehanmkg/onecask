import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../bloc/auth_bloc.dart';
import '../../../collection/presentation/screens/collection_screen.dart'; // Import CollectionScreen
import 'welcome_screen.dart'; // Import WelcomeScreen

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  // Define route name for potential use with go_router
  static const String routeName = '/splash';

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        // Use a short delay to prevent flicker if auth check is instant
        Future.delayed(const Duration(milliseconds: 1500), () {
          // Prevent navigation if context is no longer mounted after delay
          if (!context.mounted) return;

          if (state is Authenticated) {
            // Navigate to Collection screen
            context.go(CollectionScreen.routeName);
          } else if (state is Unauthenticated || state is AuthError) {
            // Navigate to Welcome screen
            context.go(WelcomeScreen.routeName);
          }
        });
      },
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            color: Color(0xFF0B1519), // Updated to exact background color from design
          ),
          child: Stack(
            children: [
              // Background wave pattern image
              Positioned.fill(
                child: Image.asset(
                  'assets/images/background.png',
                  fit: BoxFit.cover,
                ),
              ),

              // Main content
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/logo_one_cask.png',
                      width: 140,
                      height: 140,
                      fit: BoxFit.contain,
                    ),
                    Text(
                      'One Cask',
                      style: const TextStyle(
                        fontFamily: 'EBGaramond',
                        color: Color(0xFFE7E9EA),
                        fontSize: 36,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
