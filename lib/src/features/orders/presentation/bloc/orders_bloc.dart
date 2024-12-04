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
        final allOrders = await getOrders();
        
        // Filter orders by status if specified
        final filteredOrders = event.status != null
            ? allOrders.where((order) => order.status == event.status).toList()
            : allOrders;

        // Use compute for heavy calculations
        final averagePrice = await compute(
          (List<dynamic> params) {
            final orders = params[0] as List<Order>;
            return OrdersGraphHelper.calculateAveragePrice(orders);
          },
          [filteredOrders],
        );

        final returnsCount = await compute(
          (List<dynamic> params) {
            final orders = params[0] as List<Order>;
            return OrdersGraphHelper.calculateReturnsCount(orders);
          },
          [filteredOrders],
        );

        // Create graph points in a separate isolate
        final graphSpots = await compute(
          (List<dynamic> params) {
            final orders = params[0] as List<Order>;
            final startDate = params[1] as DateTime;
            final endDate = params[2] as DateTime;
            return OrdersGraphHelper.createGraphPoints(
              orders,
              startDate,
              endDate,
            );
          },
          [
            filteredOrders,
            event.startDate ?? DateTime.now().subtract(const Duration(days: 30)),
            event.endDate ?? DateTime.now(),
          ],
        );

        emit(OrdersLoaded(
          orders: filteredOrders,
          allOrders: allOrders,
          averagePrice: averagePrice,
          totalCount: filteredOrders.length,
          returnsCount: returnsCount,
          graphSpots: graphSpots,
        ));
      } catch (e) {
        emit(OrdersError(e.toString()));
      }
    });
  }
}
