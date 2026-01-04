part of 'auth_bloc.dart';

enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error,
  passwordResetEmailSent,
  passwordResetSuccess,
  codeSent,
  phoneLinked,
}

class AuthState extends Equatable {
  final AuthStatus status;
  final AuthResponse? authResponse;
  final String? errorMessage;
  final String? verificationId;

  const AuthState({
    this.status = AuthStatus.initial,
    this.authResponse,
    this.errorMessage,
    this.verificationId,
  });

  factory AuthState.initial() => const AuthState();

  AuthState copyWith({
    AuthStatus? status,
    AuthResponse? authResponse,
    String? errorMessage,
    String? verificationId,
  }) {
    return AuthState(
      status: status ?? this.status,
      authResponse: authResponse ?? this.authResponse,
      errorMessage: errorMessage ?? this.errorMessage,
      verificationId: verificationId ?? this.verificationId,
    );
  }

  @override
  List<Object?> get props => [
    status,
    authResponse,
    errorMessage,
    verificationId,
  ];
}
