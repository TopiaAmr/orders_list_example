import 'package:fl_chart/fl_chart.dart';
import '../entities/order.dart';

/// Helper class for processing order data into graph-friendly formats.
/// 
/// This class provides static utility methods for:
/// - Calculating order metrics (average price, returns count)
/// - Converting order data into graph points
/// - Aggregating orders by date
/// 
/// The methods are designed to be computationally efficient and are
/// typically run in isolates for better performance.
class OrdersGraphHelper {
  /// Creates a list of [FlSpot] points for displaying orders on a time-series graph.
  /// 
  /// Parameters:
  /// - [orders]: List of orders to process
  /// - [startDate]: Start date for the graph range
  /// - [endDate]: End date for the graph range
  /// 
  /// Returns a list of [FlSpot] where:
  /// - x: timestamp in milliseconds
  /// - y: number of orders for that day
  static List<FlSpot> createGraphPoints(
    List<Order> orders,
    DateTime startDate,
    DateTime endDate,
  ) {
    if (orders.isEmpty) return [];

    // Pre-calculate date bounds to avoid repeated calculations
    final startMillis = DateTime(startDate.year, startDate.month, startDate.day)
        .millisecondsSinceEpoch;
    final endMillis = DateTime(endDate.year, endDate.month, endDate.day)
        .add(const Duration(days: 1))
        .millisecondsSinceEpoch;

    // Create a fixed-size array for dates between start and end
    final int daysBetween = (endMillis - startMillis) ~/ Duration.millisecondsPerDay;
    final List<int> countsByIndex = List.filled(daysBetween + 1, 0);

    // Count orders for each day using a single pass through the orders
    for (final order in orders) {
      final orderMillis = order.registered.millisecondsSinceEpoch;
      if (orderMillis >= startMillis && orderMillis < endMillis) {
        final dayIndex = (orderMillis - startMillis) ~/ Duration.millisecondsPerDay;
        countsByIndex[dayIndex]++;
      }
    }

    // Create spots directly from the counts array
    return List.generate(countsByIndex.length, (index) {
      final timestamp = startMillis + (index * Duration.millisecondsPerDay);
      return FlSpot(timestamp.toDouble(), countsByIndex[index].toDouble());
    });
  }

  /// Calculates the average price of the given orders.
  /// 
  /// Returns 0 if the orders list is empty.
  /// The calculation handles the price as a double value.
  static double calculateAveragePrice(List<Order> orders) {
    if (orders.isEmpty) return 0;

    double totalPrice = 0;
    for (final order in orders) {
      totalPrice += order.price;
    }
    return totalPrice / orders.length;
  }

  /// Counts the number of returned (inactive) orders.
  /// 
  /// An order is considered returned if its [isActive] flag is false.
  static int calculateReturnsCount(List<Order> orders) {
    return orders.where((order) => !order.isActive).length;
  }
}
