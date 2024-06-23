// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:megga_posto_mobile/model/product_and_quantity_model.dart';
import 'package:megga_posto_mobile/model/supply_pump_model.dart';

class CartShoppingModel {
  ProductAndQuantityModel? productAndQuantity;
  SupplyPump? supplyPump;

  CartShoppingModel({
    this.productAndQuantity,
    this.supplyPump,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'productAndQuantity': productAndQuantity?.toMap(),
      'supplyPump': supplyPump?.toMap(),
    };
  }

  factory CartShoppingModel.fromMap(Map<String, dynamic> map) {
    return CartShoppingModel(
      productAndQuantity: map['productAndQuantity'] != null ? ProductAndQuantityModel.fromMap(map['productAndQuantity'] as Map<String,dynamic>) : null,
      supplyPump: map['supplyPump'] != null ? SupplyPump.fromMap(map['supplyPump'] as Map<String,dynamic>) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CartShoppingModel.fromJson(String source) => CartShoppingModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
