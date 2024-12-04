import 'package:equatable/equatable.dart';

/// Base class for all order-related events.
/// 
/// This abstract class serves as the foundation for all events that can
/// be dispatched to the OrdersBloc. Each concrete event class represents
/// a specific action or request that can trigger state changes.
abstract class OrdersEvent extends Equatable {
  const OrdersEvent();

  @override
  List<Object?> get props => [];
}

/// Event to request loading or reloading of orders data.
/// 
/// This event can be used to:
/// - Initially load orders
/// - Refresh the current orders list
/// - Filter orders by date range or status
/// 
/// Optional parameters allow for:
/// - Date range filtering (startDate, endDate)
/// - Status filtering
class LoadOrders extends OrdersEvent {
  /// Start date for filtering orders (inclusive)
  final DateTime? startDate;
  
  /// End date for filtering orders (inclusive)
  final DateTime? endDate;
  
  /// Status to filter orders by (null means all statuses)
  final String? status;

  const LoadOrders({
    this.startDate,
    this.endDate,
    this.status,
  });

  @override
  List<Object?> get props => [startDate, endDate, status];
}
