import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import '../../data/models/auth_response.dart';
import '../../data/models/login_request.dart';
import '../../data/models/register_request.dart';
import '../../data/models/session_model.dart';
import '../../domain/repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

@lazySingleton
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc(this._authRepository) : super(AuthState.initial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthLoginRequested>(_onAuthLoginRequested);
    on<AuthRegisterRequested>(_onAuthRegisterRequested);
    on<AuthUpdateProfileRequested>(_onAuthUpdateProfileRequested);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
    on<AuthForgotPasswordRequested>(_onAuthForgotPasswordRequested);
    on<AuthResetPasswordRequested>(_onAuthResetPasswordRequested);
    on<AuthGoogleSignInRequested>(_onAuthGoogleSignInRequested);
    on<AuthAppleSignInRequested>(_onAuthAppleSignInRequested);
    on<AuthPhoneVerificationRequested>(_onAuthPhoneVerificationRequested);
    on<AuthPhoneSignInRequested>(_onAuthPhoneSignInRequested);
    on<AuthLinkPhoneRequested>(_onAuthLinkPhoneRequested);
    on<AuthChangePasswordRequested>(_onAuthChangePasswordRequested);
    on<AuthDeleteAccountRequested>(_onAuthDeleteAccountRequested);
    on<AuthGetSessionsRequested>(_onAuthGetSessionsRequested);
    on<AuthBiometricLoginRequested>(_onAuthBiometricLoginRequested);
    on<AuthRefreshUserRequested>(_onAuthRefreshUserRequested);
    on<AuthRevokeSessionRequested>(_onAuthRevokeSessionRequested);
    on<AuthRevokeAllSessionsRequested>(_onAuthRevokeAllSessionsRequested);
    on<_AuthInternalCodeSent>(_onAuthInternalCodeSent);
    on<_AuthInternalError>(_onAuthInternalError);
    on<AuthRequestCountryChange>(_onAuthRequestCountryChange);
  }

  String? _verificationId;
  String? _tempCountryCode;

  void _onAuthInternalCodeSent(
    _AuthInternalCodeSent event,
    Emitter<AuthState> emit,
  ) {
    emit(
      state.copyWith(
        status: AuthStatus.codeSent,
        verificationId: _verificationId,
      ),
    );
  }

  void _onAuthInternalError(_AuthInternalError event, Emitter<AuthState> emit) {
    emit(state.copyWith(status: AuthStatus.error, errorMessage: event.message));
  }

  Future<void> _onAuthPhoneVerificationRequested(
    AuthPhoneVerificationRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));
    _tempCountryCode = event.countryCode;
    final result = await _authRepository.verifyPhoneNumber(
      event.phoneNumber,
      onCodeSent: (verificationId) {
        _verificationId = verificationId;
        add(const _AuthInternalCodeSent());
      },
      onVerificationFailed: (errorMessage) {
        add(_AuthInternalError(errorMessage));
      },
    );

    result.fold(
      (failure) => emit(
        state.copyWith(status: AuthStatus.error, errorMessage: failure.message),
      ),
      (_) => null, // Wait for callbacks
    );
  }

  Future<void> _onAuthPhoneSignInRequested(
    AuthPhoneSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));
    final result = await _authRepository.signInWithPhoneNumber(
      event.verificationId,
      event.smsCode,
    );
    result.fold(
      (failure) => emit(
        state.copyWith(status: AuthStatus.error, errorMessage: failure.message),
      ),
      (response) {
        _authRepository.updateDeviceInfo();
        _authRepository.logConnection();
        // Initialize country if we have a temporary country code
        if (_tempCountryCode != null) {
          _authRepository.updateProfile(country: _tempCountryCode);
          _tempCountryCode = null;
        }
        emit(
          state.copyWith(
            status: AuthStatus.authenticated,
            authResponse: response,
          ),
        );
      },
    );
  }

  Future<void> _onAuthLinkPhoneRequested(
    AuthLinkPhoneRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));
    final result = await _authRepository.linkPhoneNumber(
      event.verificationId,
      event.smsCode,
    );
    result.fold(
      (failure) => emit(
        state.copyWith(status: AuthStatus.error, errorMessage: failure.message),
      ),
      (_) => emit(state.copyWith(status: AuthStatus.phoneLinked)),
    );
  }

  Future<void> _onAuthGoogleSignInRequested(
    AuthGoogleSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));
    final result = await _authRepository.signInWithGoogle(
      countryCode: event.countryCode,
    );
    result.fold(
      (failure) => emit(
        state.copyWith(status: AuthStatus.error, errorMessage: failure.message),
      ),
      (response) {
        _authRepository.updateDeviceInfo();
        _authRepository.logConnection();
        emit(
          state.copyWith(
            status: AuthStatus.authenticated,
            authResponse: response,
          ),
        );
      },
    );
  }

  Future<void> _onAuthAppleSignInRequested(
    AuthAppleSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));
    final result = await _authRepository.signInWithApple();
    result.fold(
      (failure) => emit(
        state.copyWith(status: AuthStatus.error, errorMessage: failure.message),
      ),
      (response) {
        _authRepository.updateDeviceInfo();
        _authRepository.logConnection();
        emit(
          state.copyWith(
            status: AuthStatus.authenticated,
            authResponse: response,
          ),
        );
      },
    );
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    debugPrint('🔑 [AuthBloc] Checking authentication status...');
    emit(state.copyWith(status: AuthStatus.loading));
    final isAuthenticated = await _authRepository.isAuthenticated();

    if (isAuthenticated) {
      debugPrint(
        '🔑 [AuthBloc] User is authenticated in storage, fetching user data...',
      );
      final userResult = await _authRepository.getCurrentUser();

      final String? accessToken = await _authRepository.getAccessToken();
      final String? refreshToken = await _authRepository.getRefreshToken();

      userResult.fold(
        (failure) {
          debugPrint(
            '🔑 [AuthBloc] Failed to fetch local user data: ${failure.message}',
          );
          emit(state.copyWith(status: AuthStatus.unauthenticated));
        },
        (user) {
          debugPrint('🔑 [AuthBloc] Session recovered for user: ${user.email}');
          _authRepository.updateDeviceInfo(); // Fire and forget
          _authRepository.logConnection();
          emit(
            state.copyWith(
              status: AuthStatus.authenticated,
              authResponse: AuthResponse(
                tokens: Tokens(
                  accessToken: accessToken ?? '',
                  refreshToken: refreshToken ?? '',
                ),
                user: user,
              ),
            ),
          );
        },
      );
    } else {
      debugPrint('🔑 [AuthBloc] No session found (unauthenticated)');
      emit(state.copyWith(status: AuthStatus.unauthenticated));
    }
  }

  Future<void> _onAuthLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));
    final result = await _authRepository.login(
      LoginRequest(email: event.email, password: event.password),
    );
    result.fold<void>(
      (failure) => emit(
        state.copyWith(status: AuthStatus.error, errorMessage: failure.message),
      ),
      (response) {
        _authRepository.updateDeviceInfo();
        _authRepository.logConnection();
        emit(
          state.copyWith(
            status: AuthStatus.authenticated,
            authResponse: response,
          ),
        );
      },
    );
  }

  Future<void> _onAuthRegisterRequested(
    AuthRegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));
    final result = await _authRepository.register(
      RegisterRequest(
        email: event.email,
        password: event.password,
        firstName: event.firstName,
        lastName: event.lastName,
        country: event.country,
      ),
    );
    result.fold<void>(
      (failure) => emit(
        state.copyWith(status: AuthStatus.error, errorMessage: failure.message),
      ),
      (response) {
        _authRepository.updateDeviceInfo();
        _authRepository.logConnection();
        emit(
          state.copyWith(
            status: AuthStatus.authenticated,
            authResponse: response,
          ),
        );
      },
    );
  }

  Future<void> _onAuthLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _authRepository.logout();
    emit(
      state.copyWith(status: AuthStatus.unauthenticated, authResponse: null),
    );
  }

  Future<void> _onAuthForgotPasswordRequested(
    AuthForgotPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));
    final result = await _authRepository.forgotPassword(event.email);
    result.fold(
      (failure) => emit(
        state.copyWith(status: AuthStatus.error, errorMessage: failure.message),
      ),
      (_) => emit(state.copyWith(status: AuthStatus.passwordResetEmailSent)),
    );
  }

  Future<void> _onAuthResetPasswordRequested(
    AuthResetPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));
    final result = await _authRepository.resetPassword(
      event.token,
      event.newPassword,
    );
    result.fold(
      (failure) => emit(
        state.copyWith(status: AuthStatus.error, errorMessage: failure.message),
      ),
      (_) => emit(state.copyWith(status: AuthStatus.passwordResetSuccess)),
    );
  }

  Future<void> _onAuthUpdateProfileRequested(
    AuthUpdateProfileRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));
    final result = await _authRepository.updateProfile(
      firstName: event.firstName,
      lastName: event.lastName,
      country: event.country,
      avatar: event.avatar,
      monthlyIncome: event.monthlyIncome,
    );
    result.fold(
      (failure) => emit(
        state.copyWith(status: AuthStatus.error, errorMessage: failure.message),
      ),
      (user) => emit(
        state.copyWith(
          status: AuthStatus.authenticated,
          authResponse:
              state.authResponse?.copyWith(user: user) ??
              AuthResponse(
                tokens: Tokens(accessToken: '', refreshToken: ''),
                user: user,
              ),
        ),
      ),
    );
  }

  Future<void> _onAuthChangePasswordRequested(
    AuthChangePasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));
    final result = await _authRepository.changePassword(
      event.currentPassword,
      event.newPassword,
    );
    result.fold(
      (failure) => emit(
        state.copyWith(status: AuthStatus.error, errorMessage: failure.message),
      ),
      (_) => emit(state.copyWith(status: AuthStatus.passwordChanged)),
    );
  }

  Future<void> _onAuthDeleteAccountRequested(
    AuthDeleteAccountRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));
    final result = await _authRepository.deleteAccount();
    result.fold(
      (failure) => emit(
        state.copyWith(status: AuthStatus.error, errorMessage: failure.message),
      ),
      (_) => emit(
        state.copyWith(status: AuthStatus.unauthenticated, authResponse: null),
      ),
    );
  }

  Future<void> _onAuthGetSessionsRequested(
    AuthGetSessionsRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));
    final result = await _authRepository.getSessions();
    result.fold(
      (failure) => emit(
        state.copyWith(status: AuthStatus.error, errorMessage: failure.message),
      ),
      (sessions) => emit(
        state.copyWith(status: AuthStatus.sessionsLoaded, sessions: sessions),
      ),
    );
  }

  Future<void> _onAuthBiometricLoginRequested(
    AuthBiometricLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    final credentials = await _authRepository.getBiometricCredentials();
    if (credentials != null) {
      add(
        AuthLoginRequested(
          email: credentials['email']!,
          password: credentials['password']!,
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: AuthStatus.error,
          errorMessage:
              'No biometric credentials found. Please login normally.',
        ),
      );
    }
  }

  Future<void> _onAuthRefreshUserRequested(
    AuthRefreshUserRequested event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _authRepository.getCurrentUser();
    result.fold(
      (failure) => null, // Sliently fail or maybe log it
      (user) => emit(
        state.copyWith(
          status: AuthStatus.authenticated,
          authResponse: state.authResponse?.copyWith(user: user),
        ),
      ),
    );
  }

  Future<void> _onAuthRevokeSessionRequested(
    AuthRevokeSessionRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));
    final result = await _authRepository.revokeSession(event.sessionId);
    result.fold(
      (failure) => emit(
        state.copyWith(status: AuthStatus.error, errorMessage: failure.message),
      ),
      (_) {
        emit(state.copyWith(status: AuthStatus.sessionRevoked));
        add(AuthGetSessionsRequested());
      },
    );
  }

  Future<void> _onAuthRevokeAllSessionsRequested(
    AuthRevokeAllSessionsRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));
    final result = await _authRepository.revokeAllOtherSessions();
    result.fold(
      (failure) => emit(
        state.copyWith(status: AuthStatus.error, errorMessage: failure.message),
      ),
      (_) {
        emit(state.copyWith(status: AuthStatus.sessionRevoked));
        add(AuthGetSessionsRequested());
      },
    );
  }

  Future<void> _onAuthRequestCountryChange(
    AuthRequestCountryChange event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));
    final result = await _authRepository.requestCountryChange(
      event.countryCode,
    );
    result.fold(
      (failure) => emit(
        state.copyWith(status: AuthStatus.error, errorMessage: failure.message),
      ),
      (request) {
        emit(
          state.copyWith(
            status: AuthStatus.countryChangeRequestSubmitted,
            errorMessage: 'Country change request submitted successfully.',
          ),
        );
        // Optionally refresh user profile if needed, though status is usually PENDING
        add(AuthRefreshUserRequested());
      },
    );
  }
}
