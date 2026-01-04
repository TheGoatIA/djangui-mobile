import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/route_constants.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../di/injection.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/auth_bloc.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _selectedCountry;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AuthBloc>(),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStatus.authenticated) {
            context.go(RouteConstants.dashboard);
          } else if (state.status == AuthStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.errorMessage ??
                      AppLocalizations.of(context)!.genericError,
                ),
              ),
            );
          }
        },
        child: Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => context.pop(),
                      padding: EdgeInsets.zero,
                      alignment: Alignment.centerLeft,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      AppLocalizations.of(context)!.createAccount,
                      style: AppTextStyles.headlineMedium.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      AppLocalizations.of(context)!.registerSubtitle,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 40),
                    Row(
                      children: [
                        Expanded(
                          child: AppTextField(
                            label: AppLocalizations.of(context)!.firstName,
                            hint: AppLocalizations.of(context)!.firstNameHint,
                            controller: _firstNameController,
                            validator: (value) => value?.isEmpty ?? true
                                ? AppLocalizations.of(context)!.requiredField
                                : null,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: AppTextField(
                            label: AppLocalizations.of(context)!.lastName,
                            hint: AppLocalizations.of(context)!.lastNameHint,
                            controller: _lastNameController,
                            validator: (value) => value?.isEmpty ?? true
                                ? AppLocalizations.of(context)!.requiredField
                                : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    AppTextField(
                      label: AppLocalizations.of(context)!.email,
                      hint: AppLocalizations.of(context)!.emailHint,
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: Icons.email_outlined,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppLocalizations.of(context)!.enterEmailError;
                        }
                        if (!value.contains('@')) {
                          return AppLocalizations.of(
                            context,
                          )!.invalidEmailError;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    const SizedBox(height: 24),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Country',
                        hintText: 'Select your country',
                        prefixIcon: const Icon(Icons.public),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'CM', child: Text('Cameroon')),
                        DropdownMenuItem(value: 'FR', child: Text('France')),
                        DropdownMenuItem(value: 'US', child: Text('USA')),
                        DropdownMenuItem(value: 'BE', child: Text('Belgium')),
                        DropdownMenuItem(value: 'CA', child: Text('Canada')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedCountry = value;
                        });
                      },
                      validator: (value) => value == null ? 'Please select a country' : null,
                    ),
                    const SizedBox(height: 32),
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        return AppButton(
                          text: AppLocalizations.of(context)!.register,
                          isLoading: state.status == AuthStatus.loading,
                          onPressed: () {
                            if (_formKey.currentState!.validate() && _selectedCountry != null) {
                              context.read<AuthBloc>().add(
                                AuthRegisterRequested(
                                  email: _emailController.text,
                                  password: _passwordController.text,
                                  firstName: _firstNameController.text,
                                  lastName: _lastNameController.text,
                                  country: _selectedCountry!,
                                ),
                              );
                            }
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppLocalizations.of(
                            context,
                          )!.alreadyHaveAccountQuestion,
                        ),
                        TextButton(
                          onPressed: () => context.pop(),
                          child: Text(
                            AppLocalizations.of(context)!.loginAction,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
