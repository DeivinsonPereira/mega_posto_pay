// ignore_for_file: prefer_typing_uninitialized_variables, unused_local_variable

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class SmartGenericPrint extends GetxController {
  static const platformMethodChannel = MethodChannel("com.pagamento");

  @override
  Future<void> onInit() async {
    super.onInit();
  }

  @override
  void onClose() {}

  Future<void> print(String json) async {
    String message = "";

    try {
      await platformMethodChannel.invokeMethod('print', {"json": json});
    } on PlatformException catch (e) {
      message = "Erro print deeplink: ${e.message}.";
    }
    debugPrint(message);
  }

  Future<void> printBMP(Uint8List img) async {
    String message = "";

    try {
      await platformMethodChannel.invokeMethod('print_img', {"img": img});
    } on PlatformException catch (e) {
      message = "Erro print deeplink: ${e.message}.";
    }
    debugPrint(message);
  }
}
