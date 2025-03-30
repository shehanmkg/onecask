part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

// Event triggered when the app starts to check the current auth status
class CheckAuthStatus extends AuthEvent {}

// Event triggered when the user attempts to log in
class LoginRequested extends AuthEvent {
  final String username;
  final String password;

  const LoginRequested({required this.username, required this.password});

  @override
  List<Object?> get props => [username, password];
}

// Event triggered when the user logs out
class LogoutRequested extends AuthEvent {}