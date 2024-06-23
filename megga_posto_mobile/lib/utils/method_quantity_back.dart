import 'package:get/get.dart';

class QuantityBack {
  QuantityBack._privateConstructor();

  static void back(int quantity) {
    for (var i = 0; i < quantity; i++) {
      Get.back();
    }
  }
}
