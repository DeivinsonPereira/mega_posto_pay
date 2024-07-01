import 'package:get/get.dart';
import 'package:megga_posto_mobile/controller/camera_controller.dart';
import 'package:megga_posto_mobile/service/payment_service/logic_finish_payment.dart';
import 'package:megga_posto_mobile/utils/dependencies.dart';
import 'package:megga_posto_mobile/utils/method_quantity_back.dart';

class LogicButtonsCamera {
  void backButton() {
    if (Get.isRegistered<CameraPhotoController>()) {
      final _cameraPhotoController = Dependencies.cameraPhotoController();
      _cameraPhotoController.clearCamera();
      Get.back();
    }
  }

  void continueButton() {
    LogicFinishPayment().confirmPayment('NT').then((element) {
      QuantityBack.back(2);
    });
  }
}
