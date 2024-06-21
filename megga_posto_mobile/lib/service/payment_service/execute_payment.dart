import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:megga_posto_mobile/integracao/padrao/paypadrao_enums.dart';
import 'package:megga_posto_mobile/integracao/padrao/paypadrao_formapgto_model.dart';
import 'package:megga_posto_mobile/page/loading/loading_page.dart';
import 'package:megga_posto_mobile/utils/dependencies.dart';
import 'package:megga_posto_mobile/utils/singletons_instances.dart';

import '../../page/payment/components/dialog_confirm_payment/dialog_confirm_payment.dart';
import 'pix_payment.dart/pix_pdv/pix_pdv.dart';

class ExecutePayment {
  final _choosePayment = SingletonsInstances().choosePayment;
  final _paymentController = Dependencies.paymentController();
  final _payPadraoController = Dependencies.payPadraoController();
  final _configController = Dependencies.configController();

  // Faz a verificação das formas de pagamento e executa o pagamento
  Future<void> executePayment(
      BuildContext context, String paymentDoctoForm) async {
    if (_choosePayment.isPixPayment(paymentDoctoForm)) {
      await _execute(() async => _paymentPix());
    }

    if (_choosePayment.isCashPayment(paymentDoctoForm)) {
      Get.dialog(barrierDismissible: false, const DialogConfirmPayment());
    }

    if (_choosePayment.isCreditPayment(paymentDoctoForm) ||
        _choosePayment.isDebitPayment(paymentDoctoForm)) {
      /* String paymentTypeDescription =
          _choosePayment.chooseDescription(paymentDoctoForm);
      //TODO fazer a lógica, se for tef Sitef entra no dialog especifico dele.
      int paymentTefType = 1; //1 é sitef (apenas exemplo)

      if (TefPixType().isTefSitef(paymentTefType)) {
        //  Get.dialog(barrierDismissible: false, const DialogConfirmPayment());

        Get.dialog(
          barrierDismissible: false,
          SitefPaymentDialog(paymentType: paymentTypeDescription),
        );

        _payment.configureClisitef(context);
        int modalidade =
            _modalidade.chooseModalidadePayment(paymentTypeDescription);
        _payment.transaction(modalidade, _paymentController.enteredValue.value);
      }*/
      if ((_configController.isSmartPos()) &&
          ((paymentDoctoForm == 'CA') ||
              (paymentDoctoForm == 'CR') ||
              (paymentDoctoForm == 'PX'))) {
        //chamar os dados
        PayPadraoFormaPgtoModel forma = PayPadraoFormaPgtoModel();
        forma.funcao = (paymentDoctoForm == 'CA')
            ? PayPadraoPagtoType.debito
            : (paymentDoctoForm == 'CR')
                ? PayPadraoPagtoType.credito
                : PayPadraoPagtoType.pix;
        forma.valor = _paymentController.enteredValue.value;

        _payPadraoController.sendPayPagto(forma, func: (value) {});
      } else {
        Get.dialog(barrierDismissible: false, const DialogConfirmPayment());
      }
    }

    if (_choosePayment.isNota(paymentDoctoForm)) {
      //Logica aqui
    }
  }

  // Escolhe a forma de pagamento pix que deve ser executado
  Future<void> _paymentPix() async {
    PixPdv? pixPdv;

    int pagamento = 0; // mudar essa logica para o tipo de pix escolhido
    if (pagamento == 0) pixPdv = PixPdv();

    if (pixPdv == null) return;

    await pixPdv.payment();
  }

  // executa o pagamento
  Future<void> _execute(Future<void> Function() function) async {
    Get.dialog(const LoadingPage());
    await function();
  }
}
