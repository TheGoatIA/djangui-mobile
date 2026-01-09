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
  passwordChanged,
  accountDeleted,
  sessionsLoaded,
  sessionRevoked,
}

class AuthState extends Equatable {
  final AuthStatus status;
  final AuthResponse? authResponse;
  final String? errorMessage;
  final String? verificationId;
  final List<SessionModel> sessions;

  const AuthState({
    this.status = AuthStatus.initial,
    this.authResponse,
    this.errorMessage,
    this.verificationId,
    this.sessions = const [],
  });

  factory AuthState.initial() => const AuthState();

  AuthState copyWith({
    AuthStatus? status,
    AuthResponse? authResponse,
    String? errorMessage,
    String? verificationId,
    List<SessionModel>? sessions,
  }) {
    return AuthState(
      status: status ?? this.status,
      authResponse: authResponse ?? this.authResponse,
      errorMessage: errorMessage ?? this.errorMessage,
      verificationId: verificationId ?? this.verificationId,
      sessions: sessions ?? this.sessions,
    );
  }

  @override
  List<Object?> get props => [
    status,
    authResponse,
    errorMessage,
    verificationId,
    sessions,
  ];
}
