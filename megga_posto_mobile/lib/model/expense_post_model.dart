import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class ExpensePostModel {
  int caixa_id;
  int atendente_id;
  int conta_id;
  int idconta_pista;
  String historico;
  double valor;
  int documento_id;
  ExpensePostModel({
    required this.caixa_id,
    required this.atendente_id,
    required this.conta_id,
    required this.idconta_pista,
    required this.historico,
    required this.valor,
    required this.documento_id,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'caixa_id': caixa_id,
      'atendente_id': atendente_id,
      'conta_id': conta_id,
      'idconta_pista': idconta_pista,
      'historico': historico,
      'valor': valor,
      'documento_id': documento_id,
    };
  }

  factory ExpensePostModel.fromMap(Map<String, dynamic> map) {
    return ExpensePostModel(
      caixa_id: map['caixa_id'] as int,
      atendente_id: map['atendente_id'] as int,
      conta_id: map['conta_id'] as int,
      idconta_pista: map['idconta_pista'] as int,
      historico: map['historico'] as String,
      valor: map['valor'] is int ? (map['valor'] as int).toDouble() : map['valor'] as double,
      documento_id: map['documento_id'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory ExpensePostModel.fromJson(String source) => ExpensePostModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
