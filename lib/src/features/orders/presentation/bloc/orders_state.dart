import 'package:equatable/equatable.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../domain/entities/order.dart';

/// Base class for all order-related states.
/// 
/// This abstract class serves as the foundation for all possible states
/// that the orders feature can be in. Each concrete state class represents
/// a specific condition of the orders data and UI.
abstract class OrdersState extends Equatable {
  const OrdersState();

  @override
  List<Object?> get props => [];
}

/// Initial state before any orders are loaded.
/// 
/// This state is used when the orders feature is first initialized
/// and no data has been requested yet.
class OrdersInitial extends OrdersState {}

/// State indicating orders are currently being loaded.
/// 
/// This state is active during asynchronous operations such as:
/// - Fetching orders from the data source
/// - Processing order data for display
/// - Calculating order metrics
class OrdersLoading extends OrdersState {}

/// State representing successfully loaded orders data.
/// 
/// This state contains all the processed data needed for the UI:
/// - List of filtered orders based on current criteria
/// - Complete list of all orders (unfiltered)
/// - Calculated metrics (average price, counts)
/// - Processed graph data points
class OrdersLoaded extends OrdersState {
  /// List of orders filtered by current criteria
  final List<Order> orders;
  
  /// Complete list of all orders (unfiltered)
  final List<Order> allOrders;
  
  /// Average price across filtered orders
  final double averagePrice;
  
  /// Total count of filtered orders
  final int totalCount;
  
  /// Count of returned orders in filtered set
  final int returnsCount;
  
  /// Data points for the orders graph
  final List<FlSpot> graphSpots;

  const OrdersLoaded({
    required this.orders,
    required this.allOrders,
    required this.averagePrice,
    required this.totalCount,
    required this.returnsCount,
    required this.graphSpots,
  });

  @override
  List<Object> get props => [
        orders,
        allOrders,
        averagePrice,
        totalCount,
        returnsCount,
        graphSpots,
      ];
}

/// State representing an error in loading or processing orders.
/// 
/// This state is used when:
/// - Network requests fail
/// - Data processing encounters an error
/// - Invalid data is received
class OrdersError extends OrdersState {
  /// Description of the error that occurred
  final String message;

  const OrdersError(this.message);

  @override
  List<Object> get props => [message];
}
