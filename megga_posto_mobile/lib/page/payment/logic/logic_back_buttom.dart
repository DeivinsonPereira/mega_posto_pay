import 'package:get/get.dart';
import 'package:megga_posto_mobile/utils/dependencies.dart';
import 'package:megga_posto_mobile/utils/methods/payment/payment_features.dart';

class LogicBackButtom {
  var billController = Dependencies.billController();
  final _paymentFeatures = PaymentFeatures();

  void backButtom() {
    _paymentFeatures.clearAll();
    Get.back();
  }
}
