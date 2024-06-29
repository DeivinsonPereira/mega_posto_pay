import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class ProdutoVendidoModel {
  int? codigo;
  String? nome;
  double? quantidade;
  double? total;
  
  ProdutoVendidoModel({
    this.codigo,
    this.nome,
    this.quantidade,
    this.total,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'codigo': codigo,
      'nome': nome,
      'quantidade': quantidade,
      'total': total,
    };
  }

  factory ProdutoVendidoModel.fromMap(Map<String, dynamic> map) {
    return ProdutoVendidoModel(
      codigo: map['CODIGO'] != null ? map['CODIGO'] as int : null,
      nome: map['NOME'] != null ? map['NOME'] as String : null,
      quantidade: map['QUANTIDADE'] != null ? map['QUANTIDADE']  is int ? ( map['QUANTIDADE'] as int).toDouble() : map['QUANTIDADE'] as double : null,
      total: map['TOTAL'] != null ? map['TOTAL'] is int ? ( map['TOTAL'] as int).toDouble() : map['TOTAL'] as double : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProdutoVendidoModel.fromJson(String source) => ProdutoVendidoModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
