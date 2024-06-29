import 'package:get/get.dart';
import 'package:megga_posto_mobile/common/custom_cherry.dart';
import 'package:megga_posto_mobile/page/loading/loading_page.dart';
import 'package:megga_posto_mobile/service/management_requests/cancel_sell.dart';
import 'package:megga_posto_mobile/utils/dependencies.dart';

class LogicCancelSell {
  final _managementController = Dependencies.managementController();

  void backButton() {
    _managementController.motivoController.text = '';
    Get.back();
  }

  Future<void> sendCancel() async {
    if (_managementController.motivoController.text == '') {
      const CustomCherryError(
        message: 'Por favor, informe o motivo do cancelamento.',
      ).show(Get.context!);
      return;
    }

    if (_managementController.motivoController.text.length < 15) {
      const CustomCherryError(
        message: 'O motivo deve ter pelo menos 15 caracteres.',
      ).show(Get.context!);
      return;
    }

    Get.dialog(const LoadingPage());
    await CancellSell().cancel();
  }
}
