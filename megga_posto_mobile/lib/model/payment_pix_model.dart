import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
class PaymentPixModel {
  String retornopix = '';

  PaymentPixModel({this.retornopix = ''});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'retornopix': retornopix,
    };
  }

  List<Map<String, dynamic>> toMapAsArray() {
    if (retornopix==''){
      return [];
    }
    return [
      {'retornopix': retornopix}, 
    ];
  }

  factory PaymentPixModel.fromMap(Map<String, dynamic> map) {
    return PaymentPixModel(
      retornopix: map['retornopix'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory PaymentPixModel.fromJson(String source) =>
      PaymentPixModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
