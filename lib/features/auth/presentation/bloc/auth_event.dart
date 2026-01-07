part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthCheckRequested extends AuthEvent {}

class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthLoginRequested({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class AuthRegisterRequested extends AuthEvent {
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final String country;

  const AuthRegisterRequested({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.country,
  });

  @override
  List<Object?> get props => [email, password, firstName, lastName, country];
}

class AuthUpdateProfileRequested extends AuthEvent {
  final String? firstName;
  final String? lastName;
  final String? country;
  final String? avatar;
  final double? monthlyIncome;

  const AuthUpdateProfileRequested({
    this.firstName,
    this.lastName,
    this.country,
    this.avatar,
    this.monthlyIncome,
  });

  @override
  List<Object?> get props => [
    firstName,
    lastName,
    country,
    avatar,
    monthlyIncome,
  ];
}

class AuthLogoutRequested extends AuthEvent {}

class AuthForgotPasswordRequested extends AuthEvent {
  final String email;

  const AuthForgotPasswordRequested(this.email);

  @override
  List<Object?> get props => [email];
}

class AuthResetPasswordRequested extends AuthEvent {
  final String token;
  final String newPassword;

  const AuthResetPasswordRequested({
    required this.token,
    required this.newPassword,
  });

  @override
  List<Object?> get props => [token, newPassword];
}

class AuthGoogleSignInRequested extends AuthEvent {}

class _AuthInternalCodeSent extends AuthEvent {
  const _AuthInternalCodeSent();
}

class _AuthInternalError extends AuthEvent {
  final String message;
  const _AuthInternalError(this.message);
  @override
  List<Object?> get props => [message];
}

class AuthPhoneVerificationRequested extends AuthEvent {
  final String phoneNumber;
  const AuthPhoneVerificationRequested(this.phoneNumber);
  @override
  List<Object?> get props => [phoneNumber];
}

class AuthPhoneSignInRequested extends AuthEvent {
  final String verificationId;
  final String smsCode;
  const AuthPhoneSignInRequested({
    required this.verificationId,
    required this.smsCode,
  });
  @override
  List<Object?> get props => [verificationId, smsCode];
}

class AuthLinkPhoneRequested extends AuthEvent {
  final String verificationId;
  final String smsCode;
  const AuthLinkPhoneRequested({
    required this.verificationId,
    required this.smsCode,
  });
  @override
  List<Object?> get props => [verificationId, smsCode];
}
