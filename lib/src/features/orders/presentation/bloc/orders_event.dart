import 'package:equatable/equatable.dart';

abstract class OrdersEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadOrders extends OrdersEvent {
  final DateTime? startDate;
  final DateTime? endDate;

  LoadOrders({
    this.startDate,
    this.endDate,
  });

  @override
  List<Object?> get props => [startDate, endDate];
}
