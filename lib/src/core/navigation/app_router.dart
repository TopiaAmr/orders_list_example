import 'package:flutter/material.dart';
import 'package:orders_list_example/src/features/orders/presentation/screens/graph_screen.dart';
import 'package:orders_list_example/src/features/orders/presentation/screens/metrics_screen.dart';
import '../../features/orders/presentation/screens/home_screen.dart';

class AppRouter {
  static const String home = '/';
  static const String metrics = '/metrics';
  static const String graph = '/graph';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        );
      case metrics:
        return MaterialPageRoute(
          builder: (_) => const MetricsScreen(),
        );
      case graph:
        return MaterialPageRoute(
          builder: (_) => const GraphScreen(),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        );
    }
  }
}
