import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orders_list_example/src/features/orders/presentation/bloc/orders_bloc.dart';
import 'package:orders_list_example/src/features/orders/presentation/bloc/orders_event.dart';
import 'graph_screen.dart';
import 'metrics_screen.dart';

/// The main navigation screen of the orders feature.
/// 
/// This screen provides a bottom navigation bar that allows users to switch
/// between different views of the orders data:
/// - Metrics view showing key performance indicators
/// - Graph view displaying order trends over time
/// 
/// The screen maintains the selected tab state and handles navigation
/// between different views while preserving their state.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

/// State for the HomeScreen widget.
/// 
/// Manages:
/// - Current tab selection
/// - Navigation between different screens
class _HomeScreenState extends State<HomeScreen> {
  /// Index of the currently selected tab
  int _selectedIndex = 0;

  /// List of screens available for navigation
  final List<Widget> _screens = const [
    MetricsScreen(),
    GraphScreen(),
  ];

  /// Handles tab selection in the bottom navigation bar.
  /// Updates the current screen index and triggers a rebuild.
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    context.read<OrdersBloc>().add(LoadOrders());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Metrics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart),
            label: 'Graph',
          ),
        ],
      ),
    );
  }
}
