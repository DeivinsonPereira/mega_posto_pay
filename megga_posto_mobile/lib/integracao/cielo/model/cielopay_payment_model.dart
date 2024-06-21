import 'dart:convert';

import 'cielopay_payment_fields_model.dart';

class CieloPayPayment {
  String? accessKey;
  int? amount;
  String? applicationName;
  String? authCode;
  String? brand;
  String? cieloCode;
  String? description;
  int? discountedAmount;
  String? externalId;
  String? id;
  int? installments;
  String? mask;
  String? merchantCode;
  CieloPayPaymentFields? paymentFields;
  String? primaryCode;
  String? requestDate;
  String? secondaryCode;
  String? terminal;

  CieloPayPayment({
    this.accessKey,
    this.amount,
    this.applicationName,
    this.authCode,
    this.brand,
    this.cieloCode,
    this.description,
    this.discountedAmount,
    this.externalId,
    this.id,
    this.installments,
    this.mask,
    this.merchantCode,
    this.paymentFields,
    this.primaryCode,
    this.requestDate,
    this.secondaryCode,
    this.terminal,
  });

  factory CieloPayPayment.fromJson(String str) => CieloPayPayment.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CieloPayPayment.fromMap(Map<String, dynamic> json) => CieloPayPayment(
        accessKey: json["accessKey"],
        amount: json["amount"],
        applicationName: json["applicationName"],
        authCode: json["authCode"],
        brand: json["brand"],
        cieloCode: json["cieloCode"],
        description: json["description"],
        discountedAmount: json["discountedAmount"],
        externalId: json["externalId"],
        id: json["id"],
        installments: json["installments"],
        mask: json["mask"],
        merchantCode: json["merchantCode"],
        paymentFields: CieloPayPaymentFields.fromMap(json["paymentFields"]),
        primaryCode: json["primaryCode"],
        requestDate: json["requestDate"],
        secondaryCode: json["secondaryCode"],
        terminal: json["terminal"],
      );

  Map<String, dynamic> toMap() => {
        "accessKey": accessKey,
        "amount": amount,
        "applicationName": applicationName,
        "authCode": authCode,
        "brand": brand,
        "cieloCode": cieloCode,
        "description": description,
        "discountedAmount": discountedAmount,
        "externalId": externalId,
        "id": id,
        "installments": installments,
        "mask": mask,
        "merchantCode": merchantCode,
        "paymentFields": paymentFields?.toMap(),
        "primaryCode": primaryCode,
        "requestDate": requestDate,
        "secondaryCode": secondaryCode,
        "terminal": terminal,
      };

  String toBase64Encode() => covertToBase64();

  covertToBase64() {
    List<int> encodedText = utf8.encode(toJson());
    return base64.encode(encodedText);
  }
}
