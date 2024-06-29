import 'package:get/get.dart';
import 'package:megga_posto_mobile/service/payment_service/logic_finish_payment.dart';
import 'package:megga_posto_mobile/utils/dependencies.dart';
import 'package:megga_posto_mobile/utils/method_quantity_back.dart';

class LogicButtonsCamera {
  final _cameraPhotoController = Dependencies.cameraPhotoController();

  void backButton() {
    _cameraPhotoController.clearCamera();
    Get.back();
  }

  void continueButton() {
    LogicFinishPayment().confirmPayment('NT').then((element) {
      _cameraPhotoController.clearCamera();
      QuantityBack.back(2);
    });
  }
}
