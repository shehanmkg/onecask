import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';

import '../../data/collection_data_provider.dart';
import '../../data/collection_repository.dart';
import '../../data/distillery_data_provider.dart';
import '../../data/user_data_provider.dart';
import '../../data/local/database_helper.dart';
import '../../features/collection/bloc/collection_bloc.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  getIt.registerLazySingleton<Connectivity>(() => Connectivity());

  getIt.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());

  getIt.registerLazySingleton<CollectionDataProvider>(
    () => CollectionDataProvider(dbHelper: getIt<DatabaseHelper>()),
  );

  getIt.registerLazySingleton<UserDataProvider>(
    () => UserDataProvider(dbHelper: getIt<DatabaseHelper>()),
  );

  getIt.registerLazySingleton<DistilleryDataProvider>(
    () => DistilleryDataProvider(dbHelper: getIt<DatabaseHelper>()),
  );

  getIt.registerLazySingleton<CollectionRepository>(
    () => CollectionRepository(
      dataProvider: getIt<CollectionDataProvider>(),
      connectivity: getIt<Connectivity>(),
    ),
  );

  getIt.registerFactory<CollectionBloc>(
    () => CollectionBloc(
      collectionRepository: getIt<CollectionRepository>(),
    ),
  );
}
