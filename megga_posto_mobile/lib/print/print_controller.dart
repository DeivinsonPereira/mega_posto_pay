import 'dart:async';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:megga_posto_mobile/service/print/execute_print.dart';
import 'package:megga_posto_mobile/utils/dependencies.dart';
import 'package:megga_posto_mobile/utils/utilPdfBmp.dart';

import '../utils/methods/payment/payment_features.dart';

class PrintController extends GetxController {
  static const platformMethodChannel = MethodChannel("com.pagamento");

  final _configController = Dependencies.configController();
  final _paymentController = Dependencies.paymentController();
  final _paymentFeatures = PaymentFeatures();
  final _smartPrintController = Dependencies.smartGenericController();
  final _executePrint = ExecutePrint.instance;

  @override
  void onInit() {
    //

    super.onInit();
  }

  @override
  void onClose() {}

  Future<void> sendPrinterDFePDF(String base64PDF) async {
    // TODO ajustar para o tipo de maquina

    if (_configController.isSmartPos()) {
      Uint8List? bytes = await UtilPDF.converterPDFparaBMP(base64PDF);
      if (bytes != null) {
        _executePrint.printNfceImage(bytes, 130);

        if (_paymentController.assignaturePng.isNotEmpty &&
            _paymentController.assignaturePng != Uint8List(0)) {
          {
            _executePrint.printSignatureImage(
                _paymentController.assignaturePng, 65);
          }
        }
        // await _smartPrintController.printBMP(bytes);
      }
    }
  }

  Future<Uint8List> getTarja(String valor, int size) async {
    final Uint8List imageBytes = await platformMethodChannel.invokeMethod(
        'print_tarja_retorno', {"texto": valor, "align": "C", "size": size});
    return imageBytes;
  }
}
