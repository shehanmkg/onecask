import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';

import '../../data/collection_data_provider.dart';
import '../../data/collection_repository.dart';
import '../../data/distillery_data_provider.dart';
import '../../data/user_data_provider.dart';
import '../../data/local/database_helper.dart';
import '../../features/collection/bloc/collection_bloc.dart';

final GetIt getIt = GetIt.instance;

// Setup service locator for dependency injection
Future<void> setupServiceLocator() async {
  // Register singletons

  // Core services
  getIt.registerLazySingleton<Connectivity>(() => Connectivity());

  // Database
  getIt.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());

  // Data providers
  getIt.registerLazySingleton<CollectionDataProvider>(
    () => CollectionDataProvider(dbHelper: getIt<DatabaseHelper>()),
  );

  getIt.registerLazySingleton<UserDataProvider>(
    () => UserDataProvider(dbHelper: getIt<DatabaseHelper>()),
  );

  getIt.registerLazySingleton<DistilleryDataProvider>(
    () => DistilleryDataProvider(dbHelper: getIt<DatabaseHelper>()),
  );

  // Repositories
  getIt.registerLazySingleton<CollectionRepository>(
    () => CollectionRepository(
      dataProvider: getIt<CollectionDataProvider>(),
      connectivity: getIt<Connectivity>(),
    ),
  );

  // Blocs
  getIt.registerFactory<CollectionBloc>(
    () => CollectionBloc(
      collectionRepository: getIt<CollectionRepository>(),
    ),
  );
}
