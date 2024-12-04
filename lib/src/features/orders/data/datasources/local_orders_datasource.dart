import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/order_model.dart';

abstract class LocalOrdersDataSource {
  Future<List<OrderModel>> getOrders();
}

class LocalOrdersDataSourceImpl implements LocalOrdersDataSource {
  @override
  Future<List<OrderModel>> getOrders() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/orders.json');
      if (jsonString.isEmpty) {
        throw Exception('orders.json is empty');
      }
      
      final List<dynamic> jsonList = json.decode(jsonString);
      if (jsonList.isEmpty) {
        throw Exception('No orders found in orders.json');
      }
      
      return jsonList.map((json) {
        try {
          return OrderModel.fromJson(json);
        } catch (e) {
          print('Error parsing order: $json');
          print('Error details: $e');
          rethrow;
        }
      }).toList();
    } catch (e) {
      print('Error loading orders: $e');
      rethrow;
    }
  }
}
