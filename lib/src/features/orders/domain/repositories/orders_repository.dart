import 'package:orders_list_example/src/features/orders/domain/entities/order.dart';

abstract class OrdersRepository {
  Future<List<Order>> getOrders();
}
