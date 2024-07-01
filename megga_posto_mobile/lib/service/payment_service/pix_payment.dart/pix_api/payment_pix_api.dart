import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:megga_posto_mobile/common/custom_cherry.dart';
import 'package:megga_posto_mobile/page/payment/pages/pense_bank_dialog.dart';
import 'package:megga_posto_mobile/service/payment_service/pix_payment.dart/pix_api/pix_api.dart';
import 'package:megga_posto_mobile/utils/auth.dart';
import 'package:megga_posto_mobile/utils/dependencies.dart';
import 'package:megga_posto_mobile/utils/endpoints.dart';
import 'package:megga_posto_mobile/utils/singletons_instances.dart';

class PaymentPixApi {
  final _configController = Dependencies.configController();
  final _paymentController = Dependencies.paymentController();
  final _ioClient = SingletonsInstances().ioClient;

  final _logger = SingletonsInstances().logger;

  Future<void> payment({BuildContext? context}) async {
    try {
      Uri uri = Uri.parse(Endpoints.gerarCobrancaPix());

      Map<String, dynamic> bodyRequest = {
        'serial': _configController.serialDevice,
        'valor': _paymentController.enteredValue.value,
      };

      var response = await _ioClient
          .post(uri, headers: Auth.header, body: jsonEncode(bodyRequest))
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        if (result['success'] == true) {
          _handleSuccess(context ?? Get.context!, result);
          return;
        }
        _handleErrorFromApi(context ?? Get.context!, result['message']);
        return;
      }
      _handleError(context ?? Get.context!, response.body);
    } catch (e) {
      _handleError(context ?? Get.context!, e.toString());
    }
  }

  Future<void> _handleSuccess(BuildContext context, dynamic result) async {
    String txid = result['data']['txid'];
    String qrCode = result['data']['qrcode'];
    PixApi().isolateMonitoring(context,
        hash: txid,
        serial: _configController.serialDevice,
        endpoint: Endpoints.consultarPagamentoPix());
    await Get.dialog(
      barrierDismissible: false,
      PenseBankDialog(
        qrCode: qrCode,
        hash: txid,
      ),

      //TODO receber o qrcode e o hash
    );
  }

  _handleErrorFromApi(BuildContext context, String message) {
    _logger.e('Erro ao gerar o QrCode. $message');
    CustomCherryError(
      message: message,
    ).show(context);
    Get.back();
  }

  void _handleError(BuildContext context, String message) {
    _logger.e('Erro ao gerar o QrCode. $message');
    CustomCherryError(
      message: 'Erro ao gerar o QrCode. $message',
    ).show(context);
    Get.back();
  }
}
