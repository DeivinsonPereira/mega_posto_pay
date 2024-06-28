import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class ReturnSoldDocument {
  int caixa_id;
  int atendente_id;
  int documento_id;
  
  ReturnSoldDocument({
    required this.caixa_id,
    required this.atendente_id,
    required this.documento_id,
  });


  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'caixa_id': caixa_id,
      'atendente_id': atendente_id,
      'documento_id': documento_id,
    };
  }

  factory ReturnSoldDocument.fromMap(Map<String, dynamic> map) {
    return ReturnSoldDocument(
      caixa_id: map['caixa_id'] as int,
      atendente_id: map['atendente_id'] as int,
      documento_id: map['documento_id'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory ReturnSoldDocument.fromJson(String source) => ReturnSoldDocument.fromMap(json.decode(source) as Map<String, dynamic>);
}
