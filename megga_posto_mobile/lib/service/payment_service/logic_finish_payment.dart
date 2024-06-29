import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:megga_posto_mobile/common/custom_cherry.dart';
import 'package:megga_posto_mobile/model/payment_cartao_model.dart';
import 'package:megga_posto_mobile/model/payment_pix_model.dart';
import 'package:megga_posto_mobile/page/loading/loading_page.dart';
import 'package:megga_posto_mobile/service/execute_sell/execute_sell.dart';
import 'package:megga_posto_mobile/utils/dependencies.dart';
import 'package:megga_posto_mobile/utils/method_quantity_back.dart';
import 'package:megga_posto_mobile/utils/methods/payment/payment_features.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../../utils/is_remaining_value.dart';
import '../../utils/methods/bill/bill_features.dart';
import '../update_supply_pump.dart';

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
    if (_isRemainingValue.isPaymentComplete()) {
      _handlePaymentComplete();
    }

    if (_isRemainingValue.isPaymentIncomplete()) {
      _handlePaymentIncomplete(modalidade);
    }

    if (_isRemainingValue.isPaymentExceedingRemainingValue()) {
      _handlePaymentExceedingRemainingValue(modalidade);
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
        _printController
            .sendPrinterDFePDF(xml)
            .then((element) => _paymentFeatures.clearAll());
      }

      const CustomCherrySuccess(message: 'Pagamento efetuado com sucesso!')
          .show(Get.context!);

      QuantityBack.back(8);
      UpdateSupplyPump().updateSupplyPump();
      _billFeatures.clearAll();
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

  Future<void> _handlePaymentIncomplete(String modalidade) async {
    _paymentFeatures.clearEnteredValue();
    QuantityBack.back(3);
  }

  Future<void> _handlePaymentExceedingRemainingValue(String modalidade) async {
    QuantityBack.back(3);
  }

  void backPayment() {
    _paymentFeatures.clearEnteredValue();
    QuantityBack.back(3);
  }
}
