// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/bms/cubit/bms_cubit.dart' as _i188;
import '../../features/bms/data/repositories/bms_bluetooth_repository.dart'
    as _i975;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.lazySingleton<_i975.BmsBluetoothRepository>(
      () => _i975.BmsBluetoothRepository(),
      dispose: (i) => i.dispose(),
    );
    gh.factory<_i188.BmsCubit>(
      () => _i188.BmsCubit(gh<_i975.BmsBluetoothRepository>()),
    );
    return this;
  }
}
