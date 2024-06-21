import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:megga_posto_mobile/controller/config_controller.dart';
import 'package:megga_posto_mobile/integracao/padrao/paypadrao_enums.dart';
import 'package:megga_posto_mobile/integracao/padrao/paypadrao_formapgto_model.dart';
import 'package:megga_posto_mobile/integracao/padrao/paypadrao_retorno_model.dart';
import 'package:megga_posto_mobile/model/payment_cartao_model.dart';
import 'package:megga_posto_mobile/service/payment_service/cash_payment.dart/logic_finish_payment.dart';
import 'package:megga_posto_mobile/utils/dependencies.dart';


class PayPadraoController extends GetxController {
  final ctlCieloPay = Dependencies.cieloPayController() ;
  final _configController = Dependencies.configController();

  Function(PayPadraoRetornoModel)? funRetorno;
  Function(bool value)? funRetornoCancel;

  PayPadraoFormaPgtoModel dadosPagto = PayPadraoFormaPgtoModel();
  PayPadraoFormaCancelModel dadosCancel = PayPadraoFormaCancelModel();

  @override
  void onClose() {}

  void retornoTransacao(Uri? retorno, String? retornoString) async {
    PayPadraoRetornoModel info = PayPadraoRetornoModel();
  
    if (_configController.tipoSmartPos() == PcnTipoSmartPos.tpPosCielo) {
      info = await ctlCieloPay.retornoCielo(retornoString ?? '');
    } 

    if (info.isTrans ?? false) { 
      if (info.isOk ?? false) { 
        String tipodoc='';
         if (dadosPagto.funcao == PayPadraoPagtoType.credito) {
          tipodoc='CR';
         } else if (dadosPagto.funcao == PayPadraoPagtoType.debito) {
          tipodoc='CA';
         } else if (dadosPagto.funcao == PayPadraoPagtoType.pix) {
          tipodoc='PX';
         }

         PaymentCartaoModel cartao = PaymentCartaoModel();        
         cartao.nsu =info.itk??''; 
         cartao.autorizacao =info.authorizationCode??''; 
         cartao.nomeBandeira =info.bandeira??''; 
         cartao.tipoCartao =tipodoc; 
        

         await LogicFinishPayment().confirmPayment('CT',dadosCartao: cartao);
      }
    }
   

    // if (info.isTrans ?? false) {
    //   if (info.isOk ?? false) {
    //     CartaoPay pay = CartaoPay();
    //     pay.identificadorTransacaoAutomacao = info.transacaoid;
    //     pay.codigoAutorizacao = info.authorizationCode;
    //     pay.dataHoraTransacao = info.dataPagto;
    //     pay.nomeCartao = info.cliente ?? '';
    //     pay.cartaoNum = info.cartaoNum ?? '';
    //     pay.nomeCartaoPadrao = info.cliente ?? '';
    //     pay.numeroParcelas = info.parcelas;
    //     pay.valor = (info.valorpago ?? 0);
    //     pay.valorTotal = pay.valor.toString();
    //     pay.nomeProvedor = info.provedor;
    //     pay.bandeira = info.bandeira;
    //     pay.nsuTerminal = info.itk;
    //     pay.nsuTransacao = info.atk;
    //     pay.tipoCartao = info.tipoPagamento;
    //     pay.mensagemResultado = info.msg;
    //     pay.idpedido = dadosPagto.orderId;
    //     pay.mensagemResultado = 'Aprovado';
    //     pay.formaId = dadosPagto.formaId;
    //     pay.pospdv = (dadosPagto.isPospDV ?? false) ? 'S' : 'N';

    //     await DbCartao().newPagto(pay);
    //     repPay.postTransacoes();
    //   }
    // }

    if (funRetorno != null) {
      funRetorno!(info);
    }
  }

  void retornoTransacaoCancel(Uri? retorno, String? retornoString) async {
    PayPadraoRetornoCancelModel info = PayPadraoRetornoCancelModel();

    if (_configController.tipoSmartPos() == PcnTipoSmartPos.tpPosCielo) {
      info = ctlCieloPay.retornoStoneCancel(retornoString ?? '');
    } 

    // if (info.isTrans ?? false) {
    //   if (info.aprovado ?? false) {
    //     if ((dadosCancel.idtransacao ?? 0) > 0) {
    //       await DbCartao().cancelarpagto(dadosCancel.idtransacao ?? 0);
    //     } else if ((info.transacao ?? '') != '') {
    //       await DbCartao().cancelarpagtoNsu(
    //           info.transacao ?? '', info.bandeira ?? '', info.provedor ?? '');
    //     }
    //   }

    //   if (funRetornoCancel != null) {
    //     funRetornoCancel!(info.aprovado ?? false);
    //   }
    // }
  }

  Future<void> sendPayCancel(PayPadraoFormaCancelModel dados,
      {Function(bool value)? func, bool cartDigital = false}) async {
    String message = "";
    dadosCancel = dados;
    funRetornoCancel = func;

    try {
      if (_configController.tipoSmartPos() == PcnTipoSmartPos.tpPosCielo) {
        ctlCieloPay.setRetornoPagto(retornoTransacaoCancel);

        ctlCieloPay.sendDeeplinkCancel(
          atk: dados.nsuTransacao ?? '',
          itk: dados.nsuTerminal ?? '',
          orderid: dados.transacaoid ?? '',
          valor: dados.valor ?? 0,
        );
      } 
    } on PlatformException catch (e) {
      message = "Erro ao enviar: ${e.message}.";
    }
    debugPrint(message);
  }

  Future<void> sendPayPagto(PayPadraoFormaPgtoModel dados,
      {Function(PayPadraoRetornoModel)? func}) async {
    String message = "";
    dadosPagto = dados;
    funRetorno = func;

    try {
      if (_configController.tipoSmartPos() == PcnTipoSmartPos.tpPosCielo) {
        ctlCieloPay.setRetornoPagto(retornoTransacao);

        ctlCieloPay.sendDeeplinkPagto(
          tipopgto: dados.funcao ?? PayPadraoPagtoType.credito,
          valor: dados.valor ?? 0,
          qtdeParcela: dados.qtdeParcela,
          orderId: '', //dados.orderId ??
        );
      } 


    } on PlatformException catch (e) {
      message = "Erro ao enviar: ${e.message}.";
    }
    debugPrint(message);
  }



  Future<void> printBmp(Uint8List img) async {
    if (_configController.tipoSmartPos() == PcnTipoSmartPos.tpPosCielo) {
      ctlCieloPay.printBmp(img);
    } 
  }
}
