import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
class PaymentCartaoModel {
  String nomeBandeira = '';
  String tipoCartao = '';
  String autorizacao = '';
  String lote = '';
  String nsu = '';

  PaymentCartaoModel({
    this.nomeBandeira = '',
    this.tipoCartao = '',
    this.autorizacao = '',
    this.lote = '',
    this.nsu = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'nome_bandeira': nomeBandeira,
      'tipo_cartao': tipoCartao,
      'autorizacao': autorizacao,
      'lote': lote,
      'nsu': nsu,
    };
  }

  List<Map<String, dynamic>> toMapAsArray() {
    if (nomeBandeira==''){
      return [];
    }
    return [
      {'nome_bandeira': nomeBandeira,
      'tipo_cartao': tipoCartao,
      'autorizacao': autorizacao,
      'lote': lote,
      'nsu': nsu},
    ];
  }

  factory PaymentCartaoModel.fromMap(Map<String, dynamic> map) {
    return PaymentCartaoModel(
      nomeBandeira: map['nome_bandeira'] ?? '',
      tipoCartao: map['tipo_cartao'] ?? '',
      autorizacao: map['autorizacao'] ?? '',
      lote: map['lote'] ?? '',
      nsu: map['nsu'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory PaymentCartaoModel.fromJson(String source) =>
      PaymentCartaoModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
