import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:orders_list_example/src/features/orders/domain/entities/order.dart';
import '../bloc/orders_bloc.dart';

class GraphScreen extends StatelessWidget {
  const GraphScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrdersBloc, OrdersState>(
      builder: (context, state) {
        if (state is OrdersLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is OrdersLoaded) {
          final spots = _createDataPoints(state.orders);
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              height: 400,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: true),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) {
                          final date = DateTime.fromMillisecondsSinceEpoch(
                              value.toInt());
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            child: Text(
                              '${date.month}/${date.day}',
                              style: const TextStyle(fontSize: 10),
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            child: Text(value.toInt().toString()),
                          );
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      color: Colors.blue,
                      barWidth: 3,
                      dotData: const FlDotData(show: true),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else if (state is OrdersError) {
          return Center(child: Text('Error: ${state.message}'));
        }
        return const SizedBox();
      },
    );
  }

  List<FlSpot> _createDataPoints(List<Order> orders) {
    // Sort orders by date
    final sortedOrders = List<Order>.from(orders)
      ..sort((a, b) => a.registered.compareTo(b.registered));

    // Group orders by date
    final Map<DateTime, int> ordersByDate = {};
    for (var order in sortedOrders) {
      final date = DateTime(
        order.registered.year,
        order.registered.month,
        order.registered.day,
      );
      ordersByDate[date] = (ordersByDate[date] ?? 0) + 1;
    }

    // Create spots for the chart
    return ordersByDate.entries.map((entry) {
      return FlSpot(
        entry.key.millisecondsSinceEpoch.toDouble(),
        entry.value.toDouble(),
      );
    }).toList();
  }
}
