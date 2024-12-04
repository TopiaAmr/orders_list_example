import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/order.dart';

class LatestOrdersList extends StatelessWidget {
  final List<Order> orders;
  final int limit;

  const LatestOrdersList({
    super.key,
    required this.orders,
    this.limit = 5,
  });

  @override
  Widget build(BuildContext context) {
    final displayOrders = orders.take(limit).toList();

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: displayOrders.length,
      itemBuilder: (context, index) {
        final order = displayOrders[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: order.isActive ? Colors.green : Colors.grey,
              child: const Icon(
                Icons.shopping_bag,
                color: Colors.white,
              ),
            ),
            title: Text(
              order.buyer,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              '${order.company} - ${order.price}',
              style: TextStyle(color: Colors.grey[600]),
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  DateFormat('MMM dd, yyyy').format(order.registered),
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: order.status == 'ORDERED' ? Colors.blue : Colors.orange,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    order.status,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
