import 'package:equatable/equatable.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../domain/entities/order.dart';

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
  final List<FlSpot> graphSpots;
  final int activeOrdersCount;

  OrdersLoaded({
    required this.orders,
    required this.averagePrice,
    required this.totalCount,
    required this.returnsCount,
    required this.graphSpots,
  }) : activeOrdersCount = orders.where((order) => order.isActive).length;

  @override
  List<Object> get props => [orders, averagePrice, totalCount, returnsCount, graphSpots, activeOrdersCount];
}

class OrdersError extends OrdersState {
  final String message;

  OrdersError(this.message);

  @override
  List<Object> get props => [message];
}
