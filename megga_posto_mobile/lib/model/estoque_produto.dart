import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class EstoqueProduto {
  int idProduto;
  String nomeProduto;
  double estoqueQuantidadeFisico;
  
  EstoqueProduto({
    required this.idProduto,
    required this.nomeProduto,
    required this.estoqueQuantidadeFisico,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'idProduto': idProduto,
      'nomeProduto': nomeProduto,
      'estoqueQuantidadeFisico': estoqueQuantidadeFisico,
    };
  }

  factory EstoqueProduto.fromMap(Map<String, dynamic> map) {
    return EstoqueProduto(
      idProduto: map['PRO_IDPRODUTO'] as int,
      nomeProduto: map['PRO_NOME'] as String,
      estoqueQuantidadeFisico: map['EST_QTDEFISICO'] is int ? (map['EST_QTDEFISICO'] as int).toDouble() : map['EST_QTDEFISICO'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory EstoqueProduto.fromJson(String source) => EstoqueProduto.fromMap(json.decode(source) as Map<String, dynamic>);
}
