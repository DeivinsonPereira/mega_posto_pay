import 'dart:async';
import 'dart:convert';
import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:megga_posto_mobile/common/custom_cherry.dart';
import 'package:megga_posto_mobile/model/payment_pix_model.dart';
import 'package:megga_posto_mobile/page/payment/enum/modalidade_payment.dart';
import 'package:megga_posto_mobile/service/execute_sell/execute_sell.dart';
import 'package:megga_posto_mobile/service/payment_service/logic_finish_payment.dart';
import 'package:megga_posto_mobile/service/payment_service/pix_payment.dart/common/isolate_pix_manager.dart';
import 'package:megga_posto_mobile/utils/dependencies.dart';
import 'package:megga_posto_mobile/utils/endpoints.dart';
import 'package:megga_posto_mobile/utils/method_quantity_back.dart';
import 'package:megga_posto_mobile/utils/methods/bill/bill_features.dart';
import 'package:megga_posto_mobile/utils/methods/payment/payment_features.dart';
import 'package:http/http.dart' as http;

class MonitoringPenseBankPix {
  final _isolatePixManager = IsolatePixManager.instance;

  Future<void> monitoring(BuildContext context, String hash) async {
    final _paymentFeatures = PaymentFeatures();
    final configController = Dependencies.configController();
    final receivePort = ReceivePort();
    final isolate = await Isolate.spawn(_monitoring, receivePort.sendPort);

    final sendPort = await receivePort.first as SendPort;
    final responsePort = ReceivePort();

    _isolatePixManager.startVariables(
        isolate, receivePort, responsePort, sendPort);

    final credentials = {
      "hash": hash,
      "token": configController.dataPos.credenciaisPix?[0].token
    };

    sendPort.send([responsePort.sendPort, credentials]);

    _paymentFeatures.startTimerIsolate(const Duration(minutes: 5), () {
      _handleExpired(context);
    });

    await for (var message in responsePort) {
      if (message == true) {
        _handleApproved(context, hash);
      }
    }
  }

  Future<void> _monitoring(SendPort sendPort) async {
    final receivePort = ReceivePort();
    sendPort.send(receivePort.sendPort);

    final args = await receivePort.first as List;
    final responseSendPort = args[0] as SendPort;
    final hash = args[1]['hash'] as String;
    final tokenPix = args[1]['token'] as String;

    const timeout = Duration(minutes: 5);
    final endTime = DateTime.now().add(timeout);

    while (DateTime.now().isBefore(endTime)) {
      final result = await _getStatusPix(hash, tokenPix);
      responseSendPort.send(result);

      await Future.delayed(const Duration(seconds: 10));
    }

    responseSendPort.send("TIMEOUT");
  }

  void _handleApproved(BuildContext context, String hash) {
    final paymentFeatures = PaymentFeatures();

    paymentFeatures.addSelectedPayment(ModalidadePaymment.PIX);
    const CustomCherrySuccess(message: 'Pagamento efetuado com sucesso!')
        .show(context);
    _quantityBack(hash);
    _cancelTimer();
    _isolatePixManager.kill();
  }

  Future<void> _quantityBack(String hash) async {
    // final _paymentGet = PaymentGet();

    // await InsertDataPix().insert(_paymentGet.getEnteredValue(), );

    PaymentPixModel dadosPix = PaymentPixModel(retornopix: hash);

    LogicFinishPayment().confirmPayment('PX', dadosPix: dadosPix);

    //QuantityBack.back(3);
    //_paymentFeatures.clearEnteredValue();
  }

  void _handleExpired(BuildContext context) {
    final paymentFeatures = PaymentFeatures();
    paymentFeatures.clearEnteredValue();
    const CustomCherryError(message: 'Pagamento expirado, tente novamente')
        .show(context);
    QuantityBack.back(4);
    _cancelTimer();
    _isolatePixManager.kill();
  }

  void _executeFinally() {
    final _paymentFeatures = PaymentFeatures();
    final _billFeatures = BillFeatures();
    ExecuteSell().executeSell();
    _billFeatures.clearAll();
    _paymentFeatures.clearAll();
  }

  // Monitora o status do pagamento
  Future<bool> _getStatusPix(String hash, String token) async {
    Uri uri = Uri.parse(Endpoints.statusPenseBankPix(hash));

    String tokenPix = 'Bearer $token';

    Map<String, String> headerJson = {
      'Authorization': tokenPix,
    };
    try {
      var response = await http.get(uri, headers: headerJson);
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);

        if (result['success'] == true) {
          return result['message']['pago'];
        }
        if (kDebugMode) print('Pago: ${result['message']['pago']}');

        return false;
      }

      if (kDebugMode) print('Erro: ${response.statusCode}');
      return false;
    } catch (e) {
      if (kDebugMode) print('Erro: $e');
      return false;
    }
  }

  void _cancelTimer() {
    final _paymentFeatures = PaymentFeatures();
    _paymentFeatures.cancelTimer();
  }
}
