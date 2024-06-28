import 'package:flutter/material.dart';
import 'package:megga_posto_mobile/service/payment_service/pix_payment.dart/interface/i_pix_pdv.dart';
import 'package:megga_posto_mobile/service/payment_service/pix_payment.dart/pense_bank_pix/monitoring_pense_bank_pix.dart';
import 'package:megga_posto_mobile/service/payment_service/pix_payment.dart/pense_bank_pix/payment_pense_bank_pix.dart';
import 'package:pixpdv_sdk/pixpdv_sdk.dart';

class PenseBankPix implements IPixPdv {
  @override
  Future<void> isolateMonitoring(BuildContext context,
      {QrDinamicoResult? qrdinamico, PixPdvSdk? sdk, String? hash}) async {
    if (hash == null || hash == '') return;
    MonitoringPenseBankPix().monitoring(context, hash);
  }

  @override
  Future<void> payment({BuildContext? context}) async {
    PaymentPenseBankPix().payment();
  }
}
