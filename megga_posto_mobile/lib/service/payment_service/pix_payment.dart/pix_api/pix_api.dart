import 'package:flutter/material.dart';
import 'package:megga_posto_mobile/service/payment_service/pix_payment.dart/interface/i_pix_pdv.dart';
import 'package:megga_posto_mobile/service/payment_service/pix_payment.dart/pix_api/monitoring_pix_api.dart';
import 'package:megga_posto_mobile/service/payment_service/pix_payment.dart/pix_api/payment_pix_api.dart';
import 'package:megga_posto_mobile/utils/dependencies.dart';
import 'package:pixpdv_sdk/pixpdv_sdk.dart';

class PixApi implements IPixPdv {
  final configController = Dependencies.configController();
  @override
  Future<void> isolateMonitoring(BuildContext context,
      {QrDinamicoResult? qrdinamico,
      PixPdvSdk? sdk,
      String? hash,
      String? serial,
      String? endpoint}) async {
    if (serial == null ||
        serial == '' ||
        hash == null ||
        hash == '' ||
        endpoint == null ||
        endpoint == '') return;
    MonitoringPixApi().monitoring(context, serial, hash, endpoint);
  }

  @override
  Future<void> payment({BuildContext? context}) async {
    PaymentPixApi().payment();
  }
}
