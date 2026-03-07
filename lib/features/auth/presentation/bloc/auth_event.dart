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
  final String? country;

  const AuthRegisterRequested({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    this.country,
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
  final UserPreferences? preferences;

  const AuthUpdateProfileRequested({
    this.firstName,
    this.lastName,
    this.country,
    this.avatar,
    this.monthlyIncome,
    this.preferences,
  });

  @override
  List<Object?> get props => [
    firstName,
    lastName,
    country,
    avatar,
    monthlyIncome,
    preferences,
  ];
}

class AuthAccountSuspended extends AuthEvent {}

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

class AuthGoogleSignInRequested extends AuthEvent {
  final String? countryCode;
  const AuthGoogleSignInRequested({this.countryCode});
  @override
  List<Object?> get props => [countryCode];
}

class AuthAppleSignInRequested extends AuthEvent {
  final String? countryCode;
  const AuthAppleSignInRequested({this.countryCode});
  @override
  List<Object?> get props => [countryCode];
}

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
  final String countryCode;
  const AuthPhoneVerificationRequested(this.phoneNumber, this.countryCode);
  @override
  List<Object?> get props => [phoneNumber, countryCode];
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

class AuthChangePasswordRequested extends AuthEvent {
  final String currentPassword;
  final String newPassword;

  const AuthChangePasswordRequested({
    required this.currentPassword,
    required this.newPassword,
  });

  @override
  List<Object?> get props => [currentPassword, newPassword];
}

class AuthDeleteAccountRequested extends AuthEvent {}

class AuthSubmitKYCRequested extends AuthEvent {
  final String fullName;
  final String documentType;
  final String documentNumber;
  final String docFilePath;
  final String selfieFilePath;

  const AuthSubmitKYCRequested({
    required this.fullName,
    required this.documentType,
    required this.documentNumber,
    required this.docFilePath,
    required this.selfieFilePath,
  });

  @override
  List<Object?> get props => [
    fullName,
    documentType,
    documentNumber,
    docFilePath,
    selfieFilePath,
  ];
}

class AuthGetSessionsRequested extends AuthEvent {}

class AuthBiometricLoginRequested extends AuthEvent {}

class AuthRefreshUserRequested extends AuthEvent {}

class AuthRevokeSessionRequested extends AuthEvent {
  final String sessionId;
  const AuthRevokeSessionRequested(this.sessionId);
  @override
  List<Object?> get props => [sessionId];
}

class AuthRevokeAllSessionsRequested extends AuthEvent {}

class AuthRequestCountryChange extends AuthEvent {
  final String countryCode;
  const AuthRequestCountryChange(this.countryCode);
  @override
  List<Object?> get props => [countryCode];
}

class AuthSaveBiometricCredentialsRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthSaveBiometricCredentialsRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

class AuthSetupBiometricsSocialRequested extends AuthEvent {}
