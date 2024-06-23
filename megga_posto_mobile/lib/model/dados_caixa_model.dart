import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class DadosCaixaModel {
  int caixaId;
  String replicateCaixaId;

  DadosCaixaModel({
    required this.caixaId,
    required this.replicateCaixaId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'caixaId': caixaId,
      'replicateCaixaId': replicateCaixaId,
    };
  }

  factory DadosCaixaModel.fromMap(Map<String, dynamic> map) {
    return DadosCaixaModel(
      caixaId: map['CAIXA_ID'] as int,
      replicateCaixaId: map['REPLICATE_CAIXA_ID'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory DadosCaixaModel.fromJson(String source) => DadosCaixaModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
