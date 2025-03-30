import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'login_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  static const String routeName = '/welcome';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xFF0B1519),
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.fromLTRB(24, 0, 24, 48),
                    padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
                    decoration: BoxDecoration(
                      color: const Color(0xFF122329),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Welcome!',
                          style: const TextStyle(
                            fontFamily: 'EBGaramond',
                            color: Color(0xFFE7E9EA),
                            fontSize: 36,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'The home of your authentic whiskey collection',
                          style: const TextStyle(
                            fontFamily: 'Lato',
                            color: Color(0xFFE7E9EA),
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 36),
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0x40000000),
                                  blurRadius: 4,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFD49A00),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                elevation: 4,
                              ),
                              child: const Text(
                                'Scan bottle',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF0B1519),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Already have an account? Sign in',
                              style: const TextStyle(
                                fontFamily: 'Lato',
                                color: Color(0xFFE7E9EA),
                                fontSize: 14,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                context.go(LoginScreen.routeName);
                              },
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 6),
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text(
                                'Sign in first',
                                style: const TextStyle(
                                  fontFamily: 'EBGaramond',
                                  color: Color(0xFFFFB901),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
