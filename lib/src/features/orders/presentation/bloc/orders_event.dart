import 'package:equatable/equatable.dart';

abstract class OrdersEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadOrders extends OrdersEvent {
  final DateTime? startDate;
  final DateTime? endDate;
  final String? status;

  LoadOrders({
    this.startDate,
    this.endDate,
    this.status,
  });

  @override
  List<Object?> get props => [startDate, endDate, status];
}
