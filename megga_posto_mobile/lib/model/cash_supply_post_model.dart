import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class CashSupplyPostModel {

  int caixa_id;
  int atendente_id;
  String nome_atendente;
  String historico;
  double valor;
  int idconta_caixa;
  int idconta_pista;

  CashSupplyPostModel({
    required this.caixa_id,
    required this.atendente_id,
    required this.nome_atendente,
    required this.historico,
    required this.valor,
    required this.idconta_caixa,
    required this.idconta_pista,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'caixa_id': caixa_id,
      'atendente_id': atendente_id,
      'nome_atendente': nome_atendente,
      'historico': historico,
      'valor': valor,
      'idconta_caixa': idconta_caixa,
      'idconta_pista': idconta_pista,
    };
  }

  factory CashSupplyPostModel.fromMap(Map<String, dynamic> map) {
    return CashSupplyPostModel(
      caixa_id: map['caixa_id'] as int,
      atendente_id: map['atendente_id'] as int,
      nome_atendente: map['nome_atendente'] as String,
      historico: map['historico'] as String,
      valor: map['valor'] is int ? (map ['valor'] as int).toDouble() : map['valor'] as double,
      idconta_caixa: map['idconta_caixa'] as int,
      idconta_pista: map['idconta_pista'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory CashSupplyPostModel.fromJson(String source) => CashSupplyPostModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
