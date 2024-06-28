import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class GravaValePostModel {
  int pdv_id;
  int caixa_id;
  int atendente_id;
  String nome_atendente;
  String historico;
  double valor;
  int idconta_pista;
  int idconta_salario;
  String replicate_caixa_id;
  int documento_id;
  GravaValePostModel({
    required this.pdv_id,
    required this.caixa_id,
    required this.atendente_id,
    required this.nome_atendente,
    required this.historico,
    required this.valor,
    required this.idconta_pista,
    required this.idconta_salario,
    required this.replicate_caixa_id,
    required this.documento_id,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'pdv_id': pdv_id,
      'caixa_id': caixa_id,
      'atendente_id': atendente_id,
      'nome_atendente': nome_atendente,
      'historico': historico,
      'valor': valor,
      'idconta_pista': idconta_pista,
      'idconta_salario': idconta_salario,
      'replicate_caixa_id': replicate_caixa_id,
      'documento_id': documento_id,
    };
  }

  factory GravaValePostModel.fromMap(Map<String, dynamic> map) {
    return GravaValePostModel(
      pdv_id: map['pdv_id'] as int,
      caixa_id: map['caixa_id'] as int,
      atendente_id: map['atendente_id'] as int,
      nome_atendente: map['nome_atendente'] as String,
      historico: map['historico'] as String,
      valor: map['valor'] is int? (map['valor'] as int).toDouble() : map['valor'] as double,
      idconta_pista: map['idconta_pista'] as int,
      idconta_salario: map['idconta_salario'] as int,
      replicate_caixa_id: map['replicate_caixa_id'] as String,
      documento_id: map['documento_id'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory GravaValePostModel.fromJson(String source) => GravaValePostModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
