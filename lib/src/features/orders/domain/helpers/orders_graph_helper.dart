import 'package:fl_chart/fl_chart.dart';
import '../entities/order.dart';

class OrdersGraphHelper {
  static List<FlSpot> createDataPoints(
    List<Order> orders, {
    required DateTime startDate,
    required DateTime endDate,
  }) {
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
}
