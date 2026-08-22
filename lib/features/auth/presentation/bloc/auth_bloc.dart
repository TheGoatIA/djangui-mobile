import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../data/models/auth_response.dart';
import '../../data/models/login_request.dart';
import '../../data/models/register_request.dart';
import '../../data/models/session_model.dart';
import '../../data/models/user_model.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../../upload/domain/repositories/upload_repository.dart';

import 'package:kauri/core/analytics/analytics_service.dart';
import 'package:kauri/core/analytics/events.dart';
import 'package:kauri/core/error/error_mapper.dart';
import 'package:kauri/core/services/log_service.dart';
import 'package:kauri/core/services/telemetry_service.dart';
import 'package:kauri/di/injection.dart';
import 'package:opentelemetry/api.dart';

part 'auth_event.dart';
part 'auth_state.dart';

@lazySingleton
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  final UploadRepository _uploadRepository;
  TelemetryService get _telemetry => getIt<TelemetryService>();
  LogService get _logger => getIt<LogService>();
  AnalyticsService get _analytics => getIt<AnalyticsService>();

  /// Appelé à chaque connexion réussie, quelle que soit la méthode.
  /// Associe l'identifiant utilisateur (hashé) aux services d'observabilité.
  void _notifyAuthSuccess(AuthResponse response, {required String method}) {
    _analytics.setUserId(response.user.id);
    _analytics.logEvent(
      AnalyticsEvents.loginAttempt,
      parameters: {
        AnalyticsParams.method: method,
        AnalyticsParams.success: true,
      },
    );
  }

  AuthBloc(this._authRepository, this._uploadRepository)
    : super(AuthState.initial()) {
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
    on<AuthSaveBiometricCredentialsRequested>(
      _onAuthSaveBiometricCredentialsRequested,
    );
    on<AuthSetupBiometricsSocialRequested>(
      _onAuthSetupBiometricsSocialRequested,
    );
    on<AuthAccountSuspended>(_onAuthAccountSuspended);
    on<AuthSubmitKYCRequested>(_onAuthSubmitKYCRequested);
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
    _logger.info(
      'Tentative de connexion par téléphone...',
      component: 'AuthBloc',
    );
    emit(state.copyWith(status: AuthStatus.loading));
    final result = await _authRepository.signInWithPhoneNumber(
      event.verificationId,
      event.smsCode,
      country: _tempCountryCode,
    );
    result.fold(
      (failure) {
        _logger.warning(
          'Échec de la connexion par téléphone',
          component: 'AuthBloc',
          metadata: {'error': failure.message},
        );
        emit(
          state.copyWith(
            status: AuthStatus.error,
            errorMessage: failure.message,
          ),
        );
      },
      (response) {
        _logger.info(
          'Connexion par téléphone réussie',
          component: 'AuthBloc',
          metadata: {'user_id': response.user.id},
        );
        _authRepository.updateDeviceInfo();
        _authRepository.logConnection();
        _tempCountryCode = null;
        _logger.setUserId(response.user.id);
        _notifyAuthSuccess(response, method: 'otp');
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
      (_) {
        emit(state.copyWith(status: AuthStatus.phoneLinked));
        add(AuthRefreshUserRequested());
      },
    );
  }

  Future<void> _onAuthGoogleSignInRequested(
    AuthGoogleSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    _logger.info('Tentative de connexion Google...', component: 'AuthBloc');
    final span = _telemetry.tracer.startSpan('Auth: GoogleSignIn');
    try {
      emit(state.copyWith(status: AuthStatus.loading));
      final result = await _authRepository.signInWithGoogle(
        countryCode: event.countryCode,
      );
      result.fold(
        (failure) {
          _logger.warning(
            'Échec de la connexion Google',
            component: 'AuthBloc',
            metadata: {'error': failure.message},
          );
          span.setStatus(StatusCode.error, failure.message);
          _telemetry.recordEvent('auth.google.failure', {
            'reason': failure.message,
          });
          emit(
            state.copyWith(
              status: AuthStatus.error,
              errorMessage: failure.message,
            ),
          );
        },
        (response) {
          _logger.info(
            'Connexion Google réussie',
            component: 'AuthBloc',
            metadata: {'user_id': response.user.id},
          );
          span.setAttribute(Attribute.fromString('user.id', response.user.id));
          _telemetry.recordEvent('auth.google.success', {
            'user.id': response.user.id,
          });
          _authRepository.updateDeviceInfo();
          _authRepository.logConnection();
          _notifyAuthSuccess(response, method: 'google');
          emit(
            state.copyWith(
              status: AuthStatus.authenticated,
              authResponse: response,
            ),
          );
        },
      );
    } catch (e, s) {
      _logger.error(
        'Erreur technique lors de la connexion Google',
        error: e,
        component: 'AuthBloc',
      );
      span.recordException(e, stackTrace: s);
      rethrow;
    } finally {
      span.end();
    }
  }

  Future<void> _onAuthAppleSignInRequested(
    AuthAppleSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    _logger.info('Tentative de connexion Apple...', component: 'AuthBloc');
    final span = _telemetry.tracer.startSpan('Auth: AppleSignIn');
    try {
      emit(state.copyWith(status: AuthStatus.loading));
      final result = await _authRepository.signInWithApple(
        countryCode: event.countryCode,
      );
      result.fold(
        (failure) {
          _logger.warning(
            'Échec de la connexion Apple',
            component: 'AuthBloc',
            metadata: {'error': failure.message},
          );
          span.setStatus(StatusCode.error, failure.message);
          _telemetry.recordEvent('auth.apple.failure', {
            'reason': failure.message,
          });
          emit(
            state.copyWith(
              status: AuthStatus.error,
              errorMessage: failure.message,
            ),
          );
        },
        (response) {
          _logger.info(
            'Connexion Apple réussie',
            component: 'AuthBloc',
            metadata: {'user_id': response.user.id},
          );
          span.setAttribute(Attribute.fromString('user.id', response.user.id));
          _telemetry.recordEvent('auth.apple.success', {
            'user.id': response.user.id,
          });
          _authRepository.updateDeviceInfo();
          _authRepository.logConnection();
          _notifyAuthSuccess(response, method: 'apple');
          emit(
            state.copyWith(
              status: AuthStatus.authenticated,
              authResponse: response,
            ),
          );
        },
      );
    } catch (e, s) {
      _logger.error(
        'Erreur technique lors de la connexion Apple',
        error: e,
        component: 'AuthBloc',
      );
      span.recordException(e, stackTrace: s);
      rethrow;
    } finally {
      span.end();
    }
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    _logger.info(
      'Vérification de l\'état d\'authentification...',
      component: 'AuthBloc',
    );
    emit(state.copyWith(status: AuthStatus.loading));
    final isAuthenticated = await _authRepository.isAuthenticated();

    if (isAuthenticated) {
      _logger.info(
        'Utilisateur authentifié en cache, récupération des données...',
        component: 'AuthBloc',
      );
      final userResult = await _authRepository.getCurrentUser();

      final String? accessToken = await _authRepository.getAccessToken();
      final String? refreshToken = await _authRepository.getRefreshToken();

      await userResult.fold(
        (failure) async {
          _logger.warning(
            'Échec de la récupération des données utilisateur localement',
            component: 'AuthBloc',
            metadata: {'error': failure.message},
          );
          emit(state.copyWith(status: AuthStatus.unauthenticated));
        },
        (user) async {
          _logger.info(
            'Session récupérée pour l\'utilisateur: ${user.email}',
            component: 'AuthBloc',
          );

          // Vérification sécurité: L'email est-il vérifié pour une connexion classique ?
          final loginProvider = await _authRepository.getLoginProvider();
          if (loginProvider == 'password' && !user.isEmailVerified) {
            _logger.warning(
              'Session trouvée mais email non vérifié.',
              component: 'AuthBloc',
            );
            // Optionally clear tokens or push to a 'pending verification' state
            // For now, we remain unauthenticated to force them to login and see the pending screen again
            emit(state.copyWith(status: AuthStatus.unauthenticated));
            return;
          }

          _authRepository.updateDeviceInfo(); // Fire and forget
          _authRepository.logConnection();
          _logger.setUserId(user.id);
          _analytics.setUserId(user.id);
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
      _logger.info('Aucune session active trouvée.', component: 'AuthBloc');
      emit(state.copyWith(status: AuthStatus.unauthenticated));
    }
  }

  Future<void> _onAuthLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    final span = _telemetry.tracer.startSpan(
      'Auth: Login',
      kind: SpanKind.internal,
    );

    try {
      emit(state.copyWith(status: AuthStatus.loading));
      final result = await _authRepository.login(
        LoginRequest(email: event.email, password: event.password),
      );
      result.fold<void>(
        (failure) {
          span.setStatus(StatusCode.error, failure.message);
          _telemetry.recordEvent('auth.login.failure', {
            'reason': failure.message,
          });
          _logger.warning(
            'Échec de connexion email/mot de passe',
            component: 'AuthBloc',
            metadata: {'error': failure.message},
          );
          emit(
            state.copyWith(
              status: AuthStatus.error,
              errorMessage: failure.message,
            ),
          );
        },
        (response) {
          span.setAttribute(Attribute.fromString('user.id', response.user.id));
          _telemetry.recordEvent('auth.login.success', {
            'user.id': response.user.id,
          });
          _logger.info(
            'Connexion réussie',
            component: 'AuthBloc',
            metadata: {'user_id': response.user.id},
          );
          _authRepository.updateDeviceInfo();
          _authRepository.logConnection();
          _notifyAuthSuccess(response, method: 'password');
          emit(
            state.copyWith(
              status: AuthStatus.authenticated,
              authResponse: response,
            ),
          );
        },
      );
    } catch (e, s) {
      span.recordException(e, stackTrace: s);
      span.setStatus(StatusCode.error, e.toString());
      rethrow;
    } finally {
      span.end();
    }
  }

  Future<void> _onAuthRegisterRequested(
    AuthRegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    final span = _telemetry.tracer.startSpan(
      'Auth: Register',
      kind: SpanKind.internal,
    );
    span.setAttribute(
      Attribute.fromString('user.country', event.country ?? 'unknown'),
    );

    try {
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
        (failure) {
          span.setAttribute(Attribute.fromString('auth.status', 'failure'));
          span.recordException(failure.message);
          _logger.error(
            'Échec de l\'inscription',
            component: 'AuthBloc',
            metadata: {'error': failure.message},
          );
          emit(
            state.copyWith(
              status: AuthStatus.error,
              errorMessage: failure.message,
            ),
          );
        },
        (response) {
          span.setAttribute(Attribute.fromString('auth.status', 'success'));
          span.setAttribute(Attribute.fromString('user.id', response.user.id));
          _logger.info(
            'Nouvelle inscription réussie',
            component: 'AuthBloc',
            metadata: {'user_id': response.user.id},
          );
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
    } catch (e, s) {
      span.recordException(e, stackTrace: s);
      span.setStatus(StatusCode.error, e.toString());
      rethrow;
    } finally {
      span.end();
    }
  }

  Future<void> _onAuthLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    final userId = state.authResponse?.user.id ?? 'unknown';
    _telemetry.recordEvent('auth.logout', {'user_id': userId});
    _analytics.logEvent(
      AnalyticsEvents.logout,
      parameters: {AnalyticsParams.reason: 'user_initiated'},
    );
    _analytics.setUserId(null);
    _logger.info(
      'Déconnexion de l\'utilisateur',
      component: 'AuthBloc',
      metadata: {'user_id': userId},
    );
    await _authRepository.logout();
    _logger.setUserId(null);
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
    _logger.info('Mise à jour du profil utilisateur...', component: 'AuthBloc');
    emit(state.copyWith(status: AuthStatus.loading));
    final result = await _authRepository.updateProfile(
      firstName: event.firstName,
      lastName: event.lastName,
      country: event.country,
      avatar: event.avatar,
      monthlyIncome: event.monthlyIncome,
      preferences: event.preferences,
    );
    result.fold(
      (failure) {
        _logger.error(
          'Échec de la mise à jour du profil',
          error: failure.message,
          component: 'AuthBloc',
        );
        emit(
          state.copyWith(
            status: AuthStatus.error,
            errorMessage: failure.message,
          ),
        );
      },
      (user) {
        _logger.info('Profil mis à jour avec succès.', component: 'AuthBloc');
        emit(
          state.copyWith(
            status: AuthStatus.authenticated,
            authResponse:
                state.authResponse?.copyWith(user: user) ??
                AuthResponse(
                  tokens: Tokens(accessToken: '', refreshToken: ''),
                  user: user,
                ),
          ),
        );
      },
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
    emit(state.copyWith(status: AuthStatus.loading));

    // Biometric unlock is always backed by a stored refresh token, never the
    // password — this works the same way regardless of login provider
    // (password, Google, Apple, phone).
    final token = await _authRepository.getBiometricToken();
    if (token != null) {
      final result = await _authRepository.refreshToken(token);
      result.fold(
        (failure) => emit(
          state.copyWith(
            status: AuthStatus.error,
            errorMessage: 'Session expired. Please login again.',
          ),
        ),
        (_) => add(AuthCheckRequested()),
      );
      return;
    }

    emit(
      state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'Biometric login not available. Please login normally.',
      ),
    );
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
      (failure) {
        _telemetry.recordEvent('auth.session.revoke_failure', {
          'session_id': event.sessionId,
          'reason': failure.message,
        });
        emit(
          state.copyWith(
            status: AuthStatus.error,
            errorMessage: failure.message,
          ),
        );
      },
      (_) {
        _telemetry.recordEvent('auth.session.revoke_success', {
          'session_id': event.sessionId,
        });
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

  Future<void> _onAuthSaveBiometricCredentialsRequested(
    AuthSaveBiometricCredentialsRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));

    // Verify the password before enabling biometrics, but never store it:
    // only the refresh token issued by this login is persisted, exactly
    // like the social/phone provider flow (_onAuthSetupBiometricsSocialRequested).
    final result = await _authRepository.login(
      LoginRequest(email: event.email, password: event.password),
    );

    await result.fold(
      (failure) async => emit(
        state.copyWith(status: AuthStatus.error, errorMessage: failure.message),
      ),
      (response) async {
        await _authRepository.saveBiometricToken(response.tokens.refreshToken);
        emit(state.copyWith(status: AuthStatus.biometricCredentialsSaved));
      },
    );
  }

  Future<void> _onAuthSetupBiometricsSocialRequested(
    AuthSetupBiometricsSocialRequested event,
    Emitter<AuthState> emit,
  ) async {
    final token = await _authRepository.getRefreshToken();
    if (token != null) {
      await _authRepository.saveBiometricToken(token);
      emit(state.copyWith(status: AuthStatus.biometricCredentialsSaved));
    } else {
      emit(
        state.copyWith(
          status: AuthStatus.error,
          errorMessage: 'Could not find a valid session to enable biometrics.',
        ),
      );
    }
  }

  void _onAuthAccountSuspended(
    AuthAccountSuspended event,
    Emitter<AuthState> emit,
  ) {
    _logger.warning('Compte suspendu détecté.', component: 'AuthBloc');
    emit(
      state.copyWith(
        status: AuthStatus.accountSuspended,
        errorMessage:
            'Votre compte a été suspendu par notre système de sécurité. Veuillez contacter le support.',
      ),
    );
  }

  Future<void> _onAuthSubmitKYCRequested(
    AuthSubmitKYCRequested event,
    Emitter<AuthState> emit,
  ) async {
    _logger.info('Début de la soumission KYC...', component: 'AuthBloc');
    emit(state.copyWith(status: AuthStatus.loading));

    try {
      // 1. Upload du document
      final docResult = await _uploadRepository.uploadDocument(
        event.docFilePath,
      );
      final docUrl = docResult.fold(
        (failure) => throw Exception(
          'Échec de l\'upload du document: ${failure.message}',
        ),
        (response) => response.finalUrl,
      );

      // 2. Upload du selfie
      final selfieResult = await _uploadRepository.uploadDocument(
        event.selfieFilePath,
      );
      final selfieUrl = selfieResult.fold(
        (failure) =>
            throw Exception('Échec de l\'upload du selfie: ${failure.message}'),
        (response) => response.finalUrl,
      );

      // 3. Soumission finale au backend Auth/Fintech
      final result = await _authRepository.submitKYC(
        fullName: event.fullName,
        documentType: event.documentType.toLowerCase().replaceAll(' ', '_'),
        documentNumber: event.documentNumber,
        documentImageUrl: docUrl,
        selfieImageUrl: selfieUrl,
      );

      result.fold(
        (failure) {
          _logger.warning(
            'Échec de la soumission KYC',
            component: 'AuthBloc',
            metadata: {'error': failure.message},
          );
          emit(
            state.copyWith(
              status: AuthStatus.error,
              errorMessage: failure.message,
            ),
          );
        },
        (_) {
          _logger.info('KYC soumis avec succès', component: 'AuthBloc');
          add(AuthRefreshUserRequested());
        },
      );
    } catch (e) {
      _logger.error(
        'Erreur lors du processus KYC',
        error: e,
        component: 'AuthBloc',
      );
      emit(
        state.copyWith(
          status: AuthStatus.error,
          errorMessage: ErrorMapper.safeMessage(e),
        ),
      );
    }
  }
}
