// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:chopper/chopper.dart' as _i31;
import 'package:djangui/core/database/database.dart' as _i730;
import 'package:djangui/core/network/network_info.dart' as _i574;
import 'package:djangui/di/register_module.dart' as _i153;
import 'package:djangui/features/auth/data/datasources/auth_api_service.dart'
    as _i651;
import 'package:djangui/features/auth/data/datasources/auth_local_datasource.dart'
    as _i520;
import 'package:djangui/features/auth/data/datasources/auth_remote_datasource.dart'
    as _i1046;
import 'package:djangui/features/auth/data/repositories/auth_repository_impl.dart'
    as _i29;
import 'package:djangui/features/auth/domain/repositories/auth_repository.dart'
    as _i1012;
import 'package:djangui/features/auth/presentation/bloc/auth_bloc.dart' as _i48;
import 'package:djangui/features/transactions/data/datasources/transaction_api_service.dart'
    as _i70;
import 'package:djangui/features/transactions/data/datasources/transaction_local_datasource.dart'
    as _i1040;
import 'package:djangui/features/transactions/data/datasources/transaction_remote_datasource.dart'
    as _i231;
import 'package:djangui/features/transactions/data/repositories/transaction_repository_impl.dart'
    as _i406;
import 'package:djangui/features/transactions/domain/repositories/transaction_repository.dart'
    as _i461;
import 'package:djangui/features/transactions/presentation/bloc/transactions_bloc.dart'
    as _i492;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => registerModule.prefs,
      preResolve: true,
    );
    gh.lazySingleton<_i558.FlutterSecureStorage>(
        () => registerModule.secureStorage);
    gh.lazySingleton<_i31.ChopperClient>(() => registerModule.chopperClient);
    gh.lazySingleton<_i651.AuthApiService>(() => registerModule.authApiService);
    gh.lazySingleton<_i70.TransactionApiService>(
        () => registerModule.transactionApiService);
    gh.lazySingleton<_i730.AppDatabase>(() => registerModule.database);
    gh.lazySingleton<_i574.NetworkInfo>(() => _i574.NetworkInfoImpl());
    gh.lazySingleton<_i1046.AuthRemoteDataSource>(
        () => _i1046.AuthRemoteDataSourceImpl(gh<_i651.AuthApiService>()));
    gh.lazySingleton<_i1040.TransactionLocalDataSource>(
        () => _i1040.TransactionLocalDataSourceImpl(gh<_i730.AppDatabase>()));
    gh.lazySingleton<_i231.TransactionRemoteDataSource>(() =>
        _i231.TransactionRemoteDataSourceImpl(
            gh<_i70.TransactionApiService>()));
    gh.lazySingleton<_i461.TransactionRepository>(
        () => _i406.TransactionRepositoryImpl(
              gh<_i231.TransactionRemoteDataSource>(),
              gh<_i1040.TransactionLocalDataSource>(),
              gh<_i574.NetworkInfo>(),
            ));
    gh.lazySingleton<_i520.AuthLocalDataSource>(
        () => _i520.AuthLocalDataSourceImpl(gh<_i558.FlutterSecureStorage>()));
    gh.factory<_i492.TransactionsBloc>(
        () => _i492.TransactionsBloc(gh<_i461.TransactionRepository>()));
    gh.lazySingleton<_i1012.AuthRepository>(() => _i29.AuthRepositoryImpl(
          gh<_i1046.AuthRemoteDataSource>(),
          gh<_i520.AuthLocalDataSource>(),
          gh<_i574.NetworkInfo>(),
        ));
    gh.factory<_i48.AuthBloc>(() => _i48.AuthBloc(gh<_i1012.AuthRepository>()));
    return this;
  }
}

class _$RegisterModule extends _i153.RegisterModule {}
