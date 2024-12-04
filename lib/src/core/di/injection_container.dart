import 'package:get_it/get_it.dart';
import '../../features/orders/data/datasources/local_orders_datasource.dart';
import '../../features/orders/data/repositories/orders_repository_impl.dart';
import '../../features/orders/domain/repositories/orders_repository.dart';
import '../../features/orders/domain/usecases/get_orders.dart';
import '../../features/orders/presentation/bloc/orders_bloc.dart';

final GetIt sl = GetIt.instance;

Future<void> init() async {
  await _initFeatures();
  await _initCore();
  await _initExternal();
}

Future<void> _initFeatures() async {
  // BLoCs
  sl.registerFactory(
    () => OrdersBloc(getOrders: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetOrders(sl()));

  // Repository
  sl.registerLazySingleton<OrdersRepository>(
    () => OrdersRepositoryImpl(dataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<LocalOrdersDataSource>(
    () => LocalOrdersDataSourceImpl(),
  );
}

Future<void> _initCore() async {
  // Add core dependencies here (e.g., network client, local storage)
}

Future<void> _initExternal() async {
  // Add external dependencies here (e.g., third-party services)
}
