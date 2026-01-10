import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/countries.dart' as intl_countries;
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_button.dart';
import '../bloc/auth_bloc.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../features/system/presentation/bloc/system_bloc.dart';

class PhoneLoginPage extends StatefulWidget {
  const PhoneLoginPage({super.key});

  @override
  State<PhoneLoginPage> createState() => _PhoneLoginPageState();
}

class _PhoneLoginPageState extends State<PhoneLoginPage> {
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _completePhoneNumber = '';
  String _selectedCountryCode = 'CM';

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _onVerify() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
        AuthPhoneVerificationRequested(
          _completePhoneNumber,
          _selectedCountryCode,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.codeSent) {
          context.push(
            '/otp-verification',
            extra: {
              'phoneNumber': _completePhoneNumber,
              'countryCode': _selectedCountryCode,
              'verificationId': state.verificationId,
            },
          );
        } else if (state.status == AuthStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? l10n.genericError),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.phoneLogin),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.p24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l10n.enterPhone,
                    style: AppTextStyles.h2,
                    textAlign: TextAlign.center,
                  ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.2),
                  AppSpacing.gap32,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.phoneNumber,
                        style: AppTextStyles.labelLarge.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Removed duplicate static IntlPhoneField
                      BlocBuilder<SystemBloc, SystemState>(
                        builder: (context, systemState) {
                          // Filter the default list of countries using the codes from the API
                          // If API list is empty (e.g. loading or error), we show all or none.
                          // Here we show all if empty as a fallback, or better: show empty?
                          // Let's assume if loaded, we filter.

                          var filteredCountries = intl_countries.countries;

                          if (systemState.countries.isNotEmpty) {
                            final apiCountryCodes = systemState.countries
                                .map((c) => c.code)
                                .toSet();
                            filteredCountries = intl_countries.countries.where((
                              c,
                            ) {
                              return apiCountryCodes.contains(c.code);
                            }).toList();
                          }

                          return IntlPhoneField(
                            countries: filteredCountries,
                            controller: _phoneController,
                            initialCountryCode: 'CM',
                            languageCode: Localizations.localeOf(
                              context,
                            ).languageCode,
                            dropdownIconPosition: IconPosition.trailing,
                            dropdownDecoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            pickerDialogStyle: PickerDialogStyle(
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.surface,
                              countryCodeStyle: AppTextStyles.bodyMedium
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                              listTileDivider: const Divider(
                                height: 1,
                                thickness: 0.5,
                                color: Colors.transparent,
                              ),
                              countryNameStyle: AppTextStyles.bodyMedium,
                              searchFieldInputDecoration: InputDecoration(
                                hintText: l10n.selectCountry,
                                hintStyle: AppTextStyles.bodyMedium.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                ),
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                filled: true,
                                fillColor: Theme.of(
                                  context,
                                ).colorScheme.surfaceContainerHighest,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                    width: 1.5,
                                  ),
                                ),
                              ),
                              searchFieldCursorColor: Theme.of(
                                context,
                              ).colorScheme.primary,
                            ),
                            decoration: InputDecoration(
                              hintText: l10n.phoneHint,
                              counterText: '',
                              filled: true,
                              fillColor: Theme.of(
                                context,
                              ).colorScheme.surfaceContainerHighest,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Theme.of(context).colorScheme.primary,
                                  width: 1.5,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Theme.of(context).colorScheme.error,
                                  width: 1,
                                ),
                              ),
                            ),
                            style: AppTextStyles.bodyLarge,
                            onChanged: (phone) {
                              _completePhoneNumber = phone.completeNumber;
                            },
                            onCountryChanged: (country) {
                              setState(() {
                                _selectedCountryCode = country.code;
                              });
                            },
                          );
                        },
                      ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
                      AppSpacing.gap24,
                      BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, state) {
                          return AppButton(
                            text: l10n.verify,
                            onPressed: _onVerify,
                            isLoading: state.status == AuthStatus.loading,
                          );
                        },
                      ).animate().fadeIn(delay: 400.ms, duration: 400.ms),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
