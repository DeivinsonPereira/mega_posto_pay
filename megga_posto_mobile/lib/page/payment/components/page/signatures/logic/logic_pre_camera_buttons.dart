import 'package:get/get.dart';
import 'package:megga_posto_mobile/page/payment/components/page/signatures/camera_page.dart';
import 'package:megga_posto_mobile/page/payment/enum/modalidade_payment.dart';
import 'package:megga_posto_mobile/service/payment_service/logic_finish_payment.dart';

class LogicPreCameraButtons {
  Future<void> backButton() async {
    await LogicFinishPayment().confirmPayment(ModalidadePaymment.NOTA);
    Get.back();
  }

  Future<void> continueButton() async {
    Get.to(() => const CameraPage());
  }
}
