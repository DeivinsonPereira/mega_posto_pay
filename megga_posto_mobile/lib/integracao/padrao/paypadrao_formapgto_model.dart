import 'package:megga_posto_mobile/integracao/padrao/paypadrao_enums.dart';


class PayPadraoFormaPgtoModel {
  PayPadraoPagtoType? funcao;
  String? method;
  double? valor;
  int? orderId;
  int? qtdeParcela;
  int? formaId;
  bool? isPospDV;

  PayPadraoFormaPgtoModel({
    this.funcao,
    this.method,
    this.valor,
    this.orderId,
    this.qtdeParcela,
    this.formaId,
    this.isPospDV
  });
}

class PayPadraoFormaCancelModel {
  int? idtransacao;
  double? valor;
  String? nsuTransacao;
  String? nsuTerminal;
  String? transacaoid;

  PayPadraoFormaCancelModel({
    this.idtransacao,
    this.valor,
    this.nsuTransacao,
    this.nsuTerminal,
    this.transacaoid,
  });
}
