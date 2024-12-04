import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orders_list_example/src/features/orders/presentation/bloc/orders_state.dart';
import '../bloc/orders_bloc.dart';
import '../widgets/metric_card.dart';
import '../widgets/latest_orders_list.dart';

/// A screen that displays key metrics and performance indicators for orders.
/// 
/// This screen shows various metrics including:
/// - Total number of orders
/// - Average order price
/// - Number of returned orders
/// - Other relevant statistics
/// 
/// The metrics are displayed using MetricCard widgets arranged in a grid
/// layout. The screen automatically loads and updates data using the
/// OrdersBloc for state management.
class MetricsScreen extends StatelessWidget {
  const MetricsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Metrics & Latest Orders',
            style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
      body: BlocBuilder<OrdersBloc, OrdersState>(
        builder: (context, state) {
          if (state is OrdersLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is OrdersLoaded) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Key Metrics',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 1.5,
                      children: [
                        MetricCard(
                          title: 'Total Orders',
                          value: state.totalCount.toString(),
                          icon: Icons.shopping_cart,
                          color: Colors.blue,
                        ),
                        MetricCard(
                          title: 'Average Price',
                          value: '\$${state.averagePrice.toStringAsFixed(2)}',
                          icon: Icons.attach_money,
                          color: Colors.green,
                        ),
                        MetricCard(
                          title: 'Returns',
                          value: state.returnsCount.toString(),
                          icon: Icons.assignment_return,
                          color: Colors.orange,
                        ),
                        MetricCard(
                          title: 'Active Orders',
                          value: state.orders.where((order) => order.isActive).length.toString(),
                          icon: Icons.local_shipping,
                          color: Colors.purple,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Latest Orders',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    LatestOrdersList(orders: state.orders.take(5).toList()),
                  ],
                ),
              ),
            );
          } else if (state is OrdersError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const SizedBox();
        },
      ),
    );
  }
}
