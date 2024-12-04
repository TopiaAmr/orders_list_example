import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/order.dart';

part 'order_model.g.dart';

@JsonSerializable()
class OrderModel extends Order {
  const OrderModel({
    required super.id,
    required super.isActive,
    required super.price,
    required super.company,
    required super.picture,
    required super.buyer,
    required super.tags,
    required super.status,
    required super.registered,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final price = double.parse(json['price'].toString().replaceAll(r'$', '').replaceAll(',', ''));
    final registered = DateTime.parse(json['registered']);

    return OrderModel(
      id: json['id'] as String,
      isActive: json['isActive'] as bool,
      price: price,
      company: json['company'] as String,
      picture: json['picture'] as String,
      buyer: json['buyer'] as String,
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      status: json['status'] as String,
      registered: registered,
    );
  }

  Map<String, dynamic> toJson() => _$OrderModelToJson(this);
}
