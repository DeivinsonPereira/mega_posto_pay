class PayPadraoRetornoModel {
  bool? isOk;
  int? code;
  double? valorpago;
  String? cliente;
  String? itk;
  String? atk;
  String? transacaoid;
  String? dataPagto;
  String? bandeira;
  String? provedor;
  String? authorizationCode;
  int? parcelas;
  String? cartaoNum;
  String? tipoPagamento;
  String? tipoFinanciamento;
  String? entryMode;
  String? msg;
  bool? isTrans;

  PayPadraoRetornoModel({
    this.isOk,
    this.code,
    this.valorpago,
    this.cliente,
    this.itk,
    this.atk,
    this.transacaoid,
    this.dataPagto,
    this.bandeira,
    this.provedor,
    this.authorizationCode,
    this.parcelas,
    this.cartaoNum,
    this.tipoPagamento,
    this.tipoFinanciamento,
    this.entryMode,
    this.msg,
    this.isTrans,
  });
}

class PayPadraoRetornoCancelModel {
  int? code;
  bool? aprovado;
  String? msg;
  bool? isTrans;
  String? transacao;
  String? provedor;
  String? bandeira;
  String? dataPagto;

  PayPadraoRetornoCancelModel({
    this.aprovado,
    this.code,
    this.msg,
    this.isTrans,
    this.transacao,
    this.provedor,
    this.dataPagto,
    this.bandeira,
  });
}
