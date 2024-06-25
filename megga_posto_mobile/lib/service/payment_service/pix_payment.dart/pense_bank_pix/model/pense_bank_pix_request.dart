import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class PenseBankPixRequest {
  String alias;
  double totalAmount;
  int expirationSeconds;
  String cnpjSh;
  
  PenseBankPixRequest({
    required this.alias ,
    required this.totalAmount,
    this.expirationSeconds = 300,
    this.cnpjSh = '04336126000192',
  });



  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'alias': alias,
      'totalAmount': totalAmount,
      'expirationSeconds': expirationSeconds,
      'cnpjSh': cnpjSh,
    };
  }

  factory PenseBankPixRequest.fromMap(Map<String, dynamic> map) {
    return PenseBankPixRequest(
      alias: map['alias'] as String,
      totalAmount: map['totalAmount'] as double,
      expirationSeconds: map['expirationSeconds'] as int,
      cnpjSh: map['cnpjSh'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory PenseBankPixRequest.fromJson(String source) => PenseBankPixRequest.fromMap(json.decode(source) as Map<String, dynamic>);
}
