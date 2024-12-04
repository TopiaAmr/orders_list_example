import '../../domain/entities/order.dart';
import '../../domain/repositories/orders_repository.dart';
import '../datasources/local_orders_datasource.dart';

class OrdersRepositoryImpl implements OrdersRepository {
  final LocalOrdersDataSource dataSource;

  OrdersRepositoryImpl({required this.dataSource});

  @override
  Future<List<Order>> getOrders() async {
    return await dataSource.getOrders();
  }
}
