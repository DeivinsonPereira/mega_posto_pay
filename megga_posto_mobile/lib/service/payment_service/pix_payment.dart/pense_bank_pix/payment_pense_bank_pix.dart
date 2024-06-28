import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:megga_posto_mobile/common/custom_cherry.dart';
import 'package:megga_posto_mobile/page/payment/pages/pense_bank_dialog.dart';
import 'package:megga_posto_mobile/service/payment_service/pix_payment.dart/pense_bank_pix/model/pense_bank_pix_request.dart';
import 'package:megga_posto_mobile/service/payment_service/pix_payment.dart/pense_bank_pix/pense_bank_pix.dart';
import 'package:megga_posto_mobile/utils/dependencies.dart';
import 'package:megga_posto_mobile/utils/endpoints.dart';
import 'package:megga_posto_mobile/utils/generate_random_alias.dart';
import 'package:megga_posto_mobile/utils/singletons_instances.dart';

class PaymentPenseBankPix {
  final _configController = Dependencies.configController();
  final _paymentController = Dependencies.paymentController();
  final _ioClient = SingletonsInstances().ioClient;

  final _logger = SingletonsInstances().logger;

  Future<void> payment({BuildContext? context}) async {
    try {
      Uri uri = Uri.parse(Endpoints.penseBankPix('Pix'));

      String tokenPix =
          'Bearer ${_configController.dataPos.credenciaisPix?[0].token}';

      Map<String, String> headerJson = {
        'Authorization': tokenPix,
      };

      PenseBankPixRequest bodyRequest = PenseBankPixRequest(
        alias: GenerateRandomAlias().generateUUID(),
        totalAmount: _paymentController.enteredValue.value,
        cnpjSh: '04336126000192', // cnpj fixo da softwarehouse
      );

      if (kDebugMode) {
        print(bodyRequest.toJson());
      }

      var response = await _ioClient.post(uri,
          headers: headerJson, body: bodyRequest.toJson());

      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        if (result['success'] == true) {
          _handleSuccess(context ?? Get.context!, result);
          return;
        }
        _handleError(context ?? Get.context!, result['message']);
        return;
      }
      _handleError(context ?? Get.context!, response.body);
    } catch (e) {
      _handleError(context ?? Get.context!, e.toString());
    }
  }

  Future<void> _handleSuccess(BuildContext context, dynamic result) async {
    String hash = result['message']['hash'];
    String qrCode = result['message']['qrcode'];
    PenseBankPix().isolateMonitoring(context, hash: hash);
    await Get.dialog(
      barrierDismissible: false,
      PenseBankDialog(
        qrCode: qrCode,
        hash: hash,
      ),
    );
  }

  void _handleError(BuildContext context, String message) {
    _logger.e('Erro ao gerar o QrCode. $message');
    CustomCherryError(
      message: 'Erro ao gerar o QrCode. $message',
    ).show(context);
  }
}
