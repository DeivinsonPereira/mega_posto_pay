import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:megga_posto_mobile/utils/methods/payment/payment_features.dart';
import 'package:signature/signature.dart';

import '../../../../../../common/custom_cherry.dart';
import '../../../../../../utils/method_quantity_back.dart';

class LogicButtonSignature {
  final _paymentFeatures = PaymentFeatures();

  LogicButtonSignature._privateConstructor();

  static final LogicButtonSignature instance =
      LogicButtonSignature._privateConstructor();

  void backButton() {
    _paymentFeatures.removeSignature();
    Get.back();
  }

  Future<void> continueButton(
      BuildContext context, SignatureController signatureController) async {
    // TODO fazer a logica, se foi pago tudo, volta para a home, se não, volta para o pagamento
    Uint8List? _signature = await signatureController.toPngBytes();

    if (_signature == null) {
      const CustomCherryError(message: 'Erro ao gerar assinatura')
          .show(context);
      return;
    }
    _paymentFeatures.setSignature(_signature);
    print('assinatura: $_signature');
    QuantityBack.back(2);
  }
}
