import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:megga_posto_mobile/common/custom_cherry.dart';
import 'package:megga_posto_mobile/model/payment_cartao_model.dart';
import 'package:megga_posto_mobile/model/payment_pix_model.dart';
import 'package:megga_posto_mobile/page/loading/loading_page.dart';
import 'package:megga_posto_mobile/page/payment/enum/modalidade_payment.dart';
import 'package:megga_posto_mobile/service/execute_sell/execute_sell.dart';
import 'package:megga_posto_mobile/utils/dependencies.dart';
import 'package:megga_posto_mobile/utils/method_quantity_back.dart';
import 'package:megga_posto_mobile/utils/methods/payment/payment_features.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../../../utils/is_remaining_value.dart';
import '../../../utils/methods/bill/bill_features.dart';

class LogicFinishPayment {
  final _isRemainingValue = IsRemainingValue();
  final _paymentFeatures = PaymentFeatures();
  final _billFeatures = BillFeatures();
  final _printController = Dependencies.printController();
  // final _billController = Dependencies.billController();

  Future<void> confirmPayment(String modalidade,
      {PaymentCartaoModel? dadosCartao, PaymentPixModel? dadosPix}) async {
    _paymentFeatures.addSelectedPayment(modalidade,
        dadosCartao: dadosCartao, dadosPix: dadosPix);
    _paymentFeatures.clearEnteredValue();
    if (_isRemainingValue.isPaymentComplete()) {
      _handlePaymentComplete();
    }

    if (_isRemainingValue.isPaymentIncomplete()) {
      _handlePaymentIncomplete();
    }

    if (_isRemainingValue.isPaymentExceedingRemainingValue()) {
      _handlePaymentExceedingRemainingValue();
    }
  }

  Future<void> _handlePaymentComplete() async {
    Get.dialog(const LoadingPage());
    String xml = await ExecuteSell().executeSell();
    if (xml == '') {
      const CustomCherryError(message: 'Erro ao efetuar o pagamento.')
          .show(Get.context!);

      QuantityBack.back(2);
      return;
    }

    confirmaImpressao((isImprimir) async {
      if (isImprimir) {
        _printController.sendPrinterDFePDF(xml);
      }
      //  await PrintXml().printXml(xml); TODO descomentar essa linha
      const CustomCherrySuccess(message: 'Pagamento efetuado com sucesso!')
          .show(Get.context!);
        QuantityBack.back(6);
        _billFeatures.clearAll();
        _paymentFeatures.clearAll();
        return;
    });
  }

  Future<void> confirmaImpressao(Function(bool isImprimir) funRetorno) {
    return Alert(
      onWillPopActive: true,
      context: Get.context!,
      type: AlertType.warning,
      title: 'Atenção',
      desc: 'Deseja imprimir o cupom fiscal?',
      buttons: [
        DialogButton(
            color: Colors.red,
            child: const Text(
              "Ops, Não",
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
            onPressed: () async {
              Navigator.of(Get.context!).pop();
              funRetorno(false);
            }),
        DialogButton(
          color: Colors.green,
          onPressed: () async {
            Navigator.of(Get.context!).pop();
            funRetorno(true);
          },
          width: 130,
          child: const Text(
            "Sim, Imprimir",
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
        )
      ],
    ).show();
  }

  Future<void> _handlePaymentIncomplete() async {
    _paymentFeatures.addSelectedPayment(ModalidadePaymment.DINHEIRO);
    //TODO adicionar o pagamento à lista de pagamentos
    _paymentFeatures.clearEnteredValue();
    QuantityBack.back(2);
  }

  Future<void> _handlePaymentExceedingRemainingValue() async {
    _paymentFeatures.addSelectedPayment(ModalidadePaymment.DINHEIRO);
    //TODO adicionar o pagamento à lista de pagamentos
    //Posso criar um model para armazenar o troco e os pagamentos
    //Executar a venda
    QuantityBack.back(2);
  }

  void backPayment() {
    _paymentFeatures.clearEnteredValue();
    _paymentFeatures.clearAll();

    QuantityBack.back(2);
  }
}
