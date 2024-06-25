import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:megga_posto_mobile/page/payment/enum/modalidade_payment.dart';
import 'package:megga_posto_mobile/utils/methods/payment/payment_features.dart';
import 'package:signature/signature.dart';

import '../../../../../../service/payment_service/logic_finish_payment.dart';

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
    Uint8List? _signature = await signatureController.toPngBytes();
    if (_signature != null) {
      _paymentFeatures.setSignature(_signature);
      print('assinatura: $_signature');
    }

    await LogicFinishPayment().confirmPayment(ModalidadePaymment.NOTA);
  }
}
