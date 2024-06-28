// ignore_for_file: prefer_final_fields

import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:megga_posto_mobile/model/collections/payment_form.dart';
import 'package:megga_posto_mobile/model/payment_executed_model.dart';

class PaymentController extends GetxController {
  TextEditingController codeFidelityController = TextEditingController();

  List<PaymentForm> paymentForms = [];
  List<String> paymentFormsDocto = [];
  late Uint8List assignaturePng = Uint8List(0);

  RxList<PaymentExecuted> listPaymentsSelected = <PaymentExecuted>[].obs;

  // Variável que armazenará o valor somado dos pagamentos
  RxDouble valuePayment = 0.0.obs;
  RxDouble enteredValue = 0.0.obs;

  bool isAutoFilled = true;

  Timer? timerIsolate;

  Timer? timerButton;
}
