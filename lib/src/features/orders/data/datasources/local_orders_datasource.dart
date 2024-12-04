import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/order_model.dart';

abstract class LocalOrdersDataSource {
  Future<List<OrderModel>> getOrders();
}

class LocalOrdersDataSourceImpl implements LocalOrdersDataSource {
  @override
  Future<List<OrderModel>> getOrders() async {
    final String jsonString = await rootBundle.loadString('assets/orders.json');
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((json) => OrderModel.fromJson(json)).toList();
  }
}
