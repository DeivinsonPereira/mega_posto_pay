import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class ResumoFinanceiro {
  String? data;
  double? valor;
  ResumoFinanceiro({
    this.data,
    this.valor,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'data': data,
      'valor': valor,
    };
  }

  factory ResumoFinanceiro.fromMap(Map<String, dynamic> map) {
    return ResumoFinanceiro(
      data: map['data'] != null ? map['data'] as String : null,
      valor: map['valor'] != null ? map['valor'] is int ? (map['valor'] as int).toDouble() : map['valor'] as double : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ResumoFinanceiro.fromJson(String source) => ResumoFinanceiro.fromMap(json.decode(source) as Map<String, dynamic>);
}
