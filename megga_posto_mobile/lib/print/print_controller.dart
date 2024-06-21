import 'dart:async';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:megga_posto_mobile/utils/dependencies.dart';
import 'package:megga_posto_mobile/utils/utilPdfBmp.dart';

class PrintController extends GetxController {
  static const platformMethodChannel = MethodChannel("com.pagamento");

  final _configController = Dependencies.configController();
  final _smartPrintController = Dependencies.smartGenericController();

  @override
  void onInit() {
    //

    super.onInit();
  }

  @override
  void onClose() {}

  Future<void> sendPrinterDFePDF(String base64PDF) async {
    if (_configController.isSmartPos()) {
      Uint8List? bytes = await UtilPDF.converterPDFparaBMP(base64PDF);
      if (bytes != null) {
        await _smartPrintController.printBMP(bytes);
      }
    }
  }

  Future<Uint8List> getTarja(String valor, int size) async {
    final Uint8List imageBytes = await platformMethodChannel.invokeMethod(
        'print_tarja_retorno', {"texto": valor, "align": "C", "size": size});
    return imageBytes;
  }
}
