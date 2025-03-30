library auth_bloc;

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences

part 'auth_event.dart';
part 'auth_state.dart';

const String _authKey = 'isAuthenticated'; // Key for shared_preferences

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<CheckAuthStatus>(_onCheckAuthStatus);
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);

    // Trigger initial check
    add(CheckAuthStatus());
  }

  Future<void> _onCheckAuthStatus(
      CheckAuthStatus event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      final bool isAuthenticated = prefs.getBool(_authKey) ?? false;

      await Future.delayed(const Duration(seconds: 1)); // Simulate loading

      if (isAuthenticated) {
        emit(Authenticated());
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(AuthError(message: "Failed to check auth status: ${e.toString()}"));
    }
  }

  Future<void> _onLoginRequested(
      LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      // --- Mock Login Logic ---
      await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
      if (event.username == 'user@gmail.com' && event.password == 'password') {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool(_authKey, true); // Store auth status
        emit(Authenticated());
      } else {
        emit(const AuthError(message: 'Invalid username or password'));
        // Ensure we transition back to Unauthenticated after showing error briefly
        await Future.delayed(const Duration(milliseconds: 50));
        emit(Unauthenticated());
      }
      // --- End Mock Login Logic ---
    } catch (e) {
      emit(AuthError(message: "Login failed: ${e.toString()}"));
       await Future.delayed(const Duration(milliseconds: 50));
       emit(Unauthenticated()); // Ensure state consistency on error
    }
  }

  Future<void> _onLogoutRequested(
      LogoutRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_authKey, false); // Clear auth status
      await Future.delayed(const Duration(milliseconds: 500)); // Simulate delay
      emit(Unauthenticated());
    } catch (e) {
       emit(AuthError(message: "Logout failed: ${e.toString()}"));
       // Even on logout error, treat as unauthenticated
       await Future.delayed(const Duration(milliseconds: 50));
       emit(Unauthenticated());
    }
  }
}