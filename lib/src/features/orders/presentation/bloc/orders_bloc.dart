import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/order.dart';
import '../../domain/usecases/get_orders.dart';

// Events
abstract class OrdersEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadOrders extends OrdersEvent {}

// States
abstract class OrdersState extends Equatable {
  @override
  List<Object> get props => [];
}

class OrdersInitial extends OrdersState {}

class OrdersLoading extends OrdersState {}

class OrdersLoaded extends OrdersState {
  final List<Order> orders;
  final double averagePrice;
  final int totalCount;
  final int returnsCount;

  OrdersLoaded({
    required this.orders,
    required this.averagePrice,
    required this.totalCount,
    required this.returnsCount,
  });

  @override
  List<Object> get props => [orders, averagePrice, totalCount, returnsCount];
}

class OrdersError extends OrdersState {
  final String message;

  OrdersError(this.message);

  @override
  List<Object> get props => [message];
}

// BLoC
class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final GetOrders getOrders;

  OrdersBloc({required this.getOrders}) : super(OrdersInitial()) {
    on<LoadOrders>((event, emit) async {
      emit(OrdersLoading());
      try {
        final orders = await getOrders();
        final averagePrice = orders.fold<double>(0, (sum, order) => sum + order.price) / orders.length;
        final returnsCount = orders.where((order) => !order.isActive).length;

        emit(OrdersLoaded(
          orders: orders,
          averagePrice: averagePrice,
          totalCount: orders.length,
          returnsCount: returnsCount,
        ));
      } catch (e) {
        emit(OrdersError(e.toString()));
      }
    });
  }
}
