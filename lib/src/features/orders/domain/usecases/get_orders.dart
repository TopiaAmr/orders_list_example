import '../entities/order.dart';
import '../repositories/orders_repository.dart';

class GetOrders {
  final OrdersRepository repository;

  GetOrders(this.repository);

  Future<List<Order>> call() async {
    return await repository.getOrders();
  }
}
