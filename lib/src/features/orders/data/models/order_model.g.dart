// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderModel _$OrderModelFromJson(Map<String, dynamic> json) => $checkedCreate(
      'OrderModel',
      json,
      ($checkedConvert) {
        final val = OrderModel(
          id: $checkedConvert('id', (v) => v as String),
          isActive: $checkedConvert('isActive', (v) => v as bool),
          price: $checkedConvert('price', (v) => (v as num).toDouble()),
          company: $checkedConvert('company', (v) => v as String),
          picture: $checkedConvert('picture', (v) => v as String),
          buyer: $checkedConvert('buyer', (v) => v as String),
          tags: $checkedConvert('tags',
              (v) => (v as List<dynamic>).map((e) => e as String).toList()),
          status: $checkedConvert('status', (v) => v as String),
          registered:
              $checkedConvert('registered', (v) => DateTime.parse(v as String)),
        );
        return val;
      },
    );

Map<String, dynamic> _$OrderModelToJson(OrderModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'isActive': instance.isActive,
      'price': instance.price,
      'company': instance.company,
      'picture': instance.picture,
      'buyer': instance.buyer,
      'tags': instance.tags,
      'status': instance.status,
      'registered': instance.registered.toIso8601String(),
    };
