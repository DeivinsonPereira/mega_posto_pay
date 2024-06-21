import 'package:get/get.dart';

class QuantityBack {
  static void back(int quantity) {
    for (var i = 0; i < quantity; i++) {
      Get.back();
    }
  }
}
