import 'dart:convert';

class Docto {
  String descricao;
  int codigo;

  Docto({
    required this.descricao,
    required this.codigo,
  });

  @override
  bool operator ==(covariant Docto other) {
    if (identical(this, other)) return true;

    return other.descricao == descricao && other.codigo == codigo;
  }

  @override
  int get hashCode => descricao.hashCode ^ codigo.hashCode;
}

// ignore_for_file: public_member_api_docs, sort_constructors_first
class MovimentRegisterModel {
  int pdv_id;
  int caixa_id;
  int atendente_id;
  String nome_atendente;
  int documento_id;
  String historico;
  double valor;
  int idconta_caixa;
  int idconta_pista;
  int idconta_sangria;

  MovimentRegisterModel({
    required this.pdv_id,
    required this.caixa_id,
    required this.atendente_id,
    required this.nome_atendente,
    required this.documento_id,
    required this.historico,
    required this.valor,
    required this.idconta_caixa,
    required this.idconta_pista,
    required this.idconta_sangria,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'pdv_id': pdv_id,
      'caixa_id': caixa_id,
      'atendente_id': atendente_id,
      'nome_atendente': nome_atendente,
      'documento_id': documento_id,
      'historico': historico,
      'valor': valor,
      'idconta_caixa': idconta_caixa,
      'idconta_pista': idconta_pista,
      'idconta_sangria': idconta_sangria,
    };
  }

  factory MovimentRegisterModel.fromMap(Map<String, dynamic> map) {
    return MovimentRegisterModel(
      pdv_id: map['pdv_id'] as int,
      caixa_id: map['caixa_id'] as int,
      atendente_id: map['atendente_id'] as int,
      nome_atendente: map['nome_atendente'] as String,
      documento_id: map['documento_id'] as int,
      historico: map['historico'] as String,
      valor: map['valor'] as double,
      idconta_caixa: map['idconta_caixa'] as int,
      idconta_pista: map['idconta_pista'] as int,
      idconta_sangria: map['idconta_sangria'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory MovimentRegisterModel.fromJson(String source) =>
      MovimentRegisterModel.fromMap(
          json.decode(source) as Map<String, dynamic>);
}
