import 'package:flutter/material.dart';
import '../../../../core/navigation/app_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders Dashboard'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () => Navigator.pushNamed(context, AppRouter.metrics),
              icon: const Icon(Icons.analytics),
              label: const Text('View Metrics'),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => Navigator.pushNamed(context, AppRouter.graph),
              icon: const Icon(Icons.show_chart),
              label: const Text('View Graph'),
            ),
          ],
        ),
      ),
    );
  }
}
