import 'dart:convert';
import 'package:megga_posto_mobile/integracao/cielo/model/cielopay_payment_model.dart';

class CieloPayCheckoutResponseSuccess {
  String? createdAt;
  String? id;
  List<Item>? items;
  String? notes;
  String? number;
  int? paidAmount;
  List<CieloPayPayment>? payments;
  int? pendingAmount;
  int? price;
  String? reference;
  String? status;
  String? type;
  String? updatedAt;

  CieloPayCheckoutResponseSuccess({
    this.createdAt,
    this.id,
    this.items,
    this.notes,
    this.number,
    this.paidAmount,
    this.payments,
    this.pendingAmount,
    this.price,
    this.reference,
    this.status,
    this.type,
    this.updatedAt,
  });

  factory CieloPayCheckoutResponseSuccess.fromJson(String str) =>
      CieloPayCheckoutResponseSuccess.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CieloPayCheckoutResponseSuccess.fromMap(Map<String, dynamic> json) =>
      CieloPayCheckoutResponseSuccess(
        createdAt: json["createdAt"],
        id: json["id"],
        items: json["items"] == null
            ? null
            : List<Item>.from(json["items"].map((x) => Item.fromMap(x))),
        notes: json["notes"],
        number: json["number"],
        paidAmount: json["paidAmount"],
        payments: json["payments"] == null
            ? null
            : List<CieloPayPayment>.from(
                json["payments"].map((x) => CieloPayPayment.fromMap(x))),
        pendingAmount:
            json["pendingAmount"],
        price: json["price"],
        reference: json["reference"],
        status: json["status"],
        type: json["type"],
        updatedAt: json["updatedAt"],
      );

  Map<String, dynamic> toMap() => {
        "createdAt": createdAt,
        "id": id,
        "items": items == null
            ? null
            : List<dynamic>.from(items!.map((x) => x.toMap())),
        "notes": notes,
        "number": number,
        "paidAmount": paidAmount,
        "payments": payments == null
            ? null
            : List<dynamic>.from(payments!.map((x) => x.toMap())),
        "pendingAmount": pendingAmount,
        "price": price,
        "reference": reference,
        "status": status,
        "type": type,
        "updatedAt": updatedAt,
      };
}

class Item {
  String? description;
  String? details;
  String? id;
  String? name;
  int? quantity;
  String? reference;
  String? sku;
  String? unitOfMeasure;
  int? unitPrice;

  Item({
    this.description,
    this.details,
    this.id,
    this.name,
    this.quantity,
    this.reference,
    this.sku,
    this.unitOfMeasure,
    this.unitPrice,
  });

  factory Item.fromJson(String str) => Item.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Item.fromMap(Map<String, dynamic> json) => Item(
        description: json["description"],
        details: json["details"],
        id: json["id"],
        name: json["name"],
        quantity: json["quantity"],
        reference: json["reference"],
        sku: json["sku"],
        unitOfMeasure:
            json["unitOfMeasure"],
        unitPrice: json["unitPrice"],
      );

  Map<String, dynamic> toMap() => {
        "description": description,
        "details": details,
        "id": id,
        "name": name,
        "quantity": quantity,
        "reference": reference,
        "sku": sku,
        "unitOfMeasure": unitOfMeasure,
        "unitPrice": unitPrice,
      };
}
