import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../bloc/orders_bloc.dart';
import '../bloc/orders_state.dart';
import '../bloc/orders_event.dart';
import '../widgets/orders_graph.dart';

class GraphScreen extends StatefulWidget {
  const GraphScreen({super.key});

  @override
  State<GraphScreen> createState() => _GraphScreenState();
}

class _GraphScreenState extends State<GraphScreen> {
  DateTime _startDate = DateTime(2021, 5, 1);
  DateTime _endDate = DateTime(2021, 5, 23);

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  void _loadOrders() {
    context.read<OrdersBloc>().add(LoadOrders(
      startDate: _startDate,
      endDate: _endDate,
    ));
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _startDate : _endDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
      _loadOrders();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrdersBloc, OrdersState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Orders Dashboard',
                style: TextStyle(fontWeight: FontWeight.bold)),
            elevation: 0,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildDateButton(
                        context,
                        'Start Date: ${DateFormat('MM/dd/yyyy').format(_startDate)}',
                        () => _selectDate(context, true),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildDateButton(
                        context,
                        'End Date: ${DateFormat('MM/dd/yyyy').format(_endDate)}',
                        () => _selectDate(context, false),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildContent(context, state),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDateButton(BuildContext context, String text, VoidCallback onPressed) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      child: Text(text, style: const TextStyle(fontSize: 14)),
    );
  }

  Widget _buildContent(BuildContext context, OrdersState state) {
    if (state is OrdersLoading) {
      return const Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Loading orders data...',
                  style: TextStyle(color: Colors.grey))
            ],
          ),
        ),
      );
    }

    if (state is OrdersLoaded) {
      return Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Orders Over Time',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Total Orders: ${state.orders.length}',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: OrdersGraph(
                spots: state.graphSpots,
                primaryColor: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
      );
    }

    if (state is OrdersError) {
      return Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline,
                  size: 48, color: Colors.redAccent),
              const SizedBox(height: 16),
              Text(
                'Error: ${state.message}',
                style: const TextStyle(color: Colors.redAccent),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  context.read<OrdersBloc>().add(LoadOrders(
                    startDate: _startDate,
                    endDate: _endDate,
                  ));
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return const SizedBox();
  }
}
