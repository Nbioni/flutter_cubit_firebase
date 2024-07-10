abstract class AuthState {}

class InitialAuthState extends AuthState {}

class LoadingAuthState extends AuthState {}

class LoggedInAuthState extends AuthState {}

class ErrorAuthState extends AuthState {
  final String message;
  ErrorAuthState(this.message);
}