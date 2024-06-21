import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Supply {
  int bicoId;
  String descricaoBico;
  int qtdeAbastecimentoBico;
  double totalBico;
  double valorUltimoAbastecimento;

  Supply({
    required this.bicoId,
    required this.descricaoBico,
    required this.qtdeAbastecimentoBico,
    required this.totalBico,
    required this.valorUltimoAbastecimento,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'bicoId': bicoId,
      'descricaoBico': descricaoBico,
      'qtdeAbastecimentoBico': qtdeAbastecimentoBico,
      'totalBico': totalBico,
      'valorUltimoAbastecimento': valorUltimoAbastecimento,
    };
  }

  factory Supply.fromMap(Map<String, dynamic> map) {
    return Supply(
      bicoId: map['BICO_ID'] as int,
      descricaoBico: map['DESCRICAO_BICO'] as String,
      qtdeAbastecimentoBico: map['QTD_ABAST_BICO'] as int,
      totalBico: map['TOTAL_BICO'] is int
          ? (map['TOTAL_BICO'] as int).toDouble()
          : map['TOTAL_BICO'] as double,
      valorUltimoAbastecimento: map['valor_ultimo_abastecimento'] is int
          ? (map['valor_ultimo_abastecimento'] as int).toDouble()
          : map['valor_ultimo_abastecimento'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory Supply.fromJson(String source) =>
      Supply.fromMap(json.decode(source) as Map<String, dynamic>);
}
