import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:orders_list_example/src/features/orders/domain/entities/order.dart';
import '../../domain/usecases/get_orders.dart';
import '../../domain/helpers/orders_graph_helper.dart';
import 'orders_event.dart';
import 'orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final GetOrders getOrders;

  OrdersBloc({required this.getOrders}) : super(OrdersInitial()) {
    on<LoadOrders>((event, emit) async {
      emit(OrdersLoading());
      try {
        final orders = await getOrders();
        
        // Use compute for heavy calculations
        final averagePrice = await compute(
          (List<dynamic> params) {
            final orders = params[0] as List<Order>;
            return orders.fold<double>(0, (sum, order) => sum + order.price) / orders.length;
          },
          [orders],
        );

        final returnsCount = await compute(
          (List<dynamic> params) {
            final orders = params[0] as List<Order>;
            return orders.where((order) => !order.isActive).length;
          },
          [orders],
        );

        // Create graph points in a separate isolate
        final graphSpots = await compute(
          (List<dynamic> params) {
            final orders = params[0] as List<Order>;
            final startDate = params[1] as DateTime;
            final endDate = params[2] as DateTime;
            return OrdersGraphHelper.createDataPoints(
              orders,
              startDate: startDate,
              endDate: endDate,
            );
          },
          [
            orders,
            event.startDate ?? DateTime.now().subtract(const Duration(days: 30)),
            event.endDate ?? DateTime.now(),
          ],
        );

        emit(OrdersLoaded(
          orders: orders,
          averagePrice: averagePrice,
          totalCount: orders.length,
          returnsCount: returnsCount,
          graphSpots: graphSpots,
        ));
      } catch (e) {
        emit(OrdersError(e.toString()));
      }
    });
  }
}
