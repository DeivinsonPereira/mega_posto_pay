import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/io_client.dart';
import 'package:megga_posto_mobile/common/custom_cherry.dart';
import 'package:megga_posto_mobile/model/payment_pix_model.dart';
import 'package:megga_posto_mobile/service/payment_service/logic_finish_payment.dart';
import 'package:megga_posto_mobile/service/payment_service/pix_payment.dart/common/isolate_pix_manager.dart';
import 'package:megga_posto_mobile/utils/auth.dart';
import 'package:megga_posto_mobile/utils/method_quantity_back.dart';
import 'package:megga_posto_mobile/utils/methods/payment/payment_features.dart';

class MonitoringPixApi {
  final _isolatePixManager = IsolatePixManager.instance;

  Future<void> monitoring(BuildContext context, String serialDevice,
      String hash, String endpoint) async {
    final _paymentFeatures = PaymentFeatures();
    final receivePort = ReceivePort();
    final isolate = await Isolate.spawn(_monitoring, receivePort.sendPort);

    final sendPort = await receivePort.first as SendPort;
    final responsePort = ReceivePort();

    _isolatePixManager.startVariables(
        isolate, receivePort, responsePort, sendPort);

    final credentials = {
      'serial': serialDevice,
      'txid': hash,
      'endpoint': endpoint,
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
    final serial = args[1]['serial'] as String;
    final txid = args[1]['txid'] as String;
    final endpoint = args[1]['endpoint'] as String;

    const timeout = Duration(minutes: 5);
    final endTime = DateTime.now().add(timeout);

    while (DateTime.now().isBefore(endTime)) {
      final result = await _getStatusPix(serial, txid, endpoint);
      responseSendPort.send(result);

      await Future.delayed(const Duration(seconds: 10));
    }

    responseSendPort.send("TIMEOUT");
  }

  void _handleApproved(BuildContext context, String hash) {
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

    Get.back();
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

  // Monitora o status do pagamento
  Future<bool> _getStatusPix(
      String serial, String txid, String endpoint) async {
    Uri uri = Uri.parse(endpoint);

    var requestBody = {
      'serial': serial,
      'txid': txid,
    };
    final HttpClient _client = HttpClient()
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);

    final IOClient _ioClient = IOClient(_client);

    try {
      var response = await _ioClient.post(uri,
          headers: Auth.header, body: jsonEncode(requestBody));

      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        //TODO implementar
        if (result['success'] == true) {
          return result['data']['codigo'] == '1';
        }
        if (kDebugMode) print('Pago: ${result['message']}');

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
