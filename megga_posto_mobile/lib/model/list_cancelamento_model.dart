import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class ListCancelamentoModel {
  int? idnf;
  String? emissao;
  String? nomeCliente;
  int? nfsIdcaixa;
  double? valor;
  int? noNfce;
  int? serie;
  int? status;
  String? xml;
  ListCancelamentoModel({
    this.idnf,
    this.emissao,
    this.nomeCliente,
    this.nfsIdcaixa,
    this.valor,
    this.noNfce,
    this.serie,
    this.status,
    this.xml
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'idnf': idnf,
      'emissao': emissao,
      'nomeCliente': nomeCliente,
      'nfsIdcaixa': nfsIdcaixa,
      'valor': valor,
      'noNfce': noNfce,
      'serie': serie,
      'status': status,
      'xml': xml
    };
  }

  factory ListCancelamentoModel.fromMap(Map<String, dynamic> map) {
    return ListCancelamentoModel(
      idnf: map['IDNF'] != null ? map['IDNF'] as int : null,
      emissao: map['EMISSAO'] != null ? map['EMISSAO'] as String : null,
      nomeCliente:
          map['NOME_CLIENTE'] != null ? map['NOME_CLIENTE'] as String : null,
      nfsIdcaixa: map['NFS_IDCAIXA'] != null ? map['NFS_IDCAIXA'] as int : null,
      valor: map['VALOR'] != null
          ? map['VALOR'] is int
              ? (map['VALOR'] as int).toDouble()
              : map['VALOR'] as double
          : null,
      noNfce: map['NO_NFCE'] != null ? map['NO_NFCE'] as int : null,
      serie: map['SERIE'] != null ? map['SERIE'] as int : null,
      status: map['STATUS'] != null ? map['STATUS'] as int : null,
      xml: map['XML'] != null ? map['XML'] as String : null
    );
  }

  String toJson() => json.encode(toMap());

  factory ListCancelamentoModel.fromJson(String source) =>
      ListCancelamentoModel.fromMap(
          json.decode(source) as Map<String, dynamic>);
}
