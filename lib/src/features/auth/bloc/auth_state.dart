part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

// Initial state before any check has been performed
class AuthInitial extends AuthState {}

// State while checking auth status or logging in/out
class AuthLoading extends AuthState {}

// State when the user is successfully authenticated
class Authenticated extends AuthState {
  // Optionally hold user data here if needed
  // final User user;
  // const Authenticated({required this.user});
  // @override List<Object?> get props => [user];
}

// State when the user is not authenticated
class Unauthenticated extends AuthState {}

// State when an error occurs during authentication
class AuthError extends AuthState {
  final String message;

  const AuthError({required this.message});

  @override
  List<Object?> get props => [message];
}