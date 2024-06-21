import 'dart:convert';

import 'package:megga_posto_mobile/model/payment_cartao_model.dart';
import 'package:megga_posto_mobile/model/payment_pix_model.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class PaymentExecuted {
  int? formaPagamentoId;
  String? tipoDocto;
  int? numParcela;
  String? dataVencimento;
  double? valorParcela;
  double? valorIntegral;
  PaymentCartaoModel? dadosCartao;
  PaymentPixModel? dadosPix;

  PaymentExecuted({
    this.formaPagamentoId,
    this.tipoDocto,
    this.numParcela,
    this.dataVencimento,
    this.valorParcela,
    this.valorIntegral,
    this.dadosCartao,
    this.dadosPix,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'tipo_docto': tipoDocto,
      'numParcela': numParcela,
      'dataVencimento': dataVencimento,
      'valorParcela': valorParcela,
      'valorIntegral': valorIntegral,
      'dados_cartao': dadosCartao,
      'dados_pix': dadosPix,
    };
  }

  factory PaymentExecuted.fromMap(Map<String, dynamic> map) {
    return PaymentExecuted(
      formaPagamentoId: map['formaPagamentoId'] != null
          ? map['formaPagamentoId'] as int
          : null,
      tipoDocto: map['tipo_docto'] != null ? map['tipo_docto'] as String : '',
      numParcela: map['numParcela'] != null ? map['numParcela'] as int : null,
      dataVencimento: map['dataVencimento'] != null
          ? map['dataVencimento'] as String
          : null,
      valorParcela:
          map['valorParcela'] != null ? map['valorParcela'] as double : null,
      valorIntegral:
          map['valorIntegral'] != null ? map['valorIntegral'] as double : null,
      dadosCartao: map['dados_cartao'],
      dadosPix: map['dados_pix'],
    );
  }

  String toJson() => json.encode(toMap());

  factory PaymentExecuted.fromJson(String source) =>
      PaymentExecuted.fromMap(json.decode(source) as Map<String, dynamic>);
}
