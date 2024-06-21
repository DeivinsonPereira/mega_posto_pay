import 'dart:convert';

import 'package:megga_posto_mobile/model/payment_cartao_model.dart';
import 'package:megga_posto_mobile/model/payment_pix_model.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
class PaymentFormSelected {
  int forma_pagamento_id;
  String tipoDocto;
  int num_parcela;
  String data_vencimento;
  double valor_parcela;
  PaymentCartaoModel dadosCartao;
  PaymentPixModel dadosPix;

  PaymentFormSelected({
    required this.forma_pagamento_id,
    required this.tipoDocto,
    required this.num_parcela,
    required this.data_vencimento,
    required this.valor_parcela,
    required this.dadosCartao,
    required this.dadosPix ,
  });

  Map<String, dynamic> toMap() {
   
    return <String, dynamic>{
      // 'forma_pagamento_id': forma_pagamento_id,
      'tipo_docto': tipoDocto,
      'num_parcela': num_parcela,
      'data_vencimento': data_vencimento,
      'valor_parcela': valor_parcela,
      'dados_cartao': dadosCartao.toMapAsArray(),
      'dados_pix': dadosPix.toMapAsArray(),
    };
  }

  factory PaymentFormSelected.fromMap(Map<String, dynamic> map) {
    return PaymentFormSelected(
      forma_pagamento_id: map['forma_pagamento_id'] as int,
      tipoDocto: map['tipo_docto'] as String,
      num_parcela: map['num_parcela'] as int,
      data_vencimento: map['data_vencimento'] as String,
      valor_parcela: map['valor_parcela'] is int
          ? (map['valor_parcela'] as int).toDouble()
          : map['valor_parcela'] as double,
      dadosCartao: map['dados_cartao'] ?? PaymentCartaoModel(),
      dadosPix: map['dados_pix'] ??PaymentPixModel(),
    );
  }

  String toJson() => json.encode(toMap());

  factory PaymentFormSelected.fromJson(String source) =>
      PaymentFormSelected.fromMap(json.decode(source) as Map<String, dynamic>);
}
