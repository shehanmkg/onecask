import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../bloc/auth_bloc.dart';
import '../../../collection/presentation/screens/collection_screen.dart'; // Import CollectionScreen
import 'welcome_screen.dart'; // Import WelcomeScreen from the same directory

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  // Define route name for potential use with go_router
  static const String routeName = '/login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
            LoginRequested(
              username: _emailController.text.trim(),
              password: _passwordController.text.trim(),
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E1C21), // Updated background color to #0E1C21
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          // Prevent navigation if context is no longer mounted
          if (!context.mounted) return;

          if (state is Authenticated) {
            // Navigate to Collection screen on successful login
            context.go(CollectionScreen.routeName);
          } else if (state is AuthError) {
            // Show error message
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              // Main content
              SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          // Back button
                          IconButton(
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                              size: 24,
                            ),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: () {
                              context.go(WelcomeScreen.routeName);
                            },
                          ),
                          const SizedBox(height: 40),

                          // Sign in heading
                          Text(
                            'Sign in',
                            style: const TextStyle(
                              fontFamily: 'EBGaramond',
                              color: Color(0xFFE7E9EA),
                              fontSize: 32,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 40),

                          // Email field
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Email',
                                style: const TextStyle(
                                  fontFamily: 'Lato',
                                  color: Color(0xFFB8BDBF),
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _emailController,
                                style: const TextStyle(
                                  fontFamily: 'Lato',
                                  color: Color(0xFFE7E9EA),
                                ),
                                decoration: const InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.only(bottom: 8),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white38, width: 1.0),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xFFDE9A1F), width: 1.0),
                                  ),
                                  hintText: 'email@email.com',
                                  hintStyle: TextStyle(color: Colors.white54),
                                ),
                                keyboardType: TextInputType.emailAddress,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(50), // Max 50 characters for email
                                ],
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your email';
                                  }
                                  if (value.length < 5 || !value.contains('@')) {
                                    return 'Please enter a valid email address';
                                  }
                                  return null;
                                },
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                onChanged: (_) {
                                  // Trigger revalidation when text changes
                                  _formKey.currentState?.validate();
                                },
                                textInputAction: TextInputAction.next,
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),

                          // Password field
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Password',
                                style: const TextStyle(
                                  fontFamily: 'Lato',
                                  color: Color(0xFFB8BDBF),
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _passwordController,
                                style: const TextStyle(
                                  fontFamily: 'Lato',
                                  color: Color(0xFFE7E9EA),
                                ),
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: const EdgeInsets.only(bottom: 8),
                                  enabledBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xFFD49A00), width: 1.0),
                                  ),
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xFFD49A00), width: 1.0),
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                      color: const Color(0xFFFFB901),
                                      size: 22,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscurePassword = !_obscurePassword;
                                      });
                                    },
                                    splashRadius: 20,
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                  ),
                                ),
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(20), // Max 20 characters for password
                                ],
                                obscureText: _obscurePassword,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your password';
                                  }
                                  if (value.length < 6) {
                                    return 'Password must be at least 6 characters';
                                  }
                                  return null;
                                },
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                onChanged: (_) {
                                  // Trigger revalidation when text changes
                                  _formKey.currentState?.validate();
                                },
                                textInputAction: TextInputAction.done,
                                onEditingComplete: _login,
                              ),
                            ],
                          ),
                          const SizedBox(height: 40),

                          // Continue button
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: state is AuthLoading
                                ? const Center(child: CircularProgressIndicator(color: Color(0xFFDE9A1F)))
                                : ElevatedButton(
                                    onPressed: _login,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFDE9A1F),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: Text(
                                      'Continue',
                                      style: const TextStyle(
                                        fontFamily: 'Lato',
                                        color: Color(0xFF0E1C21),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                          ),
                          const SizedBox(height: 30),

                          // Can't sign in / Recovery password row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Can\'t sign in?',
                                style: const TextStyle(
                                  fontFamily: 'Lato',
                                  color: Color(0xFFB8BDBF),
                                ),
                              ),
                              const SizedBox(width: 8),
                              TextButton(
                                onPressed: () {
                                  // Implement password recovery
                                },
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size.zero,
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: Text(
                                  'Forgot Password?',
                                  style: const TextStyle(
                                    fontFamily: 'Lato',
                                    color: Color(0xFFDE9A1F),
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
